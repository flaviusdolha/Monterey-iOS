//
//  Category+Color.swift
//  Transactions
//
//  Created by Flavius Dolha on 01.04.2023.
//

import Domain
import SwiftUI

public extension ExpenseCategory {
    var color: Color {
        switch self {
        case .none:
            return .gray
        case .business:
            return .brown
        case .car:
            return .red
        case .clothing:
            return .cyan
        case .education:
            return .green
        case .food:
            return .orange
        case .grooming:
            return .indigo
        case .gifts:
            return .pink
        case .healthcare:
            return .mint
        case .home:
            return .yellow
        case .leisure:
            return .purple
        case .other:
            return .black
        case .subscriptions:
            return .teal
        case .transportation:
            return .blue
        }
    }
}
