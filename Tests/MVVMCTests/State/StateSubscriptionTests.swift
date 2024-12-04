//
//  StoreSubscriptionTests.swift
//  MVVMC
//
//  Created by Eric Garcia on 5/29/19.
//  Copyright © 2019 Eric Garcia. All rights reserved.
//

import XCTest
@testable import MVVMC

class StoreSubscriptionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: -
    // MARK: Tests
    
    func testStoreSubscriptionBlockIsInvokedCorrectly() {
        var blockFired = false
        let token = StoreSubscription { (state: DomainStateMock) in
            blockFired = true
        }
        
        token.fire(DomainStateMock())
        XCTAssertTrue(blockFired)
    }
    
    func testStoreSubscriptionBlockIsNotInvokedAfterStopping() {
        var blockFired = false
        let token = StoreSubscription { (state: DomainStateMock) in
            blockFired = true
        }
        
        token.stop()
        token.fire(DomainStateMock())
        XCTAssertFalse(blockFired)
    }
    
    func testStoreSubscriptionIsStoppedAfterDeallocation() {
        var stopCalled = false
        
        var token: StoreSubscriptionSpy? = StoreSubscriptionSpy { _ in }
        token?.stopCalledBlock = {
            stopCalled = true
        }
        
        token = nil
        XCTAssertTrue(stopCalled)
    }
    
}


