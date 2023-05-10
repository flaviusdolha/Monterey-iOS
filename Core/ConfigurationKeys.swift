//
//  UserDefaultsKeys.swift
//  Core
//
//  Created by Flavius Dolha on 09.05.2023.
//

import Foundation

// MARK: - UserDefaultsKeys

public struct UserDefaultsKeys {
    public static let currency = "Currency"
    public static let usesBiometric = "UsesBiometric"
}

// MARK: - KeychainKey

public struct KeychainKey {
    public let service: String
    public let account: String
}

// MARK: - KeychainKeys

public struct KeychainKeys {
    public static let passcode = KeychainKey(service: "passcode", account: "self-account")
}
