//
//  ViewStateMock.swift
//  MVVMC
//
//  Created by Eric Garcia on 6/2/19.
//  Copyright © 2019 Eric Garcia. All rights reserved.
//

@testable import MVVMC

struct ViewStateMock: ViewState {
    
    let text: String
    
    init(text: String) {
        self.text = text
    }
    
    static func ==(lhs: ViewStateMock, rhs: ViewStateMock) -> Bool {
        return lhs.text == rhs.text
    }
    
}
