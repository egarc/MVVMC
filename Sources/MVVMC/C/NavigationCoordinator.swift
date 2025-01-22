//
//  NavigationCoordinator.swift
//  MVVMC
//
//  Created by Eric Garcia on 6/17/19.
//  Copyright © 2019 Eric Garcia. All rights reserved.
//

import UIKit

/// A `NavigationCoordinator` is responsible for managing the presentation and dismissal of a single
/// scene. Many will be responsible for child coordinators, and will communicate changes up the
/// chain with the use of delegates.
///
/// When popping/dismissing views, the view controllers are responsible for relaying their dismissal
/// to the viewmodel, which relays it to the coordinator. The coordinator may then relay that to its
/// own delegate, which is likely responsible for the view that is now visible.
///
/// Coordinators that need to build a store or viewmodel with parameters do so by pulling the
/// parameters out of the corresponding Route.
public protocol NavigationCoordinator {

    /// The `Scene` directly related to the coordinator and what it is presenting.
    ///
    /// Most coordinators should have an `associatedScene`, but there can be exceptions that aren't
    /// tied to a specific scene.
    ///
    /// The `nextRoute(fromRoutes:)` extension makes use of this property by comparing the first
    /// `route.scene` to the `associatedScene` and removing it from the array if it matches.
    var associatedScene: Scene? { get }
    
    /// Creates required view controllers and navigation stack and presents the desired scene.
    ///
    /// Each coordinator must make a decision on how to handle all the scenes it supports.
    /// Typically, if the scene is not the `associatedScene`, it will create a child coordinator
    /// and pass the remaining routes on to the child. If a coordinator receives an unsupported
    /// scene it should stop trying to navigate any further.
    ///
    /// If the scene is the one directly related to a coordinator, it should create and present
    /// the relevant view controller.
    ///
    /// It is possible for a coordinator to ignore a path of scenes if requirements for displaying
    /// the scene are not met. The primary example of this would be when attempting to display a
    /// scene that requires authentication while not authenticated.
    ///
    /// - Parameters:
    ///   - routes: The series of `Route`s to display.
    ///   - presentationStyle: The presentation style of the navigation.
    func navigateToRoute(_ routes: [Route], presentationStyle: PresentationStyle)
    
}

public enum PresentationStyle {
    
    case push(from: UINavigationController)
    
    case present
    
}

public extension NavigationCoordinator {
    
    /// Returns the next route from an array of routes, along with the new array of routes after
    /// conditionally removing the next route.
    ///
    /// If the next `route.scene` matches the `associatedScene` of the coordinator, it will be
    /// omitted from the `Route` array returned as `remainingRoutes`.
    ///
    /// - Parameter routes: The array of routes to pull the next route from.
    /// - Returns: A tuple containing the next route and the remaining array of routes after
    ///     possibly removing the next route.
    func nextRoute(
        fromRoutes routes: [Route])
        -> (route: Route?, remainingRoutes: [Route]) {
            guard let next = routes.first else { return (nil, []) }
            
            if type(of: next).scene == associatedScene {
                return (next, Array(routes.dropFirst()))
            }
            
            return (next, routes)
    }
    
}
