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
    struct Theme {
        private init() { }
    }
}

extension Style.Theme {
    struct Color {
        private init() { }
    }
}

extension Style.Theme.Color {
    static let main: Color = .indigo
    static let wordGenerate: Color = .green
    static let report: Color = .orange
    static let offensive: Color = .red
    static let poorQuality: Color = .orange
    static let feedback: Color = .indigo
    static let delete: Color = .red
    static let favorite: Color = .purple
    static let zeroItem: Color = .secondary
    static let history: Color = .teal
    static let userInterface: Color = .indigo
    static let selected: Color = .green
}

extension Style {
    struct Settings {
        private init() { }
        
        struct Font {
            private init() { }
        }
        
        struct Spacing {
            private init() { }
        }
        
        struct Icon {
            private init() { }
        }
        
        struct Color {
            private init() { }
        }
    }
}

extension Style.Settings.Font {
    static var optionTitle: Font { .headline }
    static var optionValue: Font { .subheadline }
    static var optionDescription: Font { .subheadline }
    static var optionExample: Font { .subheadline.italic() }
    static var actionFont: Font { .headline }
}

extension Style.Settings.Spacing {
    static var optionTitleBottom: CGFloat { 10 }
}

extension Style.Settings.Color {
    static var optionTitle: Color { .primary }
    static var optionDescription: Color { .secondary }
    static var optionExample: Color { .secondary }
    static var optionValue: Color { .secondary }
    static var optionAccessory: Color { .secondary }
}

extension Style.Settings.Icon {
    static var optionIconWeight: Font.Weight { .medium }
    static var accessoryFont: Font { .headline }
    static var actionFont: Font { .headline }
}
