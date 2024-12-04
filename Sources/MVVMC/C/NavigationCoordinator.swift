//
//  NavigationCoordinator.swift
//  MVVMC
//
//  Created by Eric Garcia on 6/17/19.
//  Copyright © 2019 Eric Garcia. All rights reserved.
//

import UIKit

enum PresentationStyle {
    
    case push(from: UINavigationController)
    
    case present
    
}

protocol NavigationCoordinator {
    
    var associatedScene: Scene? { get }
    
    func navigateToRoute(_ routes: [Route], presentationStyle: PresentationStyle)
    
}
