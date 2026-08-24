//
//  Untitled.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/6/26.
//

import SwiftUI

struct Style {
    private init() { }
}

extension Style {
    struct Color {
        private init() { }
    }
}

extension Style.Color {
    static let mainTheme: Color = .indigo
    static let wordGenerateTheme: Color = .green
    static let reportTheme: Color = .orange
    static let offensiveTheme: Color = .red
    static let poorQualityTheme: Color = .orange
    static let feedbackTheme: Color = .indigo
    static let deleteTheme: Color = .red
    static let favoriteTheme: Color = .purple
    static let zeroItemTheme: Color = .secondary
    static let historyTheme: Color = .teal
    static let userInterfaceTheme: Color = .indigo
}
