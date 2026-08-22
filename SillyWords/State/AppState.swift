//
//  AppState.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/3/26.
//

import Foundation
import BRWordGeneration

@Observable
class AppState {
    var navigation: NavigationManager
    let settings: SettingsManager
    let generator: GenerationManager
    let favorites: FavoritesManager
    let database: Database
    
    init() {
        let settingsManager = SettingsManager()
        self.settings = settingsManager
        self.generator = GenerationManager(settingsManager)
        
        let database = Database()
        self.database = database
        self.favorites = FavoritesManager(database)
        
        self.navigation = NavigationManager()
    }
}

@Observable class NavigationManager: WordGenerationTabNavigation, FavoritesTabNavigation, SettingsTabNavigation {
    var currentTab: SillyTab = .words
    
    // MARK: Shared Implementation - WordGenerationTabNavigation, FavoritesTabNavigation
    var presentedEmail: Email?
    
    // MARK: WordGenerationTabNavigation Implementation
    var wordGenerationTabRouter: Router<MainRoute> = .init()
    
    // MARK: FavoritesTabNavigation Implementation
    var favoritesTabRouter: Router<MainRoute> = .init()
    
    // MARK: SettingsTabNavigation Implementation
    var settingsTabRouter: Router<MainRoute> = .init()
}

protocol EmailNavigation: AnyObject, Observable {
    var presentedEmail: Email? { get set }
}
