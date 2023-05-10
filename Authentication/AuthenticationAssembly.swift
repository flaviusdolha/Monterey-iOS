import Combine
import SwiftUI

// MARK: - AuthenticationAssembly

public final class AuthenticationAssembly {
    
    // MARK: - Properties
    
    private let environment: AuthenticationEnvironment
    
    // MARK: - Lifecycle
    
    public init() {
        environment = AuthneticationEnvironmentLive()
    }
    
    // MARK: - AuthenticationView
    
    public lazy var externalRouter: AnyPublisher<ExternalAuthenticationRoute, Never> = {
        environment.externalRouter.eraseToAnyPublisher()
    }()
    
    public func authenticationView(change: Bool = false) -> AuthenticationView {
        let interactor = AuthenticationInteractorLive(externalRouter: environment.externalRouter, keychainService: environment.keychainService, change: change)
        let view = AuthenticationView(interactor: interactor, state: interactor.state)
        return view
    }
}
