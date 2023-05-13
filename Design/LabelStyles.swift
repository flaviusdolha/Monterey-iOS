//
//  RightImageLabelStyle.swift
//  Design
//
//  Created by Flavius Dolha on 10.05.2023.
//

import Foundation
import SwiftUI

// MARK: - RightImageLabelStyle

public struct RightImageLabelStyle: LabelStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}

// MARK: - SmallLabelStyle

public struct SmallLabelStyle: LabelStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 2) {
            VStack {
                configuration.icon
                Spacer()
            }
            configuration.title
        }
    }
}

// MARK: - NormalLabelStyle

public struct NormalLabelStyle: LabelStyle {
    public init() {}
    
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
            configuration.title
        }
    }
}
