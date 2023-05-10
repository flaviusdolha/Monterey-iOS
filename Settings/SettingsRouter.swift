//
//  SettingsRouter.swift
//  Settings
//
//  Created by Flavius Dolha on 09.05.2023.
//

import Authentication
import Combine
import Design
import Foundation
import SwiftUI

// MARK: - SettingsRoute

enum SettingsRoute: Hashable {
    case changePasscode
}

// MARK: - SettingsRouter

class SettingsRouter: ObservableObject {

    // MARK: - Properties
    
    @Published var path: NavigationPath = .init()
    private var cancellables = Set<AnyCancellable>()
    
    lazy var binding = {
        Binding { self.path }
        set: { value in self.path = value }
    }()
    
    private lazy var authenticationAssembly: AuthenticationAssembly = {
        AuthenticationAssembly()
    }()
    
    var authenticationView: some View {
        authenticationAssembly.authenticationView(change: true)
            .montereyNavBar()
            .montereyTabBar()
            .navigationTitle("Change Passcode".localized)
    }
    
    // MARK: - Lifecycle
    
    init() {
        authenticationAssembly.externalRouter.sink { [weak self] route in
            switch route {
            case .authenticated:
                withAnimation {
                    self?.dismiss()
                }
            }
        }
        .store(in: &cancellables)
    }
    
    // MARK: - Instance Methods
    
    func push(_ route: SettingsRoute) {
        path.append(route)
    }
    
    func dismiss() {
        path.removeLast()
    }
    
    func dismissAll() {
        path.removeLast(path.count)
    }
    
    func view(for route: SettingsRoute) -> some View {
        switch route {
        case .changePasscode:
            return authenticationView
        }
    }
}
