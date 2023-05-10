//
//  AuthenticationEnvironment.swift
//  Authentication
//
//  Created by Flavius Dolha on 10.05.2023.
//

import Combine
import Foundation
import KeychainService

// MARK: - AuthenticationEnvironment

protocol AuthenticationEnvironment {
    var externalRouter: PassthroughSubject<ExternalAuthenticationRoute, Never> { get }
    var keychainService: KeychainService { get }
}

// MARK: - AuthenticationEnvironmentLive

class AuthneticationEnvironmentLive: AuthenticationEnvironment {
    
    // MARK: - Properties
    
    let externalRouter = PassthroughSubject<ExternalAuthenticationRoute, Never>()
    let keychainService: KeychainService = .init()
}
