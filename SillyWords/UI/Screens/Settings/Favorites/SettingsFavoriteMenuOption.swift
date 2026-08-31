//
//  SettingsFavoriteMenuOption.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/22/26.
//

import SwiftUI

enum SettingsFavoritesMenuOption: Int, SettingsSimpleMenuRowOption, CaseIterable {
    case clear
    
    var title: String {
        switch self {
        case .clear: "Clear All Favorites"
        }
    }
    
    var icon: SFSymbol {
        switch self {
        case .clear: Theme.Delete.icon
        }
    }
    
    var iconColor: Color {
        switch self {
        case .clear: Theme.Delete.color
        }
    }
    
    var accessory: SFSymbol? {
        switch self {
        case .clear: nil
        }
    }
}
