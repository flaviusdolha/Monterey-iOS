//
//  Category+Color.swift
//  Transactions
//
//  Created by Flavius Dolha on 01.04.2023.
//

import Domain
import SwiftUI

public extension Domain.Category {
    var color: Color {
        switch self {
        case .none:
            return .gray
        case .car:
            return .red
        }
    }
}
