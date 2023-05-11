import Combine

// MARK: - AuthenticationStateType

enum AuthenticationStateType {
    case register
    case login
    case change
}

// MARK: - AuthenticationState

final class AuthenticationState: ObservableObject {
    @Published var codeFieldInputs: [String] = Array(repeating: "", count: 4)
    @Published var type: AuthenticationStateType = .login
    @Published var inputError = false
    @Published var showBiometric = false
    
    var isValid: Bool {
        codeFieldInputs.reduce("") { $0 + $1 }.count == 4
    }
    
    var authenticateButtonText: String {
        switch type {
        case .change: return "Change Passcode".localized
        case .login: return "Authenticate".localized
        case .register: return "Set Passcode".localized
        }
    }
}
