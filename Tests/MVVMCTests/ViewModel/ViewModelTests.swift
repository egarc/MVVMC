//
//  ViewModelTests.swift
//  MVVMC
//
//  Created by Eric Garcia on 6/3/19.
//  Copyright © 2019 Eric Garcia. All rights reserved.
//

import XCTest
@testable import MVVMC

class ViewModelTests: XCTestCase {
    
    var view1: StatefulViewSpy!
    
    var view2: StatefulViewSpyTwo!
    
    var viewModel: ViewModelMock!
    
    var token: StoreSubscription<ViewStateMock>!
    
    override func setUp() {
        super.setUp()
        
        view1 = StatefulViewSpy()
        view2 = StatefulViewSpyTwo()
        viewModel = ViewModelMock(initialState: ViewStateMock(text: "InitialState"))
    }
    
    override func tearDown() {
        view1 = nil
        view2 = nil
        viewModel = nil
        token = nil
        
        super.tearDown()
    }
    
    // MARK: -
    // MARK: Tests
    
    func testRenderMethodCalledWhenSubscribed() {
        viewModel.subscribe(from: view1)
        viewModel.subscribe(from: view2)
        
        viewModel.expectation = expectation(description: "should get 'Done' state")
        viewModel.write { self.viewModel.state = ViewStateMock(text: "Done") }
        waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
            XCTAssertEqual(self.view1.numberOfRenderCalls, 2)
            XCTAssertEqual(self.view2.numberOfRenderCalls, 2)
            XCTAssertEqual(self.view1.stateHistory.map { $0.text }, ["InitialState", "Done"])
            XCTAssertEqual(self.view2.stateHistory.map { $0.text }, ["InitialState", "Done"])
        }
    }
    
    func testRenderMethodCalledTwiceForInitialAndStateChange() {
        viewModel.subscribe(from: view1)
        viewModel.subscribe(from: view2)
        viewModel.expectation = expectation(description: "should get 'Done' state")

        viewModel.write { self.viewModel.state = ViewStateMock(text: "NewState") }
        viewModel.write { self.viewModel.state = ViewStateMock(text: "Done") }
        
        waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
            XCTAssertEqual(self.view1.numberOfRenderCalls, 3)
            XCTAssertEqual(self.view2.numberOfRenderCalls, 3)
            XCTAssertEqual(self.view1.state, self.viewModel.state)
            XCTAssertEqual(self.view2.state, self.viewModel.state)
        }
    }
    
    func testRenderMethodNotCalledWhenSetSameState() {
        viewModel.subscribe(from: view1)
        viewModel.subscribe(from: view2)
        viewModel.expectation = expectation(description: "should get 'Done' state")

        viewModel.write { self.viewModel.state = ViewStateMock(text: "InitialState") }
        viewModel.write { self.viewModel.state = ViewStateMock(text: "Done") }
        
        waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
            XCTAssertEqual(self.view1.numberOfRenderCalls, 2)
            XCTAssertEqual(self.view2.numberOfRenderCalls, 2)
            XCTAssertEqual(self.view1.state, self.viewModel.state)
            XCTAssertEqual(self.view2.state, self.viewModel.state)
        }
    }
    
    func testRenderMethodNotCalledAfterUnsubscribed() {
        let view1Identifier = viewModel.subscribe(from: view1)
        let view2Identifier = viewModel.subscribe(from: view2)
        viewModel.unsubscribe(viewWithIdentifier: view1Identifier)
        viewModel.unsubscribe(viewWithIdentifier: view2Identifier)

        viewModel.expectation = expectation(description: "should get 'Done' state")
        viewModel.write { self.viewModel.state = ViewStateMock(text: "Done") }

        waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
            XCTAssertEqual(self.view1.numberOfRenderCalls, 1)
            XCTAssertEqual(self.view2.numberOfRenderCalls, 1)
        }
    }
    
    func testViewModelDoesNotRetainViews() {
        weak var weakView1 = view1
        weak var weakView2 = view2
        viewModel.subscribe(from: view1)
        viewModel.subscribe(from: view2)
        view1 = nil
        view2 = nil
        XCTAssertNil(weakView1)
        XCTAssertNil(weakView2)
        
        viewModel.expectation = expectation(description: "should get 'Done' state")
        viewModel.write { self.viewModel.state = ViewStateMock(text: "Done") }
        waitForExpectations(timeout: 3.0)
    }
    
    func testViewModelForwardsStateChangesToRemainingViewsWhenSomeViewIsDeallocated() {
        weak var weakView2 = view2
        viewModel.subscribe(from: view1)
        viewModel.subscribe(from: view2)
        view2 = nil
        
        viewModel.expectation = expectation(description: "should get 'Done' state")
        viewModel.write { self.viewModel.state = ViewStateMock(text: "Done") }
        
        waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
            XCTAssertNil(weakView2)
            XCTAssertEqual(self.view1.numberOfRenderCalls, 2)
            XCTAssertEqual(self.view1.stateHistory.map { $0.text }, ["InitialState", "Done"])
        }
    }
    
    func testViewModelForwardsStateToViewAndOtherViewModelsCorrectly() {
        let anotherViewModel = ViewModelMock(initialState: ViewStateMock(text: "AnotherState"))
        viewModel.subscribe(from: view1)

        var state: ViewStateMock?
        var numberOfSubscriptionCalls = 0
        viewModel.subscribe(to: anotherViewModel) { anotherState in
            state = anotherState
            numberOfSubscriptionCalls += 1
        }
        
        anotherViewModel.expectation = expectation(description: "should get 'Done' state")
        anotherViewModel.write { anotherViewModel.state = ViewStateMock(text: "Done") }
        waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
            XCTAssertEqual(self.view1.numberOfRenderCalls, 1)
            XCTAssertEqual(numberOfSubscriptionCalls, 2)
            XCTAssertEqual(state?.text, "Done")
        }

    }
    
}

// MARK: -
// MARK: Helpers

class ViewModelMock: ViewModel<ViewStateMock> {
    
    var expectation: XCTestExpectation?
    
    override var state: ViewStateMock {
        didSet(oldState) {
            let localState = state
            DispatchQueue.main.async {
                if localState.text == "Done" {
                    self.expectation?.fulfill()
                }
            }
        }
    }
    
}
