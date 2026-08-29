//
//  AppState.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/3/26.
//

import Foundation
import BRWordGeneration

class AppState {
    var navigation: NavigationManager
    let settings: SettingsManager
    let generator: GenerationManager
    let favorites: FavoritesManager
    let database: Database
    
    init() {
        let settingsManager = SettingsManager()
        self.settings = settingsManager
        
        let database = Database()
        self.database = database
        self.favorites = FavoritesManager(database)
        self.generator = GenerationManager(settingsManager, database: database)
        
        self.navigation = NavigationManager()
    }
}
