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
    var currentTab: SillyTab = .words
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
    }
}
