//
//  ReportsEnvironment.swift
//  Reports
//
//  Created by Flavius Dolha on 10.05.2023.
//

import Domain
import Foundation

// MARK: - ReportsEnvironment

protocol ReportsEnvironment {
    var router: ReportsRouter { get }
    var transactionStorage: TransactionStorage { get }
}

// MARK: - ReportsEnvironmentLive

class ReportsEnvironmentLive: ReportsEnvironment {
    
    // MARK: - Properties
    
    let transactionStorage: TransactionStorage = StorageProvider.shared
    lazy var router: ReportsRouter = {
        ReportsRouter(transactionStorage: transactionStorage)
    }()

}
