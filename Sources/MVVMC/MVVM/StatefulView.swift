//
//  StatefulView.swift
//  MVVMC
//
//  Created by Eric Garcia on 6/1/19.
//  Copyright © 2019 Eric Garcia. All rights reserved.
//

import UIKit

/// A view that renders state.
public protocol StatefulView: AnyObject, Loggable {

    associatedtype State: ViewState

    /// This should not be called directly. Instead, subscribe to a view model using `subscribe(from:)`
    /// to receive state changes. This ensures that the view only renders when the following
    /// conditions are met:
    /// 1) When state actually changes; the new state must be different from the previous state.
    /// 2) The view or view controller is currently capable of rendering.
    ///
    /// - Parameter state: The state to render.
    func render(state: State)

    /// Describes whether or not the view can render state.
    var renderPolicy: RenderPolicy { get }

}

public extension StatefulView where Self: UIViewController {

    var renderPolicy: RenderPolicy {
        var policy: RenderPolicy = .notPossible(.viewNotReady)
        
        if Thread.isMainThread {
            policy = isViewLoaded ? .possible : .notPossible(.viewNotReady)
        } else {
            DispatchQueue.main.sync {
                policy = isViewLoaded ? .possible : .notPossible(.viewNotReady)
            }
        }
        
        return policy
    }

    var logDescription: String {
        var description = String(describing: type(of: self))
        
        if Thread.isMainThread {
            description = title ?? String(describing: type(of: self))
        } else {
            DispatchQueue.main.sync {
                description = title ?? String(describing: type(of: self))
            }
        }
        
        return description
    }

}

public extension StatefulView where Self: UIView {

    var renderPolicy: RenderPolicy {
        return superview != nil ? .possible : .notPossible(.viewNotReady)
    }

    var logDescription: String {
        return String(describing: type(of: self))
    }

}
