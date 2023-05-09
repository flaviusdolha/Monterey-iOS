import Combine
import Core
import Domain

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
        loadCurrency()
    }
    
    private func loadCurrency() {
        if let currencyString = UserDefaults.standard.string(forKey: UserDefaultsKeys.currency),
           let currency = Currency(rawValue: currencyString) {
            state.currency = currency
        }
    }
}
