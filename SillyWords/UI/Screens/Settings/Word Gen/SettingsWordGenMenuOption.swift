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
    
    var title: String {
        switch self {
        case .syllables: "Syllables"
        case .vowels: "Vowels"
        case .consonants: "Consonants"
        }
    }
    
    var icon: SFSymbol {
        switch self {
        case .syllables: .ruler
        case .vowels: .aCircle
        case .consonants: .bCircle
        }
    }
    
    var iconColor: Color {
        Style.Color.wordGenerateTheme
    }
    
    var accessory: SFSymbol? {
        .chevronRight
    }
}
