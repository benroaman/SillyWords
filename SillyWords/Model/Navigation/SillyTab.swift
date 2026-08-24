//
//  SillyTab.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/3/26.
//

import Foundation

enum SillyTab: String, TabIterable {
    case words, settings, favorites
    
    static var available: [SillyTab] { [.words, .favorites, .settings] }
    
    var id: String { rawValue }
    
    var icon: SFSymbol {
        switch self {
        case .words: .characterBubble
        case .favorites: .heart
        case .settings: .gearshape
        }
    }
    
    var title: String {
        switch self {
        case .words: "Word Gen"
        case .settings: "Settings"
        case .favorites: "Favorites"
        }
    }
}
