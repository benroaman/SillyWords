//
//  SettingsMainMenuOption.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/22/26.
//

import SwiftUI

enum SettingsMainMenuOption: SettingsSimpleMenuRowOption, CaseIterable {
    case wordGeneration
    case favorites
    case userInterface
    case feedback
    
    var title: String {
        switch self {
        case .wordGeneration: "Word Generation"
        case .favorites: "Favorites"
        case .feedback: "Feedback"
        case .userInterface: "UI"
        }
    }
    
    var icon: SFSymbol {
        switch self {
        case .wordGeneration: .pencilAndScribble
        case .favorites: .heart
        case .feedback: .envelope
        case .userInterface: .candybarphone
        }
    }
    
    var iconColor: Color {
        switch self {
        case .wordGeneration: Style.Color.wordGenerateTheme
        case .favorites: Style.Color.favoriteTheme
        case .feedback: Style.Color.feedbackTheme
        case .userInterface: Style.Color.userInterfaceTheme
        }
    }

    var accessory: SFSymbol? {
        switch self {
        case .wordGeneration: .chevronRight
        case .favorites: .chevronRight
        case .feedback: .arrowUpRight
        case .userInterface: .chevronRight
        }
    }
}

