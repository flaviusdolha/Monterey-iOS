import Combine

// MARK: - SettingsInteractor

protocol SettingsInteractor: AnyObject {
    var state: SettingsState { get }
}

// MARK: - SettingsInteractorLive

final class SettingsInteractorLive: SettingsInteractor {
    
    // MARK: - Properties
    
    var state: SettingsState
    private let router: SettingsRouter
    
    // MARK: - Lifecycle

    init(router: SettingsRouter) {
        self.router = router
        state = SettingsState()
    }
}
