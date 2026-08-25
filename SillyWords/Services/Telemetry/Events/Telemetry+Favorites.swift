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
    
    static func trackAddFavorite(context: FavoriteContext) {
        track(.addFavorite, attributes: [.context: context.rawValue])
    }
    
    static func trackRemoveFavorite(context: FavoriteContext) {
        track(.removeFavorite, attributes: [.context: context.rawValue])
    }
    
    static func trackClearFavorites() {
        track(.clearFavorites)
    }
}
