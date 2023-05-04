//
//  ScannerRouter.swift
//  Scanner
//
//  Created by Flavius Dolha on 02.05.2023.
//

import Foundation
import SwiftUI

// MARK: - ScannerRoute

enum ScannerRoute: Hashable {
    case none
}

// MARK: - ExternalScannerRoute

public enum ExternalScannerRoute {
    case transaction(String, UIImage)
}

// MARK: - ScannerRouter

class ScannerRouter: ObservableObject {
    
    // MARK: - Properties
    
    @Published var path: NavigationPath = .init()
    
    lazy var binding = {
        Binding { self.path }
        set: { value in self.path = value }
    }()
    
    // MARK: - Instance Methods
    
    func push(_ route: ScannerRoute) {
        path.append(route)
    }
    
    func dismiss() {
        path.removeLast()
    }
    
    func dismissAll() {
        path.removeLast(path.count)
    }
    
    func view(for route: ScannerRoute) -> some View {
        Text("route")
    }
}

