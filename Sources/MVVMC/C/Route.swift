//
//  Route.swift
//  MVVMC
//
//  Created by Eric Garcia on 6/17/19.
//  Copyright © 2019 Eric Garcia. All rights reserved.
//

import Foundation

public protocol Route {

    static var scene: Scene { get }

    init?(scene: Scene, queryParameters: [QueryParameter : String])

}
