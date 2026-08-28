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
//    private(set) var favoriteWords: Set<String> = []
//    private(set) var loadFavoriteWordsError: Error?
    
    var hasFavorites: Bool { database.hasFavorites() }
    
    init(_ database: Database) {
        self.database = database
    }
    
//    init(_ database: Database) {
//        self.database = database
//        do {
//            self.favoriteWords = try database.allFavoriteWordStrings()
//        } catch {
//            self.loadFavoriteWordsError = error
//            self.favoriteWords = []
//        }
//    }
    
    func addFavorite(_ word: Word, context: Telemetry.FavoriteContext) async throws {
        #warning("TODO: Is this good?")
//        guard let text = try await database.getText(from: word) else { return }
        try await database.addFavorite(word)
//        favoriteWords.insert(text)
        Telemetry.trackAddFavorite(context)
    }
    
    func addFavorite(_ text: String, context: Telemetry.FavoriteContext) async throws {
        try await database.addFavorite(text)
//        favoriteWords.insert(text)
        Telemetry.trackAddFavorite(context)
    }
    
    func isFavorite(_ text: String) -> Bool {
        database.isFavorite(text)
    }
    
    func removeFavorite(_ word: String, context: Telemetry.FavoriteContext) async throws {
        try await database.removeFavorite(word)
//        favoriteWords.remove(word)
        Telemetry.trackRemoveFavorite(context)
    }
    
    func removeFavorite(_ word: Word, context: Telemetry.FavoriteContext) async throws {
//        let wordActual = try await database.getText(from: word)
        try await database.removeFavorite(word)
//        if let wordActual {
//            favoriteWords.remove(wordActual)
//        }
        Telemetry.trackRemoveFavorite(context)
    }
    
    func toggleFavorite(_ word: GeneratedWord, context: Telemetry.FavoriteContext) async throws {
//        if let loadFavoriteWordsError { throw loadFavoriteWordsError }
        if let added = try await database.toggleFavorite(word.word) {
            added ? Telemetry.trackAddFavorite(context) : Telemetry.trackRemoveFavorite(context)
        }
    }
    
    func toggleFavorite(_ word: Word, context: Telemetry.FavoriteContext) async throws {
        if let added = try await database.toggleFavorite(word) {
            added ? Telemetry.trackAddFavorite(context) : Telemetry.trackRemoveFavorite(context)
        }
    }
    
    func clearFavorites() async throws {
        try await database.removeAllFavorites()
        Telemetry.trackRemoveAllFavorites()
    }
}
