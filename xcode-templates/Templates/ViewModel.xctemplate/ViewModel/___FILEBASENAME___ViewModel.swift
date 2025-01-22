import Foundation
import MVVMC

/// Formats the ___VARIABLE_sceneName___State for view consumption. Decides how the data will
/// be presented to the user.
final class ___VARIABLE_sceneName___ViewModel: ViewModel<___VARIABLE_sceneName___ViewState> {

    // MARK: -
    // MARK: Public Properties

    /// The delegate responsible for handling navigation.
    weak var delegate: ___VARIABLE_sceneName___ViewModelDelegate?

    // MARK: -
    // MARK: Private Properties
    
    /// The store holding the domain state.
    fileprivate let store: Store<___VARIABLE_sceneName___State> & ___VARIABLE_sceneName___StoreCommands

    // MARK: -
    // MARK: Lifecycle
    
    /// Creates a new ___VARIABLE_sceneName___ViewModel.
    ///
    /// - Parameters:
    ///   - delegate: The `___VARIABLE_sceneName___ViewModelDelegate` for handling navigation.
    ///   - store: The store to subscribe to and update.
    init(delegate: ___VARIABLE_sceneName___ViewModelDelegate?,
         store: Store<___VARIABLE_sceneName___State> & ___VARIABLE_sceneName___StoreCommands) {
        self.delegate = delegate
        self.store = store
        
        super.init(initialState: ___VARIABLE_sceneName___ViewState())
        
        subscribe(to: store) { [weak self] in self?.processDomainStateChange(state: $0) }
    }

}

// MARK: -
// MARK: ___VARIABLE_sceneName___ViewModelProtocol

extension ___VARIABLE_sceneName___ViewModel: ___VARIABLE_sceneName___ViewModelProtocol {
    
    
    
}

// MARK: -
// MARK: State Changes

private extension ___VARIABLE_sceneName___ViewModel {
    
    /// Translates `___VARIABLE_sceneName___State` into `___VARIABLE_sceneName___ViewState` and updates
    /// self's state.
    ///
    /// - Parameter state: The `___VARIABLE_sceneName___State` to process.
    func processDomainStateChange(state: ___VARIABLE_sceneName___State) {
        let newState = ___VARIABLE_sceneName___ViewState()
        
        write { self.state = newState }
    }
    
}
