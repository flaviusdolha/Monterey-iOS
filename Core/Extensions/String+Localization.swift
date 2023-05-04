//
//  String+Localization.swift
//  Core
//
//  Created by Flavius Dolha on 03.12.2022.
//

import Foundation

// MARK: - String Localization Extension

public extension String {
    
    // MARK: - Localization Properties
    
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
