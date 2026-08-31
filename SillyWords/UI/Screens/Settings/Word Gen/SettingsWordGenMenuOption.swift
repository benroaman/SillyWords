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
        case .presets: Theme.Presets.icon
        case .syllables: Theme.Syllables.icon
        case .vowels: Theme.Vowels.icon
        case .consonants: Theme.Consonants.icon
        case .sentence: Theme.SentenceGen.icon
        }
    }
    
    var iconColor: Color {
        Theme.WordGen.color
    }
    
    var accessory: SFSymbol? {
        .chevronRight
    }
}
