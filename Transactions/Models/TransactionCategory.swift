//
//  TransactionCategory.swift
//  Transactions
//
//  Created by Flavius Dolha on 01.04.2023.
//

import Domain

struct TransactionCategory: Identifiable {
    let category: ExpenseCategory
    let transactions: [Domain.Transaction]
    var isExpanded: Bool = true
    
    var id: ExpenseCategory {
        category
    }
}

extension [TransactionCategory] {
    var totalPrice: Float {
        reduce(0) { round(($0 + $1.transactions.totalPrice) * 100.0) / 100.0 }
    }
}

extension [Domain.Transaction] {
    var totalPrice: Float {
        reduce(0) { round(($0 + $1.price) * 100.0) / 100.0 }
    }
}
