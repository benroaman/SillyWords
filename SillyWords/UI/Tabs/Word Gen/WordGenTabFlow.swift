//
//  WordGenTabFlow.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/20/26.
//

import SwiftUI

struct WordGenTabFlow<M: WordGenTabFlowModel>: View {
    @State var model: M
    var body: some View {
        NavigationStack(path: $model.navigation.wordGenTabRouter.path) {
            WordGenView(model: WordGenViewModelProd(generator: model.generator,
                                                                  favorites: model.favorites,
                                                                  navigation: model.navigation,
                                                                  settings: model.settings))
            .navigationDestination(for: MainRoute.self, destination: getDestination(for:))
        }
    }
}

private extension WordGenTabFlow {
    @ViewBuilder func getDestination(for route: MainRoute) -> some View {
        switch route {
        case .settingsWordGen: SettingsWordGenMenuView(model: SettingsWordGenMenuViewModelProd(model.navigation.wordGenTabRouter))
        case .settingsSyllables: SettingsSyllablesMenuView(settings: model.settings)
        case .settingsConsonants: SettingsConsonantsMenuView(settings: model.settings)
        case .settingsVowels: SettingsVowelsMenuView(settings: model.settings)
        case .historyList: WordGenHistoryView(model: WordGenHistoryViewModelProd(generator: model.generator,
                                                                                               favorites: model.favorites,
                                                                                               navigation: model.navigation))
        case .settingsUserInterface: SettingsUserInterfaceMenuView(model: SettingsUserInterfaceMenuViewModelProd(settings: model.settings,
                                                                                                                 router: model.navigation.wordGenTabRouter))
        case .settingsWordGenCurrentWordTransition: SettingsWordGenCurrentWordTransitionMenuView(model: SettingsWordGenCurrentWordTransitionMenuViewModelProd(settings: model.settings))
        case .settingsFavorites, .favoriteWordDetail: BadRouteView(route: route)
        }
    }
}

#Preview {
    WordGenTabFlow(model: WordGenTabFlowModelPreview())
}

protocol WordGenTabFlowModel: AnyObject {
    var settings: SettingsManager { get }
    var generator: GenerationManager { get }
    var favorites: FavoritesManager { get }
    var navigation: any WordGenTabNavigation { get set }
}

class WordGenTabFlowModelPreview: WordGenTabFlowModel {
    let settings: SettingsManager = SettingsManager()
    let generator: GenerationManager = GenerationManager(SettingsManager())
    let favorites: FavoritesManager = FavoritesManager(.preview)
    var navigation: any WordGenTabNavigation = WordGenTabNavigationPreview()
}

class WordGenTabFlowModelProd: WordGenTabFlowModel {
    let settings: SettingsManager
    let generator: GenerationManager
    let favorites: FavoritesManager
    var navigation: any WordGenTabNavigation
    
    init(state: AppState) {
        self.settings = state.settings
        self.generator = state.generator
        self.favorites = state.favorites
        self.navigation = state.navigation
    }
}

protocol WordGenTabNavigation: AnyObject, Observable, EmailNavigation {
    var wordGenTabRouter: Router<MainRoute> { get set }
}

@Observable class WordGenTabNavigationPreview: WordGenTabNavigation {
    var wordGenTabRouter: Router<MainRoute> = .init()
    var presentedEmail: Email?
}


