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
            FavoritesView(model: .init(model.favorites))
        }
    }
}

#Preview {
    FavoritesTabFlow(model: FavoritesTabFlowModelPreview())
}

protocol FavoritesTabFlowModel: AnyObject, Observable {
    var favorites: FavoritesManager { get }
    var navigation: any FavoritesTabNavigation { get set }
}

@Observable class FavoritesTabFlowModelPreview: FavoritesTabFlowModel {
    let favorites: FavoritesManager = FavoritesManager(.preview)
    var navigation: any FavoritesTabNavigation = FavoritesTabNavigationPreview()
}

@Observable class FavoritesTabFlowModelProd: FavoritesTabFlowModel {
    let favorites: FavoritesManager
    var navigation: any FavoritesTabNavigation
    
    init(state: AppState) {
        self.favorites = state.favorites
        self.navigation = state.navigation
    }
}

protocol FavoritesTabNavigation: AnyObject, Observable {
    var favoritesTabRouter: Router<MainRoute> { get set }
    var presentedEmail: Email? { get set }
}

@Observable class FavoritesTabNavigationPreview: FavoritesTabNavigation {
    var favoritesTabRouter: Router<MainRoute> = .init()
    var presentedEmail: Email?
}
