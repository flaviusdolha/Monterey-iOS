//
//  BudgetEnvironment.swift
//  Budget
//
//  Created by Flavius Dolha on 13.05.2023.
//

import Domain
import Foundation

// MARK: - BudgetEnvironment

protocol BudgetEnvironment {
    var router: BudgetRouter { get }
    var transactionStorage: TransactionStorage { get }
}

// MARK: - BudgetEnvironmentLive

class BudgetEnvironmentLive: BudgetEnvironment {
    
    // MARK: - Properties
    
    let transactionStorage: TransactionStorage = StorageProvider()
    lazy var router: BudgetRouter = {
        BudgetRouter(transactionStorage: transactionStorage)
    }()

}
