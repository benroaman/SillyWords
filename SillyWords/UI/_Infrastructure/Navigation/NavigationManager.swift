//
//  NavigationManager.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/24/26.
//

import Foundation

@Observable class NavigationManager: WordGenTabNavigation, FavoritesTabNavigation, SettingsTabNavigation {
    var currentTab: SillyTab = .words
    
    // MARK: Shared Implementation - WordGenTabNavigation, FavoritesTabNavigation
    var presentedEmail: Email?
    
    // MARK: WordGenTabNavigation Implementation
    var wordGenTabRouter: Router<MainRoute> = .init()
    
    // MARK: FavoritesTabNavigation Implementation
    var favoritesTabRouter: Router<MainRoute> = .init()
    
    // MARK: SettingsTabNavigation Implementation
    var settingsTabRouter: Router<MainRoute> = .init()
}

protocol EmailNavigation: AnyObject, Observable {
    var presentedEmail: Email? { get set }
}
