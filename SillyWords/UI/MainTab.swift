//
//  MainTab.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/19/26.
//

import Foundation

enum MainTab: String, TabIterable {
    case generation
    case favorites
    case settings
    
    static var available: [MainTab] { [.generation, .favorites, .settings] }
    
    var id: String { rawValue }
    
    var icon: SFSymbol {
        switch self {
        case .generation: .bubbleFill
        case .favorites: .starFill
        case .settings: .gearshapeFill
        }
    }
    
    var title: String {
        switch self {
        case .generation: "Word Generation"
        case .favorites: "Favorites"
        case .settings: "Settings"
        }
    }
}
