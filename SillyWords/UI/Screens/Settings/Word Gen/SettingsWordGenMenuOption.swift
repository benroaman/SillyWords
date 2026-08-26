//
//  SettingsWordGenMenuOption.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/22/26.
//

import SwiftUI

enum SettingsWordGenMenuOption: Int, SettingsSimpleMenuRowOption, CaseIterable {
    case syllables
    case vowels
    case consonants
    case sentence
    
    var title: String {
        switch self {
        case .syllables: "Syllables"
        case .vowels: "Vowels"
        case .consonants: "Consonants"
        case .sentence: "Use it in a Sentence"
        }
    }
    
    var icon: SFSymbol {
        switch self {
        case .syllables: .ruler
        case .vowels: .aCircle
        case .consonants: .bCircle
        case .sentence: .space
        }
    }
    
    var iconColor: Color {
        Style.Color.wordGenerateTheme
    }
    
    var accessory: SFSymbol? {
        .chevronRight
    }
}
