import SwiftUI

// MARK: - SettingsAssembly

public final class SettingsAssembly {
    
    // MARK: - Properties
    
    private let environment: SettingsEnvironment
    
    // MARK: - Lifecycle
    
    public init() {
        environment = SettingsEnvironmentLive()
    }
    
    // MARK: - SettingsView
    
    public func settingsView() -> SettingsView {
        let interactor = SettingsInteractorLive(router: environment.router)
        let view = SettingsView(interactor: interactor, state: interactor.state, router: environment.router)
        return view
    }
}
