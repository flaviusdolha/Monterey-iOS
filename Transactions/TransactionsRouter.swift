//
//  TransactionsRouter.swift
//  Transactions
//
//  Created by Flavius Dolha on 11.03.2023.
//

import Domain
import Foundation
import SharedState
import SwiftUI

// MARK: - TransactionsRoute

enum TransactionsRoute: Hashable {
    case add
    case edit(Domain.Transaction)
}

// MARK: - TransactionsRouter

class TransactionsRouter: ObservableObject {
    
    // MARK: - Properties
    
    private let transactionStorage: TransactionStorage
    private let transactionsSharedState: TransactionsSharedState
    @Published var path: NavigationPath = .init()
    
    lazy var binding = {
        Binding { self.path }
        set: { value in self.path = value }
    }()
    
    // MARK: - Lifecycle
    
    init(transactionStorage: TransactionStorage, transactionsSharedState: TransactionsSharedState) {
        self.transactionStorage = transactionStorage
        self.transactionsSharedState = transactionsSharedState
    }
    
    // MARK: - Instance Methods
    
    func push(_ route: TransactionsRoute) {
        path.append(route)
    }
    
    func dismiss() {
        path.removeLast()
    }
    
    func dismissAll() {
        path.removeLast(path.count)
    }
    
    lazy var manageTransactionAssembly: ManageTransactionAssembly = {
        ManageTransactionAssembly(
            transactionStorage: transactionStorage,
            router: self,
            transactionsSharedState: transactionsSharedState
        )
    }()
    
    func view(for route: TransactionsRoute) -> some View {
        switch route {
        case .add:
            return manageTransactionAssembly.ManageTransactionView(type: .add)
        case let .edit(transaction):
            return manageTransactionAssembly.ManageTransactionView(type: .edit(transaction))
        }
    }
}
