//
//  FavoritesManager.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/3/26.
//

import Foundation

@Observable
class FavoritesManager {
    private(set) var favorites: [Favorite] = Settings.Favorites.Favorites.current
    
    func addFavorite(_ word: String) {
        let favorite = Favorite(word: word, dateCreated: Date())
        favorites.append(favorite)
        Settings.Favorites.Favorites.set(favorites)
    }
    
    func isFavorite(_ word: String) -> Bool {
        Set(favorites).contains(Favorite(word: word, dateCreated: Date()))
    }
    
    func removeFavoritee(_ word: String) {
        favorites = favorites.filter({ $0.word != word })
        Settings.Favorites.Favorites.set(favorites)
    }
    
    func toggleFavorite(_ word: String) {
        if let target = favorites.firstIndex(where: { $0.word == word }) {
            favorites.remove(at: target)
        } else {
            favorites.append(Favorite(word: word, dateCreated: Date()))
        }
        Settings.Favorites.Favorites.set(favorites)
    }
    
    func clearFavorites() {
        favorites = []
        Settings.Favorites.Favorites.set(favorites)
    }
}
