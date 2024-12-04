//
//  StoreTests.swift
//  MVVMC
//
//  Created by Eric Garcia on 6/2/19.
//  Copyright © 2019 Eric Garcia. All rights reserved.
//

import XCTest
@testable import MVVMC

class StoreTests: XCTestCase {
    
    private var currentStoreSubscription: StoreSubscription<DomainStateMock>!
    
    private var store: StoreMock!
    
    private var token: StoreSubscription<DomainStateMockTwo>!
    
    override func setUp() {
        super.setUp()
        
        let initialState = DomainStateMock(text: "Initial state")
        store = StoreMock(initialState: initialState)
    }
    
    override func tearDown() {
        currentStoreSubscription = nil
        store = nil
        token = nil
        
        super.tearDown()
    }
    
    // MARK: -
    // MARK: Tests
    
    func testStoreReceivesCorrectInitialState() {
        let initialState = DomainStateMock(text: "Initial state")
        let store = StoreMock(initialState: initialState)
        XCTAssertEqual(store.state, initialState)
    }
    
    func testStoreSendsCurrentStateOnSubscription() {
        var currentState: DomainStateMock?
        currentStoreSubscription = store.subscribe { currentState = $0 }
        XCTAssertEqual(currentState, store.state)
    }
    
    func testStoreForwardsCorrectState() {
        var numberOfNotifyStateChangeCalls = 0
        let expect = expectation(description: "should get 'Done' state")
        currentStoreSubscription = store.subscribe { state in
            numberOfNotifyStateChangeCalls += 1
            if state.text == "Done" {
                expect.fulfill()
            }
        }
        
        store.write {
            self.store.state = DomainStateMock(text: "Another state")
            self.store.state = DomainStateMock(text: "Done")
        }
        
        waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
            XCTAssertEqual(numberOfNotifyStateChangeCalls, 3)
        }
    }
    
    func testStoreDoesNotForwardSameState() {
        var numberOfNotifyStateChangeCalls = 0
        let expect = expectation(description: "should get 'Done' state")
        currentStoreSubscription = store.subscribe { state in
            numberOfNotifyStateChangeCalls += 1
            if state.text == "Done" {
                expect.fulfill()
            }
        }
        
        store.write {
            self.store.state = DomainStateMock(text: "Another state")
            self.store.state = DomainStateMock(text: "Another state")
            self.store.state = DomainStateMock(text: "Done")
        }
        
        waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
            XCTAssertEqual(numberOfNotifyStateChangeCalls, 3)
        }
    }
    
    func testStoreForwardsStateToOtherStoresCorrectly() {
        let firstStore = StoreMockTwo(initialState: DomainStateMockTwo(number: 5))
        let secondStore = StoreMockTwo(initialState: DomainStateMockTwo(number: 10))
        
        var firstState: DomainStateMockTwo?
        var secondState: DomainStateMockTwo?

        var firstNumberOfSubscriptionCalls = 0
        var secondNumberOfSubscriptionCalls = 0

        let expect = expectation(description: "should get '100' state")
        store.subscribe(to: firstStore) { state in
            firstState = state
            firstNumberOfSubscriptionCalls += 1
            if state.number == 100 {
                expect.fulfill()
            }
        }
        
        store.subscribe(to: secondStore) { state in
            secondState = state
            secondNumberOfSubscriptionCalls += 1
            if state.number == 100 {
                XCTFail("should not have gotten '100' state")
            }
        }

        XCTAssertEqual(firstState, firstStore.state)
        XCTAssertEqual(secondState, secondStore.state)
        XCTAssertEqual(firstNumberOfSubscriptionCalls, 1)
        XCTAssertEqual(secondNumberOfSubscriptionCalls, 1)
        XCTAssertEqual(store.state, DomainStateMock(text: "Initial state"))

        let anotherState = DomainStateMockTwo(number: 42)
        firstStore.write { firstStore.state = anotherState }
        
        let doneState = DomainStateMockTwo(number: 100)
        firstStore.write { firstStore.state = doneState }
        
        waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
            XCTAssertEqual(firstState, doneState)
            XCTAssertEqual(firstNumberOfSubscriptionCalls, 3)
            XCTAssertEqual(secondState?.number, 10)
            XCTAssertEqual(secondNumberOfSubscriptionCalls, 1)
        }        
    }
    
    func testStoreDoesNotReceiveOtherStoreUpdatesAfterUnsubscribe() {
        let mainStore = StoreMock(initialState: DomainStateMock(text: "InitialState"))
        let numberStore = StoreMockTwo(initialState: DomainStateMockTwo(number: 5))
        var state: DomainStateMockTwo?
        var numberOfSubscriptionCalls = 0
        
        mainStore.subscribe(to: numberStore) { numState in
            state = numState
            numberOfSubscriptionCalls += 1
        }
        
        let expect = expectation(description: "should get '100' state")
        token = numberStore.subscribe { numState in
            if numState.number == 100 {
                expect.fulfill()
            }
        }
        
        mainStore.unsubscribe(from: numberStore)
        numberStore.write { numberStore.state = DomainStateMockTwo(number: 100) }
        
        waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
            XCTAssertEqual(state?.number, 5)
            XCTAssertEqual(numberOfSubscriptionCalls, 1)
        }
    }
    
    func testOtherStoreSubscriptionBlockIsNotFiredAfterStoreIsDeallocated() {
        let numberStore = StoreMockTwo(initialState: DomainStateMockTwo(number: 5))
        var state: DomainStateMockTwo?
        var numberOfSubscriptionCalls = 0

        store.subscribe(to: numberStore) { numState in
            state = numState
            numberOfSubscriptionCalls += 1
        }
        
        numberStore.expectation = expectation(description: "should get '100' state")

        weak var weakStore = store
        store = nil
        XCTAssertNil(weakStore)
        numberStore.write { numberStore.state = DomainStateMockTwo(number: 100) }
        
        waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
            XCTAssertEqual(state?.number, 5)
            XCTAssertEqual(numberOfSubscriptionCalls, 1)
        }
    }
    
    func testNoDeadlockWhenSubscriptionBlockCausesAStateChange() {
        let numberStore = StoreMockTwo(initialState: DomainStateMockTwo(number: 5))
        var numberOfSubscriptionCalls = 0

        numberStore.expectation = expectation(description: "should get '100' state")
        token = numberStore.subscribe { state in
            numberOfSubscriptionCalls += 1
            if state.number == 10 {
                numberStore.write { numberStore.state = DomainStateMockTwo(number: 100) }
            }
        }

        numberStore.write { numberStore.state = DomainStateMockTwo(number: 10) }

        waitForExpectations(timeout: 3.0) { (error) in
            XCTAssertNil(error)
            XCTAssertEqual(numberOfSubscriptionCalls, 3)
        }
    }
    
}

// MARK: -
// MARK: Helpers

private class StoreMock: Store<DomainStateMock> {}

private class StoreMockTwo: Store<DomainStateMockTwo> {
    
    var expectation: XCTestExpectation?
    
    override var state: DomainStateMockTwo {
        didSet(oldState) {
            let localState = state
            DispatchQueue.main.async {
                if localState.number == 100 {
                    self.expectation?.fulfill()
                }
            }
        }
    }

}
