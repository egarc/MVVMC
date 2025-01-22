import UIKit
import MVVMC

/// The `NavigationCoordinator` responsible for the `___VARIABLE_sceneIdentifier___` scene.
/// It acts as the delegate for the `___VARIABLE_sceneName___ViewModel`.
final class ___VARIABLE_sceneName___Coordinator {

    // MARK: -
    // MARK: Public Properties

    /// The delegate to receive callbacks when this coordinator has been dismissed.
    weak var delegate: ___VARIABLE_sceneName___CoordinatorDelegate?

    // MARK: -
    // MARK: Private Properties

    /// The view controller that will be presenting the `___VARIABLE_sceneName___ViewController`.
    fileprivate var rootViewController: UIViewController?

    /// The view that is being presented, and should be passed to child coordinators
    /// as the presenter.
    fileprivate var ___VARIABLE_sceneIdentifier___ViewController: ___VARIABLE_sceneName___ViewController?

    // MARK: -
    // MARK: Lifecycle

    /// Create a new `___VARIABLE_sceneName___Coordinator` for presenting the
    /// `___VARIABLE_sceneIdentifier___` scene.
    ///
    /// - Parameters:
    ///   - rootViewController: The viewcontroller that will present the `___VARIABLE_sceneName___ViewController`.
    ///   - delegate: The `___VARIABLE_sceneName___CoordinatorDelegate` to receive callbacks on dismissal
    init(rootViewController: UIViewController?,
         delegate: ___VARIABLE_sceneName___CoordinatorDelegate?) {
        self.rootViewController = rootViewController
        self.delegate = delegate
    }

}

// MARK: -
// MARK: ___VARIABLE_sceneName___CoordinatorDelegate

/// Objects must conform to this protocol to become the delegate for the `___VARIABLE_sceneName___Coordinator`.
/// The delegate will receive a callback when the view is dismissed.
protocol ___VARIABLE_sceneName___CoordinatorDelegate: class {

    /// The delegate receives a callback when the coordinator finishes.
    func ___VARIABLE_sceneIdentifier___CoordinatorDidFinish()

}

// MARK: -
// MARK: NavigationCoordinator

extension ___VARIABLE_sceneName___Coordinator: NavigationCoordinator {

    var associatedScene: Scene? { return .___VARIABLE_sceneIdentifier___ }

    func navigateToRoute(_ routes: [Route], animated: Bool) {
        let route = nextRoute(fromRoutes: routes)
        guard let next = route.route else { return }

        switch next {
        case _ as ___VARIABLE_sceneName___Route:
            let vc = create___VARIABLE_sceneName___ViewController()
            ___VARIABLE_sceneIdentifier___ViewController = vc
            rootViewController?.present(vc, animated: animated)
            navigateToRoute(route.remainingRoutes, animated: animated)
        default:
            print("___VARIABLE_sceneName___Coordinator couldn't handle scene: \(type(of: next).scene)")
        }
    }

}

// MARK: -
// MARK: ___VARIABLE_sceneName___ViewModelDelegate

extension ___VARIABLE_sceneName___Coordinator: ___VARIABLE_sceneName___ViewModelDelegate {



}

// MARK: -
// MARK: Assembly Methods

private extension ___VARIABLE_sceneName___Coordinator {

    /// Convenience method for creating a new `___VARIABLE_sceneName___ViewController`.
    ///
    /// - Returns: The new `___VARIABLE_sceneName___ViewController`
    func create___VARIABLE_sceneName___ViewController() -> ___VARIABLE_sceneName___ViewController {
        let store = ___VARIABLE_sceneName___Store()
        let vm = ___VARIABLE_sceneName___ViewModel(delegate: self, store: store)
        return ___VARIABLE_sceneName___ViewController(viewModel: vm)
    }

}
