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
    
    init(_ database: Database) {
        self.database = database
    }
    
    func addFavorite(_ word: GeneratedWord) async throws {
        try await database.createFavorite(content: word)
        favoriteWords.insert(word.word)
    }
    
    func isFavorite(_ word: String) -> Bool {
        favoriteWords.contains(word)
    }
    
    func removeFavorite(_ word: String) async throws {
        try await database.deleteFavorite(word)
        favoriteWords.remove(word)
    }
    
    func removeFavorite(_ word: Flavorite) async throws {
        let wordActual = await database.getWord(from: word)
        try await database.deleteFavorite(word)
        if let wordActual {
            favoriteWords.remove(wordActual)
        }
    }
    
    func toggleFavorite(_ word: GeneratedWord) async throws {
        if favoriteWords.contains(word.word) {
            try await database.deleteFavorite(word.word)
            favoriteWords.remove(word.word)
        } else {
            try await database.createFavorite(content: word)
            favoriteWords.insert(word.word)
        }
    }
    
    func clearFavorites() async throws {
        try await database.clearAllFavorites()
        favoriteWords = []
    }
}
