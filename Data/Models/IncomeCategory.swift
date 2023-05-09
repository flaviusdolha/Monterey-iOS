//
//  IncomeCategory.swift
//  Domain
//
//  Created by Flavius Dolha on 09.05.2023.
//

import Foundation

// MARK: - IncomeCategory

public enum IncomeCategory: String, CaseIterable {
    case business
    case gifts
    case investments
    case other
    case salary
}

public extension IncomeCategory {
    var emoji: String {
        switch self {
        case .business:
            return "💼"
        case .gifts:
            return "🎁"
        case .investments:
            return "📈"
        case .other:
            return "➕"
        case .salary:
            return "💶"
        }
    }
}
