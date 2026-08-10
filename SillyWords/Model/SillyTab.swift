//
//  SillyTab.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/3/26.
//

import Foundation

enum SillyTab {
    case words, settings, favorites
    
    var systemImageNameSelected: String {
        switch self {
        case .words: return "bubble.fill"
        case .settings: return "gearshape.fill"
        case .favorites: return "heart.fill"
        }
    }
    
    var systemImageNameUnselected: String {
        switch self {
        case .words: return "bubble"
        case .settings: return "gearshape"
        case .favorites: return "heart"
        }
    }
    
    func systemImageName(with selectedTab: Self) -> String {
        (selectedTab == self) ? systemImageNameSelected : systemImageNameUnselected
    }
    
    var title: String {
        switch self {
        case .words: return "Words"
        case .settings: return "Settings"
        case .favorites: return "Favorites"
        }
    }
}
