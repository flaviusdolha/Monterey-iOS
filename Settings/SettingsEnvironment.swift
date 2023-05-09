//
//  SettingsEnvironment.swift
//  Settings
//
//  Created by Flavius Dolha on 09.05.2023.
//

import Combine
import Foundation

// MARK: - SettingsEnvironment

protocol SettingsEnvironment {
    var router: SettingsRouter { get }
}

// MARK: - SettingsEnvironmentLive

class SettingsEnvironmentLive: SettingsEnvironment {
    
    // MARK: - Properties
    
    lazy var router: SettingsRouter = {
        SettingsRouter()
    }()

}
