//
//  WordGenHistoryViewModel\.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/24/26.
//

import SwiftUI

// MARK: Requirements
protocol WordGenHistoryViewModel: AnyObject, Observable {
    var words: [GeneratedWord] { get }
    var toggleFavoriteFailure: String? { get set }
    
    func isWordFavorite(_ word: GeneratedWord) -> Bool
    func reportOffensiveWord(_ word: GeneratedWord)
    func reportWordAsLowQuality(_ word: GeneratedWord)
    func toggleFavorite(word: GeneratedWord)
}

// MARK: Preview Implementation
@Observable class WordGenHistoryViewModelPreview: WordGenHistoryViewModel {
    /// Instance Variables
    private var favorites: Set<String> = []
    
    /// WordGenHistoryViewModel Requirements
    let words: [GeneratedWord] = [.mock1, .mock2, .mock3, .mock4, .mock5, .mock6]
    var toggleFavoriteFailure: String?
    
    func isWordFavorite(_ word: GeneratedWord) -> Bool {
        favorites.contains(word.word)
    }
    
    func reportOffensiveWord(_ word: GeneratedWord) { print("Offensive") }
    
    func reportWordAsLowQuality(_ word: GeneratedWord) { print("Low Quality") }
    
    func toggleFavorite(word: GeneratedWord) {
        if favorites.contains(word.word) {
            favorites.remove(word.word)
        } else {
            favorites.insert(word.word)
        }
    }
}

// MARK: Prod Implementation
@Observable class WordGenHistoryViewModelProd: WordGenHistoryViewModel {
    /// Instance Constants
    private let generator: GenerationManager
    private let favorites: FavoritesManager
    private let navigation: any EmailNavigation
    
    /// Initializers
    init(state: AppState) {
        self.generator = state.generator
        self.favorites = state.favorites
        self.navigation = state.navigation
    }
    
    /// WordGenHistoryViewModel Implementation
    var words: [GeneratedWord] { generator.words }
    var toggleFavoriteFailure: String?
    
    func isWordFavorite(_ word: GeneratedWord) -> Bool {
        favorites.isFavorite(word.word)
    }
    
    func reportOffensiveWord(_ word: GeneratedWord) {
        navigation.presentedEmail = .offensive(word: word.word)
    }
    
    func reportWordAsLowQuality(_ word: GeneratedWord) {
        navigation.presentedEmail = .poorQuality(word: word.word)
    }
    
    func toggleFavorite(word: GeneratedWord) {
        Task {
            do {
                try await favorites.toggleFavorite(word, context: .wordGenHistory)
            } catch {
                toggleFavoriteFailure = "Failed to update favorites: \((error as? DatabaseError)?.description ?? error.localizedDescription)"
            }
        }
    }
}
