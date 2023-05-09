import Combine
import Core
import Domain
import PhotosUI
import SharedState
import SwiftUI

// MARK: - ManageTransactionInteractor

protocol ManageTransactionInteractor: AnyObject {
    var state: ManageTransactionState { get }
    
    func actionButtonPressed(price: Float, picture: UIImage?)
    func confirmDeleteTransaction()
    func onAppear(_ picture: (UIImage?) -> Void, _ price: (Float) -> Void)
}

// MARK: - ManageTransactionInteractorLive

final class ManageTransactionInteractorLive: ManageTransactionInteractor {
    
    // MARK: - Properties
    
    var state: ManageTransactionState
    private let transactionStorage: TransactionStorage
    private let router: TransactionsRouter
    private var transaction: Domain.Transaction? = nil
    private var transactionsSharedState: TransactionsSharedState
    
    // MARK: - Lifecycle

    init(
        transactionStorage: TransactionStorage,
        router: TransactionsRouter,
        type: ManageTransactionType,
        transactionsSharedState: TransactionsSharedState
    ) {
        self.transactionStorage = transactionStorage
        self.router = router
        self.transactionsSharedState = transactionsSharedState
        var transactionData: TransactionData
        switch type {
        case .add: transactionData = .default
        case let .edit(incomingTransaction):
            self.transaction = incomingTransaction
            transactionData = incomingTransaction.data
        }
        state = ManageTransactionState(transaction: transactionData, type: type)
        loadCurrency()
    }
    
    // MARK: Instance Methods
    
    func actionButtonPressed(price: Float, picture: UIImage?) {
        switch state.type {
        case .add:
            transactionStorage.saveTransaction(
                note: state.transactionData.note,
                date: state.transactionData.date,
                price: round(price * 100) / 100.0,
                category: state.transactionData.category.rawValue,
                picture: picture
            )
        case .edit:
            if let transaction = transaction {
                transactionStorage.updateTransaction(
                    transaction,
                    note: state.transactionData.note,
                    date: state.transactionData.date,
                    price: round(price * 100) / 100.0,
                    category: state.transactionData.category.rawValue,
                    picture: picture
                )
            }
        }
        router.dismiss()
    }
    
    func confirmDeleteTransaction() {
        if let transaction = transaction {
            transactionStorage.deleteTransaction(transaction)
        }
        router.dismiss()
    }
    
    func onAppear(_ picture: (UIImage?) -> Void, _ price: (Float) -> Void) {
        if let stringPrice = transactionsSharedState.price,
           let floatPrice = Float(stringPrice) {
            let roundedPrice = round(floatPrice * 100) / 100.0
            state.transactionData.price = roundedPrice
            transactionsSharedState.price = nil
        }
        price(state.transactionData.price)
        if let picture = transactionsSharedState.picture {
            state.transactionData.picture = picture
            transactionsSharedState.picture = nil
        }
        picture(state.transactionData.picture)
    }
    
    private func loadCurrency() {
        if let currencyString = UserDefaults.standard.string(forKey: UserDefaultsKeys.currency),
           let currency = Currency(rawValue: currencyString) {
            state.currency = currency
        }
    }
}
