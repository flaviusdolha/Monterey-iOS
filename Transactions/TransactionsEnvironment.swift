//
//  TransactionEnvironment.swift
//  Transactions
//
//  Created by Flavius Dolha on 11.03.2023.
//

import Domain
import Foundation
import SharedState

// MARK: - TransactionsEnvironment

protocol TransactionsEnvironment {
    var transactionStorage: TransactionStorage { get }
    var router: TransactionsRouter { get }
    var transactionsSharedState: TransactionsSharedState { get }
}

// MARK: - TransactionsEnvironmentLive

class TransactionsEnvironmentLive: TransactionsEnvironment {
    
    // MARK: - Properties
    
    let transactionsSharedState: TransactionsSharedState
    let transactionStorage: TransactionStorage = StorageProvider()
    lazy var router: TransactionsRouter = {
        TransactionsRouter(transactionStorage: transactionStorage, transactionsSharedState: transactionsSharedState)
    }()
    
    // MARK: - Lifecycle
    
    init(transactionsSharedState: TransactionsSharedState) {
        self.transactionsSharedState = transactionsSharedState
    }
    
}
