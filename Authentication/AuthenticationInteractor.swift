import Combine
import Core
import KeychainService
import SwiftUI

// MARK: - AuthenticationInteractor

protocol AuthenticationInteractor: AnyObject {
    var state: AuthenticationState { get }
    
    func onAuthenticateButtonPressed()
}

// MARK: - AuthenticationInteractorLive

final class AuthenticationInteractorLive: AuthenticationInteractor {
    
    // MARK: - Properties
    
    var state: AuthenticationState
    private let externalRouter: PassthroughSubject<ExternalAuthenticationRoute, Never>
    private let keychainService: KeychainService
    private var code: String? = nil
    
    // MARK: - Lifecycle

    init(externalRouter: PassthroughSubject<ExternalAuthenticationRoute, Never>, keychainService: KeychainService, change: Bool = false) {
        self.externalRouter = externalRouter
        self.keychainService = keychainService
        state = AuthenticationState()
        if change {
            state.type = .change
        } else {
            if let code = keychainService.read(service: KeychainKeys.passcode.service, account: KeychainKeys.passcode.account, type: String.self) {
                self.code = code
                state.type = .login
            } else {
                state.type = .register
            }
        }
    }
    
    func onAuthenticateButtonPressed() {
        let inputCode = state.codeFieldInputs.reduce("", { $0 + $1 })
        if state.type == .login {
            if inputCode == code {
                withAnimation {
                    externalRouter.send(.authenticated)
                }
            } else {
                withAnimation {
                    state.inputError = true
                }
            }
        } else {
            keychainService.save(inputCode, service: KeychainKeys.passcode.service, account: KeychainKeys.passcode.account)
            withAnimation {
                externalRouter.send(.authenticated)
            }
        }
    }
}
