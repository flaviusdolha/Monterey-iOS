//
//  UIImageTransformer.swift
//  Data
//
//  Created by Flavius Dolha on 03.01.2023.
//

import Foundation
import UIKit

// MARK: - UIImageTransformer

class UIImageTransformer: ValueTransformer {

    // MARK: - Override Methods

    override func transformedValue(_ value: Any?) -> Any? {
        guard let image = value as? UIImage else { return nil }
        return try? NSKeyedArchiver.archivedData(withRootObject: image, requiringSecureCoding: true)
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        return try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIImage.self, from: data)
    }
}

