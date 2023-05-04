//
//  Category.swift
//  Data
//
//  Created by Flavius Dolha on 07.03.2023.
//

import Foundation

public enum Category: String, CaseIterable {
    case none
    case car
}

public extension Category {
    var emoji: String {
        switch self {
        case .none:
            return "➖"
        case .car:
            return "🚗"
        }
    }
}
