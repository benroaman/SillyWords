//
//  SettingsWordGenMenuOption.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/22/26.
//

import SwiftUI

enum SettingsWordGenMenuOption: Int, SettingsSimpleMenuRowOption, CaseIterable {
    case presets
    case syllables
    case vowels
    case consonants
    case sentence
    
    var title: String {
        switch self {
        case .presets: "Presets"
        case .syllables: "Syllables"
        case .vowels: "Vowels"
        case .consonants: "Consonants"
        case .sentence: "Use it in a Sentence"
        }
    }
    
    var icon: SFSymbol {
        switch self {
        case .presets: .documentBadgeGearshape
        case .syllables: .ruler
        case .vowels: .aCircle
        case .consonants: .bCircle
        case .sentence: .space
        }
    }
    
    var iconColor: Color {
        Style.Theme.Color.wordGenerate
    }
    
    var accessory: SFSymbol? {
        .chevronRight
    }
}
