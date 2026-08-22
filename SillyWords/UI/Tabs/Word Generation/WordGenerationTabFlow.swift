//
//  WordGenerationTabFlow.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/20/26.
//

import SwiftUI

struct WordGenerationTabFlow<M: WordGenerationTabFlowModel>: View {
    @State var model: M
    var body: some View {
        NavigationStack(path: $model.navigation.wordGenerationTabRouter.path) {
            WordGenerationView(model: WordGenerationViewModelProd(generator: model.generator,
                                                                  favorites: model.favorites,
                                                                  navigation: model.navigation))
            .navigationDestination(for: MainRoute.self, destination: getDestination(for:))
        }
    }
}

private extension WordGenerationTabFlow {
    @ViewBuilder func getDestination(for route: MainRoute) -> some View {
        switch route {
        case .settingsWordGeneration: SettingsWordGenMenuView(model: SettingsWordGenMenuViewModelProd(model.navigation.wordGenerationTabRouter))
        case .settingsSyllables: SettingsSyllablesMenuView(settings: model.settings)
        case .settingsConsonants: SettingsConsonantsMenuView(settings: model.settings)
        case .settingsVowels: SettingsVowelsMenuView(settings: model.settings)
        case .historyList: WordGenerationHistoryView(model: WordGenerationHistoryViewModelProd(generator: model.generator,
                                                                                               favorites: model.favorites,
                                                                                               navigation: model.navigation))
        case .settingsFavorites, .favoriteWordDetail: BadRouteView(route: route)
        }
    }
}

#Preview {
    WordGenerationTabFlow(model: WordGenerationTabFlowModelPreview())
}

protocol WordGenerationTabFlowModel: AnyObject {
    var settings: SettingsManager { get }
    var generator: GenerationManager { get }
    var favorites: FavoritesManager { get }
    var navigation: any WordGenerationTabNavigation { get set }
}

class WordGenerationTabFlowModelPreview: WordGenerationTabFlowModel {
    let settings: SettingsManager = SettingsManager()
    let generator: GenerationManager = GenerationManager(SettingsManager())
    let favorites: FavoritesManager = FavoritesManager(.preview)
    var navigation: any WordGenerationTabNavigation = WordGenerationTabNavigationPreview()
}

class WordGenerationTabFlowModelProd: WordGenerationTabFlowModel {
    let settings: SettingsManager
    let generator: GenerationManager
    let favorites: FavoritesManager
    var navigation: any WordGenerationTabNavigation
    
    init(state: AppState) {
        self.settings = state.settings
        self.generator = state.generator
        self.favorites = state.favorites
        self.navigation = state.navigation
    }
}

protocol WordGenerationTabNavigation: AnyObject, Observable, EmailNavigation {
    var wordGenerationTabRouter: Router<MainRoute> { get set }
}

@Observable class WordGenerationTabNavigationPreview: WordGenerationTabNavigation {
    var wordGenerationTabRouter: Router<MainRoute> = .init()
    var presentedEmail: Email?
}


