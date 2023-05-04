//
//  ScannerEnvironment.swift
//  Scanner
//
//  Created by Flavius Dolha on 02.05.2023.
//

import Combine
import Foundation
import SharedState

// MARK: - ScannerEnvironment

protocol ScannerEnvironment {
    var router: ScannerRouter { get }
    var externalRouter: PassthroughSubject<ExternalScannerRoute, Never> { get }
    var transactionsSharedState: TransactionsSharedState { get }
    var scannerService: ScannerService { get }
}

// MARK: - ScannerEnvironmentLive

class ScannerEnvironmentLive: ScannerEnvironment {
    
    // MARK: - Properties
    
    let transactionsSharedState: TransactionsSharedState
    let externalRouter = PassthroughSubject<ExternalScannerRoute, Never>()
    let scannerService: ScannerService = ScannerServiceLive()
    lazy var router: ScannerRouter = {
        ScannerRouter()
    }()
    
    // MARK: - Lifecycle
    
    init(transactionsSharedState: TransactionsSharedState) {
        self.transactionsSharedState = transactionsSharedState
    }
}
