//
//  SettingsUserInterfaceMenuOption.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/23/26.
//

import SwiftUI

// MARK: Support Types
enum SettingsUserInterfaceMenuOption: Int, SettingsSimpleMenuRowOption, CaseIterable {
    case wordGenCurrentWordTransitionStyle
    
    var title: String {
        switch self {
        case .wordGenCurrentWordTransitionStyle: "Word Transition"
        }
    }
    
    var icon: SFSymbol {
        switch self {
        case .wordGenCurrentWordTransitionStyle: .rectangle2Swap
        }
    }
    
    var iconColor: Color {
        switch self {
        case .wordGenCurrentWordTransitionStyle: Style.Color.userInterfaceTheme
        }
    }
    
    var accessory: SFSymbol? {
        switch self {
        case .wordGenCurrentWordTransitionStyle: nil
        }
    }
}

