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
    private(set) var loadFavoriteWordsError: Error?
    
    var hasFavorites: Bool { !favoriteWords.isEmpty }
    
    init(_ database: Database) {
        self.database = database
        do {
            self.favoriteWords = try database.allFavoriteWordStrings()
        } catch {
            self.loadFavoriteWordsError = error
            self.favoriteWords = []
        }
    }
    
    func addFavorite(_ word: GeneratedWord, context: Telemetry.FavoriteContext) async throws {
        try await database.createWord(content: word)
        favoriteWords.insert(word.word)
        Telemetry.trackAddFavorite(context: context)
    }
    
    func isFavorite(_ word: String) -> Bool {
        favoriteWords.contains(word)
    }
    
    func removeFavorite(_ word: String, context: Telemetry.FavoriteContext) async throws {
        try await database.removeFavorite(word)
        favoriteWords.remove(word)
        Telemetry.trackRemoveFavorite(context: context)
    }
    
    func removeFavorite(_ word: Favorite, context: Telemetry.FavoriteContext) async throws {
        let wordActual = try await database.getWord(from: word)
        try await database.removeFavorite(word)
        if let wordActual {
            favoriteWords.remove(wordActual)
        }
        Telemetry.trackRemoveFavorite(context: context)
    }
    
    func toggleFavorite(_ word: GeneratedWord, context: Telemetry.FavoriteContext) async throws {
        if let loadFavoriteWordsError { throw loadFavoriteWordsError }
        if favoriteWords.contains(word.word) {
            try await database.removeFavorite(word.word)
            favoriteWords.remove(word.word)
            Telemetry.trackRemoveFavorite(context: context)
        } else {
            try await database.createWord(content: word)
            favoriteWords.insert(word.word)
            Telemetry.trackAddFavorite(context: context)
        }
    }
    
    func clearFavorites() async throws {
        try await database.removeAllFavorites()
        favoriteWords = []
        Telemetry.trackClearFavorites()
    }
}
