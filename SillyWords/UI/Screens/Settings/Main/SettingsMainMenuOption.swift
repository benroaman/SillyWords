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
        case .wordGen: Style.Theme.Icon.wordGen
        case .favorites: Style.Theme.Icon.favorites
        case .feedback: Style.Theme.Icon.contact
        case .userInterface: Style.Theme.Icon.userInterface
        }
    }
    
    var iconColor: Color {
        switch self {
        case .wordGen: Style.Theme.Color.wordGen
        case .favorites: Style.Theme.Color.favorite
        case .feedback: Style.Theme.Color.feedback
        case .userInterface: Style.Theme.Color.userInterface
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

