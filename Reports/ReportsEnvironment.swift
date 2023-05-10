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
}

// MARK: - ReportsEnvironmentLive

class ReportsEnvironmentLive: ReportsEnvironment {
    
    // MARK: - Properties
    
    let transactionStorage: TransactionStorage = StorageProvider()
    lazy var router: ReportsRouter = {
        ReportsRouter(transactionStorage: transactionStorage)
    }()

}