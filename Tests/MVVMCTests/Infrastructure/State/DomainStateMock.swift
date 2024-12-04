//
//  DomainStateMock.swift
//  MVVMC
//
//  Created by Eric Garcia on 6/4/19.
//  Copyright © 2019 Eric Garcia. All rights reserved.
//

@testable import MVVMC

struct DomainStateMock: DomainState {
    
    let text: String
    
    init(text: String = "") {
        self.text = text
    }
    
    static func ==(lhs: DomainStateMock, rhs: DomainStateMock) -> Bool {
        return lhs.text == rhs.text
    }
    
}

struct DomainStateMockTwo: DomainState {
    
    let number: Int
    
    init(number: Int = 0) {
        self.number = number
    }
    
    static func ==(lhs: DomainStateMockTwo, rhs: DomainStateMockTwo) -> Bool {
        return lhs.number == rhs.number
    }
    
}
