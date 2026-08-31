//
//  Untitled.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/6/26.
//

import SwiftUI

#warning("TODO: Organize")

struct Style {
    private init() { }
    
}

extension Style {
    struct Settings {
        private init() { }
        
        struct Font {
            private init() { }
        }
        
        struct Layout {
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

extension Style.Settings.Layout {
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
