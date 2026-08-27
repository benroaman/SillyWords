//
//  Telemetry+Favorites.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/24/26.
//

import Foundation

extension Telemetry {
    enum FavoriteContext: String {
        case wordGenMain
        case wordGenHistory
        case favoritesList
        case favoriteDetail
    }
    
    static func trackAddFavorite(_ context: FavoriteContext) {
        track(.addFavorite, attributes: [.context: context.rawValue])
    }
    
    static func trackRemoveFavorite(_ context: FavoriteContext) {
        track(.removeFavorite, attributes: [.context: context.rawValue])
    }
    
    static func trackRemoveAllFavorites() {
        track(.removeAllFavorites)
    }
}
