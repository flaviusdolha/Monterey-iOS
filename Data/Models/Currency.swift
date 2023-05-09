//
//  Currency.swift
//  Domain
//
//  Created by Flavius Dolha on 09.05.2023.
//

import Foundation

// MARK: - Currency

public enum Currency: String, CaseIterable {
    case chf = "CHF"
    case eur = "EUR"
    case gbp = "GBP"
    case jpy = "JPY"
    case ron = "RON"
    case usd = "USD"
    
    // MARK: - Properties
    
    public var symbol: String {
        switch self {
        case .chf:
            return "Fr"
        case .eur:
            return "€"
        case .gbp:
            return "£"
        case .jpy:
            return "¥"
        case .ron:
            return "Lei"
        case .usd:
            return "$"
        }
    }
    
    public var flag: String {
        switch self {
        case .chf:
            return "🇨🇭"
        case .eur:
            return "🇪🇺"
        case .gbp:
            return "🇬🇧"
        case .jpy:
            return "🇯🇵"
        case .ron:
            return "🇷🇴"
        case .usd:
            return "🇺🇸"
        }
    }
    
    // MARK: - Instance Methods
    
    public func stringDescription(withFlag: Bool) -> String {
        (withFlag ? "\(self.flag) " : "") + self.rawValue + " (\(self.symbol))"
    }
}
