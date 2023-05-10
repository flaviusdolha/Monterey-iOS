//
//  IncomeDataModel.swift
//  Transactions
//
//  Created by Flavius Dolha on 09.05.2023.
//

import Domain
import Foundation

struct IncomeDataModel {
    var category: IncomeCategory
    var date: Date
    var value: Float
}

extension IncomeDataModel {
    static let `default`: IncomeDataModel = .init(
        category: .salary,
        date: Date(),
        value: 0
    )
}

extension IncomeData {
    var data: IncomeDataModel {
        IncomeDataModel(
            category: IncomeCategory.init(rawValue: self.category ?? "other") ?? .other,
            date: self.date ?? Date(),
            value: self.value
        )
    }
}

extension [IncomeData] {
    var totalValue: Float {
        reduce(0) { $0 + $1.value }
    }
}

extension IncomeData: Identifiable {
    public var id: String {
        let dateFormatter = DateFormatter()
        return (self.category ?? "") + String(self.value) + dateFormatter.string(from: self.date ?? Date())
    }
}
