//
//  WordGenHistoryViewModel\.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/24/26.
//

import SwiftUI

// MARK: Requirements
protocol WordGenHistoryViewModel: AnyObject, Observable {
    var toggleFavoriteFailure: String? { get set }
    
    func reportOffensiveWord(_ word: Word)
    func reportWordAsLowQuality(_ word: Word)
    func toggleFavorite(word: Word)
}

// MARK: Preview Implementation
@Observable class WordGenHistoryViewModelPreview: WordGenHistoryViewModel {
    var toggleFavoriteFailure: String?
    func reportOffensiveWord(_ word: Word) { print("Offensive") }
    func reportWordAsLowQuality(_ word: Word) { print("Low Quality") }
    func toggleFavorite(word: Word) { word.isFavorite.toggle() }
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
    var toggleFavoriteFailure: String?
    
    func reportOffensiveWord(_ word: Word) {
        guard let text = word.text else { return }
        navigation.presentedEmail = .offensive(word: text)
    }
    
    func reportWordAsLowQuality(_ word: Word) {
        guard let text = word.text else { return }
        navigation.presentedEmail = .poorQuality(word: text)
    }
    
    func toggleFavorite(word: Word) {
        Task {
            do {
                try await favorites.toggleFavorite(word, context: .wordGenHistory)
            } catch {
                await MainActor.run {
                    if let message = (error as? DatabaseError)?.userMessage {
                        self.toggleFavoriteFailure = "Failed to update favorites: \(message)."
                    } else {
                        self.toggleFavoriteFailure = "Failed to update favorites."
                    }
                }
            }
        }
    }
}
