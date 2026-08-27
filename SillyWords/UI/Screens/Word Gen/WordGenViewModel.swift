//
//  WordGenViewModel.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/20/26.
//

import Foundation
import SwiftUI

protocol WordGenViewModel: AnyObject, Observable {
    var currentWord: String { get }
    var currentWordSentence: SentenceGenerator.Sentence { get }
    var isCurrentWordFavorite: Bool { get }
    var toggleFavoriteFailure: String? { get set }
    var wordTransitionStyle: WordTransitionStyle { get }
    var showSentence: Bool { get }
    var showSentenceAttribution: Bool { get }
    var failedToSaveWordErrorMessage: String? { get }
    var isPresentingfailedToSaveWordMessage: Binding<Bool> { get }
    
    func onWordGenNewWordTap()
    func onWordGenNewSentenceTap()
    func onWordGenFavoriteTap()
    func onWordGenHistoryTap()
    func onWordGenSettingsTap()
    func onWordGenReportOffensive()
    func onWordGenReportLowQuality()
}

@Observable class WordGenViewModelPreview: WordGenViewModel {
    var currentWord = "brismucect"
    private(set) var currentWordSentence = SentenceGenerator.useItInASentence("brismucect")
    private let pool = ["brismucect", "glunde", "okay", "words", "aja", "coolbeans", "djbouti", "blackalicious", "radio", "parliament"]
    private(set) var isCurrentWordFavorite: Bool = false
    var toggleFavoriteFailure: String?
    let wordTransitionStyle: WordTransitionStyle = .splode
    let showSentence: Bool = true
    let showSentenceAttribution: Bool = true
    var failedToSaveWordErrorMessage: String?
    var isPresentingfailedToSaveWordMessage: Binding<Bool> {
        .init(get: {
            self.failedToSaveWordErrorMessage != nil
        }, set: { isPresented in
            if !isPresented { self.failedToSaveWordErrorMessage = nil }
        })
    }
    
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

@Observable class WordGenViewModelProd: WordGenViewModel {
    private let generator: GenerationManager
    private let favorites: FavoritesManager
    private let navigation: any WordGenTabNavigation
    private let settings: SettingsManager
    
    @MainActor var toggleFavoriteFailure: String?
    
    var currentWord: String { generator.currentWordText }
    private(set) var currentWordSentence: SentenceGenerator.Sentence
    var isCurrentWordFavorite: Bool { favorites.isFavorite(currentWord) }
    var wordTransitionStyle: WordTransitionStyle {
        settings.wordGenCurrentWordTransitionStyle
    }
    var showSentence: Bool { settings.showSentenceOnMainWordGen }
    var showSentenceAttribution: Bool { settings.includeSentenceAttribution }
    var failedToSaveWordErrorMessage: String?
    var isPresentingfailedToSaveWordMessage: Binding<Bool> {
        .init(get: {
            self.failedToSaveWordErrorMessage != nil
        }, set: { isPresented in
            if !isPresented { self.failedToSaveWordErrorMessage = nil }
        })
    }
    
    init(generator: GenerationManager, favorites: FavoritesManager, navigation: any WordGenTabNavigation, settings: SettingsManager) {
        self.generator = generator
        self.favorites = favorites
        self.navigation = navigation
        self.settings = settings
        self.currentWordSentence = SentenceGenerator.useItInASentence(generator.currentWordText)
    }
    
    func onWordGenNewWordTap() {
        Telemetry.trackCreateWord()
        do {
            try generator.makeWord()
        } catch {
            Task { @MainActor in
                if let message = (error as? DatabaseError)?.userMessage {
                    self.failedToSaveWordErrorMessage = "Failed to remove favorites \(message)."
                } else {
                    self.failedToSaveWordErrorMessage = "Failed to remove favorite."
                }
            }
        }
        currentWordSentence = SentenceGenerator.useItInASentence(currentWord)
    }
    
    func onWordGenNewSentenceTap() {
        currentWordSentence = SentenceGenerator.useItInASentence(currentWord)
        Telemetry.trackCreateSentence()
    }
    
    func onWordGenFavoriteTap() {
        Task {
            do {
                try await favorites.toggleFavorite(generator.currentWord, context: .wordGenMain)
            } catch {
                await MainActor.run {
                    if let message = (error as? DatabaseError)?.userMessage {
                        self.toggleFavoriteFailure = "Failed to update favorites: \(message)."
                    } else {
                        self.toggleFavoriteFailure = "Failed to update favorites."
                    }
                }            }
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
