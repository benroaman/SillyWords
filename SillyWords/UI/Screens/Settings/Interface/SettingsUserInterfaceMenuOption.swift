//
//  SettingsUserInterfaceMenuOption.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/23/26.
//

import SwiftUI

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
        case .wordGenCurrentWordTransitionStyle: Style.Theme.Color.userInterface
        }
    }
    
    var accessory: SFSymbol? {
        switch self {
        case .wordGenCurrentWordTransitionStyle: nil
        }
    }
}

