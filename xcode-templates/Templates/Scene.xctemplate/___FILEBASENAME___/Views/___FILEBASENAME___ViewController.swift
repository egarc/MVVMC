import UIKit
import MVVMC

/// View for
final class ___VARIABLE_sceneName___ViewController: UIViewController {

    /// The viewmodel that serves up the formatted view state.
    fileprivate let viewModel: (ViewModel<___VARIABLE_sceneName___ViewState> & ___VARIABLE_sceneName___ViewModelProtocol)
    
    // MARK: -
    // MARK: Initialization

    init(viewModel: (ViewModel<___VARIABLE_sceneName___ViewState> & ___VARIABLE_sceneName___ViewModelProtocol)) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: -
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        viewModel.subscribe(from: self)
    }

    /*
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if isMovingFromParentViewController {
            viewModel.didBackOutOfScene()
        }
    }
    */

}

// MARK: -
// MARK: StatefulView

extension ___VARIABLE_sceneName___ViewController: StatefulView {
    
    func render(state: ___VARIABLE_sceneName___ViewState) {
    }
    
}

// MARK: -
// MARK: Views and Constraints

private extension ___VARIABLE_sceneName___ViewController {
    
    /// Perform any additional one-time view setup after the view has loaded.
    func setupView() {
    }
    
}

