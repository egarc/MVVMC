import Foundation
import MVVMC

/// The required parameters for navigating to the ___VARIABLE_sceneName___ scene.
struct ___VARIABLE_sceneName___Route {

    init() { }

}

extension ___VARIABLE_sceneName___Route: Route {

    /// The associated scene.
    static var scene: Scene = .___VARIABLE_sceneIdentifier___

    /// Attempt to initialize with the given scene and query parameters. If the scene does not
    /// match, or if the required parameters are not present in the queryParameters dictionary,
    /// the initialization will fail.
    ///
    /// - Parameters:
    ///   - scene: The scene to create -- has to match the ___VARIABLE_sceneName___Route.scene.
    ///   - queryParameters: The parameter dictionary to pull all required parameter values from.
    init?(scene: Scene, queryParameters: [QueryParameter : String]) {
        guard scene == ___VARIABLE_sceneName___Route.scene else { return nil }
    }

}
