//
//  StoreSubscriptionSpy.swift
//  MVVMC
//
//  Created by Eric Garcia on 6/3/19.
//  Copyright © 2019 Eric Garcia. All rights reserved.
//

@testable import MVVMC

class StoreSubscriptionSpy: StoreSubscription<DomainStateMock> {
    
    var stopCalledBlock: (() -> Void)?
    
    override func stop() {
        stopCalledBlock?()
        super.stop()
    }
    
}
