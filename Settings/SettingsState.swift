import Combine
import Core
import Domain

// MARK: - SettingsState

final class SettingsState: ObservableObject {
    @Published var currency: Currency = .usd {
        didSet {
            UserDefaults.standard.set(currency.rawValue, forKey: UserDefaultsKeys.currency)
        }
    }
    
    @Published var usesBiometric: Bool = false {
        didSet {
            UserDefaults.standard.set(usesBiometric, forKey: UserDefaultsKeys.usesBiometric)
        }
    }
}
