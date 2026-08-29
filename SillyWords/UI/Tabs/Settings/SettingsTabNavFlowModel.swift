//
//  SettingsTabNavFlowModel.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/14/26.
//

import Foundation
import SwiftUI

// MARK: Requirements
protocol SettingsTabNavFlowModel: AnyObject, Observable {
    associatedtype Destination: View
    associatedtype RootViewModel: SettingsMainMenuViewModel
    var router: Router<MainRoute> { get set }
    @ViewBuilder func destination(for route: MainRoute) -> Destination
    func getRootViewModel() -> RootViewModel
}

// MARK: Preview Implementation
@Observable class SettingsTabFlowModelPreview: SettingsTabNavFlowModel {
    var router = Router<MainRoute>()
    @ViewBuilder func destination(for route: MainRoute) -> some View {
        Text(route.description)
    }
    func getRootViewModel() -> SettingsMainMenuViewModelPreview { SettingsMainMenuViewModelPreview() }
}

// MARK: Prod Implementation
@Observable class SettingsTabFlowModelProd: SettingsTabNavFlowModel {
    // MARK: Instance Constants
    let state: AppState
    
    // MARK: Initializers
    init(state: AppState) {
        self.state = state
        self.router = state.navigation.settingsTabRouter
    }
        
    // MARK: SettingsTabFlowModel Implementation
    var router: Router<MainRoute>
    
    @ViewBuilder func destination(for route: MainRoute) -> some View {
        switch route {
        case .settingsWordGen: SettingsWordGenMenuView(model: SettingsWordGenMenuViewModelProd(router))
        case .settingsVowels: SettingsVowelsMenuView(settings: state.settings)
        case .settingsSyllables: SettingsSyllablesMenuView(settings: state.settings)
        case .settingsConsonants: SettingsConsonantsMenuView(settings: state.settings)
        case .settingsFavorites: SettingsFavoritesMenuView(model: SettingsFavoritesMenuViewModelProd(state.favorites))
        case .settingsUserInterface: SettingsUserInterfaceMenuView(model: SettingsUserInterfaceMenuViewModelProd(settings: state.settings, router: router))
        case .settingsWordGenCurrentWordTransition: SettingsWordGenCurrentWordTransitionMenuView(model: SettingsWordGenCurrentWordTransitionMenuViewModelProd(settings: state.settings))
        case .settingsSentences: SettingsSentencesMenuView(settings: state.settings)
        case .settingsWordGenPresets: SettingsWordGenPresetsMenuView(model: SettingsWordGenPresetsMenuViewModelProd(settings: state.settings))
        case .favoriteWordDetail, .historyList: BadRouteView(route: route, flow: .settingsTab)
        }
    }
    
    func getRootViewModel() -> SettingsMainMenuViewModelProd<NavigationManager> {
        SettingsMainMenuViewModelProd(state.navigation)
    }
}

