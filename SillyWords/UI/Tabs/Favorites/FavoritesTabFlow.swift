//
//  FavoritesTabFlow.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/20/26.
//

import SwiftUI

struct FavoritesTabFlow<M: FavoritesTabFlowModel>: View {
    @State var model: M
    
    var body: some View {
        NavigationStack(path: $model.navigation.favoritesTabRouter.path) {
            FavoritesListView(model: FavoritesListviewModelProd(manager: model.favorites, navigation: model.navigation))
                .navigationDestination(for: MainRoute.self, destination: getDestination(for:))
        }
    }
}

private extension FavoritesTabFlow {
    @ViewBuilder func getDestination(for route: MainRoute) -> some View {
        switch route {
            #warning("TODO: Implement favorite detail screen")
        case .favoriteWordDetail(let favorite): EmptyView()
        case .settingsWordGeneration, .settingsFavorites, .settingsSyllables, .settingsConsonants, .settingsVowels, .historyList: BadRouteView(route: route)
        }
    }
}

#Preview {
    FavoritesTabFlow(model: FavoritesTabFlowModelPreview())
}
