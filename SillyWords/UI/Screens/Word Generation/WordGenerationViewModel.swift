//
//  WordGenerationViewModel.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/20/26.
//

import Foundation

protocol WordGenerationViewModel: AnyObject, Observable {
    var currentWord: String { get }
    var isCurrentWordFavorite: Bool { get }
    var toggleFavoriteFailure: String? { get set }
    
    func onWordGenerationNewWordTap()
    func onWordGenerationFavoriteTap()
    func onWordGenerationHistoryTap()
    func onWordGenerationSettingsTap()
    func onWordGenerationReportOffensive()
    func onWordGenerationReportLowQuality()
}

@Observable class WordGenerationViewModelPreview: WordGenerationViewModel {
    let currentWord = "brismucect"
    private(set) var isCurrentWordFavorite: Bool = false
    var toggleFavoriteFailure: String?
    
    func onWordGenerationNewWordTap() { print("New Word Tap") }
    func onWordGenerationFavoriteTap() { isCurrentWordFavorite.toggle() }
    func onWordGenerationHistoryTap() { print("History Tap") }
    func onWordGenerationSettingsTap() { print("Settings Tap") }
    func onWordGenerationReportOffensive() { print("Offensive Tap") }
    func onWordGenerationReportLowQuality() { print("Low Quality Tap") }
}

@Observable class WordGenerationViewModelProd: WordGenerationViewModel {
    private let generator: GenerationManager
    private let favorites: FavoritesManager
    private let navigation: any WordGenerationTabNavigation
    
    @MainActor var toggleFavoriteFailure: String?
    
    var currentWord: String { generator.currentWordText }
    var isCurrentWordFavorite: Bool { favorites.isFavorite(currentWord) }
    
    init(generator: GenerationManager, favorites: FavoritesManager, navigation: any WordGenerationTabNavigation) {
        self.generator = generator
        self.favorites = favorites
        self.navigation = navigation
    }
    
    func onWordGenerationNewWordTap() {
        generator.makeWord()
    }
    
    func onWordGenerationFavoriteTap() {
        guard let word = generator.words.first else { return }
        Task {
            do {
                try await favorites.toggleFavorite(word)
            } catch {
                toggleFavoriteFailure = "Failed to update favorites: \((error as? DatabaseError)?.description ?? error.localizedDescription)"
            }
        }
    }
    
    func onWordGenerationHistoryTap() {
        navigation.wordGenerationTabRouter.push(.historyList)
    }
    
    func onWordGenerationSettingsTap() {
        navigation.wordGenerationTabRouter.push(.settingsWordGeneration)
    }
    
    func onWordGenerationReportOffensive() {
        navigation.presentedEmail = .offensive(word: currentWord)
    }
    
    func onWordGenerationReportLowQuality() {
        navigation.presentedEmail = .poorQuality(word: currentWord)
    }
}
