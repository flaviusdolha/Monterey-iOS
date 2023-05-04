//
//  MontereyNavigationElements.swift
//  Design
//
//  Created by Flavius Dolha on 11.03.2023.
//

import Foundation
import SwiftUI

public struct MontereyNavigationBar: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.mint, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

public struct MontereyTabBar: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .toolbarBackground(Color.white, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
    }
}

public extension View {
    func montereyNavBar() -> some View {
        modifier(MontereyNavigationBar())
    }
    
    func montereyTabBar() -> some View {
        modifier(MontereyTabBar())
    }
}
