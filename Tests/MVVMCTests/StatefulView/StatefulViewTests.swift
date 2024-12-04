//
//  StatefulViewTests.swift
//  MVVMC
//
//  Created by Eric Garcia on 6/3/19.
//  Copyright © 2019 Eric Garcia. All rights reserved.
//

import XCTest
@testable import MVVMC

class StatefulViewTests: XCTestCase {
    
    var viewSpy: StatefulViewSpy!
    
    var statefulView: AnyStatefulView<ViewStateMock>!
    
    override func setUp() {
        super.setUp()
        
        viewSpy = StatefulViewSpy()
        statefulView = AnyStatefulView(viewSpy)
    }
    
    override func tearDown() {
        viewSpy = nil
        statefulView = nil
        
        super.tearDown()
    }
    
    // MARK: -
    // MARK: Tests
    
    func testViewReceivesRenderMethod() {
        statefulView.render(state: ViewStateMock(text: "Text"))
        XCTAssertEqual(viewSpy.numberOfRenderCalls, 1)
    }
    
    func testRenderPolicyMethodCalledInView() {
        _ = statefulView.renderPolicy
        XCTAssertTrue(viewSpy.renderPolicyCalled)
    }
    
    func testLogDescriptionMethodCalledInView() {
        _ = statefulView.logDescription
        XCTAssertTrue(viewSpy.logDescriptionCalled)
    }
    
    func testViewControllerCannotBeRenderedWhenViewDeallocated() {
        weak var weakView = viewSpy
        viewSpy = nil
        XCTAssertNil(weakView)
        XCTAssertEqual(statefulView.renderPolicy, .notPossible(.viewDeallocated))
    }
    
    func testViewControllerCanBeRenderedAppropriatelyWhenViewLoaded() {
        let viewController = RealViewController()
        XCTAssertEqual(viewController.renderPolicy, .notPossible(.viewNotReady))
        
        _ = viewController.view
        XCTAssertEqual(viewController.renderPolicy, .possible)
    }
    
    func testViewCanBeRenderedAppropriatelyWhenAddedToSuperview() {
        let view = RealView()
        XCTAssertEqual(view.renderPolicy, .notPossible(.viewNotReady))
        
        let parentView = UIView()
        parentView.addSubview(view)
        XCTAssertEqual(view.renderPolicy, .possible)
    }
    
}

// MARK: -
// MARK: Helpers

private class RealViewController: UIViewController, StatefulView {
    func render(state: ViewStateMock) {}
}

private class RealView: UIView, StatefulView {
    func render(state: ViewStateMock) {}
}

extension RenderPolicy: @retroactive Equatable {
    public static func ==(lhs: RenderPolicy, rhs: RenderPolicy) -> Bool {
        switch (lhs, rhs) {
        case (.possible, .possible):
            return true
        case (.notPossible(let lhsRenderError), .notPossible(let rhsRenderError)):
            return lhsRenderError == rhsRenderError
        default:
            return false
        }
    }
}

extension RenderPolicy.RenderError {
    public static func ==(lhs: RenderPolicy.RenderError, rhs: RenderPolicy.RenderError) -> Bool {
        switch (lhs, rhs) {
        case (.viewNotReady, .viewNotReady):
            return true
        case (.viewDeallocated, .viewDeallocated):
            return true
        default:
            return false
        }
    }
}
