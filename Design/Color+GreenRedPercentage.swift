//
//  Color+GreenRedPercentage.swift
//  Design
//
//  Created by Flavius Dolha on 13.05.2023.
//

import Foundation
import SwiftUI
import UIKit

// MARK: - Color Extension to generate Color from red to green based on percentage.

extension Color {
    public static func fromRedToGreem(green amount: Float) -> Color {
        Color(UIColor(hue: CGFloat(amount) / 3, saturation: 1.0, brightness: 1.0, alpha: 1.0))
    }
}
