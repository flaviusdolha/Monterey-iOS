//
//  TransactionData.swift
//  Transactions
//
//  Created by Flavius Dolha on 21.03.2023.
//

import Domain
import Foundation
import UIKit

struct TransactionData {
    var category: Domain.Category
    var date: Date
    var note: String
    var picture: UIImage?
    var price: Float
}

extension TransactionData {
    static let `default`: TransactionData = .init(category: .none,
                                                  date: Date(),
                                                  note: "",
                                                  picture: nil,
                                                  price: 0)
}

extension Transaction {
    var data: TransactionData {
        TransactionData(
            category: Category.init(rawValue: self.category ?? "none") ?? .none,
            date: self.date ?? Date(),
            note: self.note ?? "",
            picture: self.picture,
            price: self.price
        )
    }
}
