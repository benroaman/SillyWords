//
//  FavoritesTabFlowModel.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/21/26.
//

import SwiftUI

// MARK: Requirements
protocol FavoritesTabFlowModel: AnyObject, Observable {
    associatedtype Destination: View
    associatedtype RootViewModel: FavoritesListViewModel
    var router: Router<MainRoute> { get set }
    @ViewBuilder func destination(for route: MainRoute) -> Destination
    func makeRootViewModel() -> RootViewModel
}

// MARK: Preview Implementation
@Observable class FavoritesTabFlowModelPreview: FavoritesTabFlowModel {
    var router = Router<MainRoute>()
    @ViewBuilder func destination(for route: MainRoute) -> some View { Text(route.description) }
    func makeRootViewModel() -> FavoritesListViewModelPreview { FavoritesListViewModelPreview() }
}

// MARK: Prod Implementation
@Observable class FavoritesTabFlowModelProd: FavoritesTabFlowModel {
    // MARK: Instance Constants
    private let state: AppState
    
    // MARK: Initializers
    init(state: AppState) {
        self.state = state
        self.router = state.navigation.favoritesTabRouter
    }
    
    // MARK: FavoritesTabFlowModel Implementation
    var router: Router<MainRoute>
    
    @ViewBuilder func destination(for route: MainRoute) -> some View {
        state.navigation.destination(for: route, in: .favorites, with: state)
//        switch route {
//            #warning("TODO: Implement favorite detail screen")
//        case .favoriteWordDetail(let favorite): EmptyView()
//        case .settingsWordGen, .settingsFavorites, .settingsSyllables, .settingsConsonants, .settingsVowels, .historyList, .settingsUserInterface, .settingsWordGenCurrentWordTransition, .settingsSentences, .settingsWordGenPresets: BadRouteView(route: route, flow: .favoritesTab)
//        }
    }

    func makeRootViewModel() -> FavoritesListviewModelProd { FavoritesListviewModelProd(manager: state.favorites, navigation: state.navigation) }
}
