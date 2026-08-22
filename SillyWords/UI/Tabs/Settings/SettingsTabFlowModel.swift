//
//  SettingsTabModel.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/14/26.
//

import Foundation
import SwiftUI

// MARK: Requirements
protocol SettingsTabFlowModel: AnyObject, Observable {
    associatedtype Content: View
    associatedtype Navigation: SettingsTabNavigation
    var navigation: Navigation { get set }
    @ViewBuilder func destination(for route: MainRoute) -> Content
}

// MARK: Preview Implementation
@Observable class SettingsTabFlowModelPreview: SettingsTabFlowModel {
    var navigation = SettingsTabNavigationPreview()
    @ViewBuilder func destination(for route: MainRoute) -> some View {
        Text(route.description)
    }
}

// MARK: Prod Implementation
@Observable class SettingsTabFlowModelProd: SettingsTabFlowModel {
    let settings: SettingsManager
    let favorites: FavoritesManager
    
    init(state: AppState) {
        self.navigation = state.navigation
        self.settings = state.settings
        self.favorites = state.favorites
    }
        
    var navigation: NavigationManager
    
    @ViewBuilder func destination(for route: MainRoute) -> some View {
        switch route {
        case .settingsWordGeneration: SettingsWordGenMenuView(model: SettingsWordGenMenuViewModelProd(navigation.settingsTabRouter))
        case .settingsVowels: SettingsVowelsMenuView(settings: settings)
        case .settingsSyllables: SettingsSyllablesMenuView(settings: settings)
        case .settingsConsonants: SettingsConsonantsMenuView(settings: settings)
        case .settingsFavorites: SettingsFavoritesMenuView(model: SettingsFavoritesMenuViewModelProd(favorites))
        case .favoriteWordDetail, .historyList: BadRouteView(route: route)
        }
    }
}

