//
//  TransactionCategory.swift
//  Transactions
//
//  Created by Flavius Dolha on 01.04.2023.
//

import Domain

struct TransactionCategory: Identifiable {
    let category: Domain.Category
    let transactions: [Domain.Transaction]
    var isExpanded: Bool = true
    
    var id: Domain.Category {
        category
    }
}

extension [TransactionCategory] {
    var totalPrice: Float {
        reduce(0) { $0 + $1.transactions.totalPrice }
    }
}

extension [Domain.Transaction] {
    var totalPrice: Float {
        reduce(0) { $0 + $1.price }
    }
}
