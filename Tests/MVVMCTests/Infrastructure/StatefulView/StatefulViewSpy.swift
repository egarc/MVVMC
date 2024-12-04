//
//  StatefulViewSpy.swift
//  MVVMC
//
//  Created by Eric Garcia on 6/2/19.
//  Copyright © 2019 Eric Garcia. All rights reserved.
//

@testable import MVVMC

class StatefulViewSpy: StatefulView {
    
    private(set) var numberOfRenderCalls = 0
    private(set) var state: ViewStateMock!
    private(set) var renderPolicyCalled = false
    private(set) var logDescriptionCalled = false
    private(set) var stateHistory: [ViewStateMock] = []
    
    func render(state: ViewStateMock) {
        self.state = state
        numberOfRenderCalls += 1
        stateHistory.append(state)
    }
    
    var renderPolicy: RenderPolicy {
        renderPolicyCalled = true
        return .possible
    }
    
    var logDescription: String {
        logDescriptionCalled = true
        return String(describing: self)
    }
    
}

class StatefulViewSpyTwo: StatefulViewSpy {}
