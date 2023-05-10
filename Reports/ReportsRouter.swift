//
//  ReportsRouter.swift
//  Reports
//
//  Created by Flavius Dolha on 10.05.2023.
//

import Domain
import Foundation
import SwiftUI

// MARK: - ReportsRoute

enum ReportsRoute: Hashable {
    case none
}

// MARK: - ReportsRouter

class ReportsRouter: ObservableObject {

    // MARK: - Properties
    
    private let transactionStorage: TransactionStorage
    @Published var path: NavigationPath = .init()
    
    lazy var binding = {
        Binding { self.path }
        set: { value in self.path = value }
    }()
    
    // MARK: - Lifecycle
    
    init(transactionStorage: TransactionStorage) {
        self.transactionStorage = transactionStorage
    }
    
    // MARK: - Instance Methods
    
    func push(_ route: ReportsRoute) {
        path.append(route)
    }
    
    func dismiss() {
        path.removeLast()
    }
    
    func dismissAll() {
        path.removeLast(path.count)
    }
    
    func view(for route: ReportsRoute) -> some View {
        Text("route")
    }
}
