//
//  SettingsMainMenuOption.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/22/26.
//

import SwiftUI

enum SettingsMainMenuOption: SettingsSimpleMenuRowOption, CaseIterable {
    case wordGen
    case favorites
    case userInterface
    case feedback
    
    var title: String {
        switch self {
        case .wordGen: "Word Generation"
        case .favorites: "Favorites"
        case .feedback: "Feedback"
        case .userInterface: "UI"
        }
    }
    
    var icon: SFSymbol {
        switch self {
        case .wordGen: Theme.WordGen.icon
        case .favorites: Theme.Favorite.icon
        case .feedback: Theme.Feedback.icon
        case .userInterface: Theme.UserInterface.icon
        }
    }
    
    var iconColor: Color {
        switch self {
        case .wordGen: Theme.WordGen.color
        case .favorites: Theme.Favorite.color
        case .feedback: Theme.Feedback.color
        case .userInterface: Theme.UserInterface.color
        }
    }

    var accessory: SFSymbol? {
        switch self {
        case .wordGen: .chevronRight
        case .favorites: .chevronRight
        case .feedback: .arrowUpRight
        case .userInterface: .chevronRight
        }
    }
}

