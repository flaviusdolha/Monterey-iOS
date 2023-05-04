import Combine
import Domain
import PhotosUI
import SwiftUI

// MARK: - ManageTransactionType

enum ManageTransactionType: Equatable {
    case add
    case edit(Domain.Transaction)
}

// MARK: - ManageTransactionState

final class ManageTransactionState: ObservableObject {
    @Published var transactionData: TransactionData
    @Published var type: ManageTransactionType
    @Published var isShowingConfirmDelete: Bool = false
    
    init(transaction: TransactionData, type: ManageTransactionType) {
        self.transactionData = transaction
        self.type = type
    }
}
