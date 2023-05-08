//
//  Category.swift
//  Data
//
//  Created by Flavius Dolha on 07.03.2023.
//

import Foundation

public enum Category: String, CaseIterable {
    case none
    case business
    case car
    case clothing
    case education
    case food
    case gifts
    case grooming
    case healthcare
    case home
    case leisure
    case other
    case subscriptions
    case transportation
}

public extension Category {
    var emoji: String {
        switch self {
        case .none:
            return "➖"
        case .business:
            return "💼"
        case .car:
            return "🚗"
        case .clothing:
            return "👕"
        case .education:
            return "📚"
        case .food:
            return "🍞"
        case .grooming:
            return "💇‍♀️"
        case .gifts:
            return "🎁"
        case .healthcare:
            return "🏨"
        case .home:
            return "🏡"
        case .leisure:
            return "⛷️"
        case .other:
            return "🧩"
        case .subscriptions:
            return "📱"
        case .transportation:
            return "🚈"
        }
    }
}
