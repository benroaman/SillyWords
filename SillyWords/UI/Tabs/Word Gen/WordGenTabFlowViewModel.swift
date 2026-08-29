//
//  WordGenTabFlowViewModel.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/24/26.
//

import SwiftUI

// MARK: Requirements
protocol WordGenTabNavFlowModel: AnyObject {
    associatedtype Destination: View
    associatedtype RootViewModel: WordGenViewModel
    var router: Router<MainRoute> { get set }
    @ViewBuilder func destination(for route: MainRoute) -> Destination
    func getWordGenViewModel() -> RootViewModel
}

// MARK: Preview Implementation
class WordGenTabFlowModelPreview: WordGenTabNavFlowModel {
    var router = Router<MainRoute>()
    @ViewBuilder func destination(for route: MainRoute) -> some View { Text(route.description) }
    func getWordGenViewModel() -> WordGenViewModelPreview { WordGenViewModelPreview() }
}

// MARK: Prod Implementation
class WordGenTabFlowModelProd: WordGenTabNavFlowModel {
    /// Instance Constants
    private let state: AppState
    
    // Initializers
    init(state: AppState) {
        self.state = state
        self.router = state.navigation.wordGenTabRouter
    }
    
    /// WordGenTabFlowModel Implementation
    var router: Router<MainRoute>
    
    func destination(for route: MainRoute) -> some View {
        switch route {
        case .settingsWordGen: SettingsWordGenMenuView(model: SettingsWordGenMenuViewModelProd(router))
        case .settingsSyllables: SettingsSyllablesMenuView(settings: state.settings)
        case .settingsConsonants: SettingsConsonantsMenuView(settings: state.settings)
        case .settingsVowels: SettingsVowelsMenuView(settings: state.settings)
        case .historyList: WordGenHistoryView(model: WordGenHistoryViewModelProd(state: state))
        case .settingsUserInterface: SettingsUserInterfaceMenuView(model: SettingsUserInterfaceMenuViewModelProd(settings: state.settings,
                                                                                                                 router: router))
        case .settingsWordGenCurrentWordTransition: SettingsWordGenCurrentWordTransitionMenuView(model: SettingsWordGenCurrentWordTransitionMenuViewModelProd(settings: state.settings))
        case .settingsSentences: SettingsSentencesMenuView(settings: state.settings)
        case .settingsWordGenPresets: SettingsWordGenPresetsMenuView(model: SettingsWordGenPresetsMenuViewModelProd(settings: state.settings))
        case .settingsFavorites, .favoriteWordDetail: BadRouteView(route: route, flow: .wordGenTab)
        }
    }
    
    func getWordGenViewModel() -> some WordGenViewModel {
        WordGenViewModelProd(generator: state.generator,
                             favorites: state.favorites,
                             navigation: state.navigation,
                             settings: state.settings)
    }
}
