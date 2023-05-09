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
}
