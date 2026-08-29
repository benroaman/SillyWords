//
//  WordGenViewModel.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/20/26.
//

import Foundation
import SwiftUI

// MARK: Requirements
protocol WordGenViewModel: AnyObject, Observable {
    var currentWord: String { get }
    var currentWordSentence: SentenceGenerator.Sentence { get }
    var isCurrentWordFavorite: Bool { get }
    var wordTransitionStyle: WordTransitionStyle { get }
    var showSentence: Bool { get }
    var showSentenceAttribution: Bool { get }
    var createWordRecordError: (any Error)? { get set }
    var toggleFavoriteError: (any Error)? { get set }
    
    func onWordGenNewWordTap()
    func onWordGenNewSentenceTap()
    func onWordGenFavoriteTap()
    func onWordGenHistoryTap()
    func onWordGenSettingsTap()
    func onWordGenReportOffensive()
    func onWordGenReportLowQuality()
}

// MARK: Preview Implementation
@Observable class WordGenViewModelPreview: WordGenViewModel {
    /// Instance Constants
    private let pool = ["brismucect", "glunde", "okay", "words", "aja", "coolbeans", "djbouti", "blackalicious", "radio", "parliament"]
    
    /// WordGenViewModel Implementation
    var currentWord = "brismucect"
    private(set) var currentWordSentence = SentenceGenerator.useItInASentence("brismucect")
    private(set) var isCurrentWordFavorite: Bool = false
    let wordTransitionStyle: WordTransitionStyle = .splode
    let showSentence: Bool = true
    let showSentenceAttribution: Bool = true
    
    var createWordRecordError: (any Error)?
    var toggleFavoriteError: (any Error)?
    
    func onWordGenNewWordTap() {
        currentWord = pool.randomElement()!
        currentWordSentence = SentenceGenerator.useItInASentence(currentWord)
    }
    func onWordGenNewSentenceTap() { currentWordSentence = SentenceGenerator.useItInASentence(currentWord) }
    func onWordGenFavoriteTap() { isCurrentWordFavorite.toggle() }
    func onWordGenHistoryTap() { print("History Tap") }
    func onWordGenSettingsTap() { print("Settings Tap") }
    func onWordGenReportOffensive() { print("Offensive Tap") }
    func onWordGenReportLowQuality() { print("Low Quality Tap") }
}

// MARK: Prod Implementation
@Observable class WordGenViewModelProd: WordGenViewModel {
    /// Instance Constants
    private let generator: GenerationManager
    private let favorites: FavoritesManager
    private let navigation: any WordGenTabNavigation
    private let settings: SettingsManager
    
    /// Initializers
    init(generator: GenerationManager, favorites: FavoritesManager, navigation: any WordGenTabNavigation, settings: SettingsManager) {
        self.generator = generator
        self.favorites = favorites
        self.navigation = navigation
        self.settings = settings
        self.currentWordSentence = SentenceGenerator.useItInASentence(generator.currentWordText)
        self.isCurrentWordFavorite = favorites.isFavorite(generator.currentWordText)
    }
    
    /// WordGenViewModel Implementation
    var currentWord: String { generator.currentWordText }
    private(set) var currentWordSentence: SentenceGenerator.Sentence
    private(set) var isCurrentWordFavorite: Bool
    var wordTransitionStyle: WordTransitionStyle {
        settings.wordGenCurrentWordTransitionStyle
    }
    var showSentence: Bool { settings.showSentenceOnMainWordGen }
    var showSentenceAttribution: Bool { settings.includeSentenceAttribution }
    
    var createWordRecordError: (any Error)?
    var toggleFavoriteError: (any Error)?
    
    func onWordGenNewWordTap() {
        Telemetry.trackCreateWord()
        do {
            try generator.makeWord()
        } catch {
            Task { @MainActor in
                self.createWordRecordError = error
            }
        }
        currentWordSentence = SentenceGenerator.useItInASentence(currentWord)
        isCurrentWordFavorite = false
    }
    
    func onWordGenNewSentenceTap() {
        currentWordSentence = SentenceGenerator.useItInASentence(currentWord)
        Telemetry.trackCreateSentence()
    }
    
    func onWordGenFavoriteTap() {
        Task {
            do {
                try await favorites.toggleFavorite(generator.currentWord, context: .wordGenMain)
                await MainActor.run {
                    self.isCurrentWordFavorite.toggle()
                }
            } catch {
                await MainActor.run {
                    self.toggleFavoriteError = error
                }
            }
        }
    }
    
    func onWordGenHistoryTap() {
        navigation.wordGenTabRouter.push(.historyList)
    }
    
    func onWordGenSettingsTap() {
        navigation.wordGenTabRouter.push(.settingsWordGen)
    }
    
    func onWordGenReportOffensive() {
        navigation.presentedEmail = .offensive(word: currentWord)
    }
    
    func onWordGenReportLowQuality() {
        navigation.presentedEmail = .poorQuality(word: currentWord)
    }
}
