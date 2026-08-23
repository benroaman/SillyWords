//
//  WordGenerationViewModel.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/20/26.
//

import Foundation

protocol WordGenerationViewModel: AnyObject, Observable {
    var currentWord: String { get }
    var currentWordSentence: String { get }
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
    var currentWord = "brismucect"
    private(set) var currentWordSentence = SentenceGenerator.useItInASentence("brismucect")
    private let pool = ["brismucect", "glunde", "okay", "words", "aja", "coolbeans", "djbouti", "blackalicious", "radio", "parliament"]
    private(set) var isCurrentWordFavorite: Bool = false
    var toggleFavoriteFailure: String?
    
    func onWordGenerationNewWordTap() {
        currentWord = pool.randomElement()!
        currentWordSentence = SentenceGenerator.useItInASentence(currentWord)
    }
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
    private(set) var currentWordSentence: String
    var isCurrentWordFavorite: Bool { favorites.isFavorite(currentWord) }
    
    init(generator: GenerationManager, favorites: FavoritesManager, navigation: any WordGenerationTabNavigation) {
        self.generator = generator
        self.favorites = favorites
        self.navigation = navigation
        self.currentWordSentence = SentenceGenerator.useItInASentence(generator.currentWordText)
    }
    
    func onWordGenerationNewWordTap() {
        generator.makeWord()
        currentWordSentence = SentenceGenerator.useItInASentence(currentWord)
        print(currentWord)
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
