//
//  FavoritesTabFlowModel.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/21/26.
//

import Foundation

// MARK: Requirements
protocol FavoritesTabFlowModel: AnyObject, Observable {
    var favorites: FavoritesManager { get }
    var navigation: any FavoritesTabNavigation { get set }
}

// MARK: Preview Implementation
@Observable class FavoritesTabFlowModelPreview: FavoritesTabFlowModel {
    let favorites: FavoritesManager = FavoritesManager(.preview)
    var navigation: any FavoritesTabNavigation = FavoritesTabNavigationPreview()
}

// MARK: Prod Implementation
@Observable class FavoritesTabFlowModelProd: FavoritesTabFlowModel {
    let favorites: FavoritesManager
    var navigation: any FavoritesTabNavigation
    
    init(state: AppState) {
        self.favorites = state.favorites
        self.navigation = state.navigation
    }
}
