//
//  BudgetRouter.swift
//  Budget
//
//  Created by Flavius Dolha on 13.05.2023.
//

import Domain
import Foundation
import SwiftUI

// MARK: - BudgetRoute

enum BudgetRoute: Hashable {
    case add
    case edit(Budget)
}

// MARK: - BudgetRouter

class BudgetRouter: ObservableObject {

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
    
    func push(_ route: BudgetRoute) {
        path.append(route)
    }
    
    func dismiss() {
        path.removeLast()
    }
    
    func dismissAll() {
        path.removeLast(path.count)
    }
    
    func view(for route: BudgetRoute) -> some View {
        Text("route")
    }
}
