//
//  NavigationManager.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/24/26.
//

import Foundation
import SwiftUI

@Observable class NavigationManager: WordGenTabNavigation, FavoritesTabNavigation, SettingsTabNavigation {
    // MARK: Instance Variables
    var currentTab: SillyTab = .words
    
    @ViewBuilder func destination(for route: MainRoute, in tab: SillyTab, with state: AppState) -> some View {
        switch route {
        case .settingsWordGen: SettingsWordGenMenuView(model: SettingsWordGenMenuViewModelProd(router(for: tab)))
        case .settingsFavorites: SettingsFavoritesMenuView(model: SettingsFavoritesMenuViewModelProd(state.favorites))
        case .settingsSyllables: SettingsSyllablesMenuView(settings: state.settings)
        case .settingsConsonants: SettingsConsonantsMenuView(settings: state.settings)
        case .settingsVowels: SettingsVowelsMenuView(settings: state.settings)
        case .settingsUserInterface: SettingsUserInterfaceMenuView(model: SettingsUserInterfaceMenuViewModelProd(settings: state.settings, router: router(for: tab)))
        case .settingsWordGenCurrentWordTransition: SettingsWordGenCurrentWordTransitionMenuView(model: SettingsWordGenCurrentWordTransitionMenuViewModelProd(settings: state.settings))
        case .settingsSentences: SettingsSentencesMenuView(settings: state.settings)
        case .settingsWordGenPresets: SettingsWordGenPresetsMenuView(model: SettingsWordGenPresetsMenuViewModelProd(settings: state.settings))
        case .historyList: WordGenHistoryView(model: WordGenHistoryViewModelProd(state: state))
            #warning("TODO: Implement a word detail view")
        case .favoriteWordDetail(_): EmptyView()
        }
    }
    
    func router(for tab: SillyTab) -> Router<MainRoute> {
        switch tab {
        case .words: wordGenTabRouter
        case .favorites: favoritesTabRouter
        case .settings: settingsTabRouter
        }
    }
    
    // MARK: EmailNavigation Implementation
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
