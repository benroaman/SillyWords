//
//  FavoritesManager.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/3/26.
//

import Foundation
import CoreData

@Observable
class FavoritesManager {
    private let database: Database
    private(set) var favoriteWords: Set<String> = []
    
    var hasFavorites: Bool { !favoriteWords.isEmpty }
    
    init(_ database: Database) {
        self.database = database
        self.favoriteWords = database.allFavoriteWordStrings()
    }
    
    func addFavorite(_ word: GeneratedWord, context: Telemetry.FavoriteContext) async throws {
        try await database.createFavorite(content: word)
        favoriteWords.insert(word.word)
        Telemetry.trackAddFavorite(context: context)
    }
    
    func isFavorite(_ word: String) -> Bool {
        favoriteWords.contains(word)
    }
    
    func removeFavorite(_ word: String, context: Telemetry.FavoriteContext) async throws {
        try await database.deleteFavorite(word)
        favoriteWords.remove(word)
        Telemetry.trackRemoveFavorite(context: context)
    }
    
    func removeFavorite(_ word: Favorite, context: Telemetry.FavoriteContext) async throws {
        let wordActual = await database.getWord(from: word)
        try await database.deleteFavorite(word)
        if let wordActual {
            favoriteWords.remove(wordActual)
        }
        Telemetry.trackRemoveFavorite(context: context)
    }
    
    func toggleFavorite(_ word: GeneratedWord, context: Telemetry.FavoriteContext) async throws {
        if favoriteWords.contains(word.word) {
            try await database.deleteFavorite(word.word)
            favoriteWords.remove(word.word)
            Telemetry.trackRemoveFavorite(context: context)
        } else {
            try await database.createFavorite(content: word)
            favoriteWords.insert(word.word)
            Telemetry.trackAddFavorite(context: context)
        }
    }
    
    func clearFavorites() async throws {
        try await database.clearAllFavorites()
        favoriteWords = []
        Telemetry.trackClearFavorites()
    }
}
