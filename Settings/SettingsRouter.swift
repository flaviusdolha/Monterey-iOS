//
//  SettingsRouter.swift
//  Settings
//
//  Created by Flavius Dolha on 09.05.2023.
//

import Foundation
import SwiftUI

// MARK: - SettingsRoute

enum SettingsRoute: Hashable {
    case currency
}

// MARK: - SettingsRouter

class SettingsRouter: ObservableObject {

    // MARK: - Properties
    
    @Published var path: NavigationPath = .init()
    
    lazy var binding = {
        Binding { self.path }
        set: { value in self.path = value }
    }()
    
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
        Text("route")
    }
}
