//
//  WordDetailView.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/28/26.
//

import SwiftUI

#warning("TODO: WIP")
struct WordDetailView<M : WordDetailViewModel>: View {
    @State var model: M
    
    var body: some View {
        ScrollView {
            HStack {
                VStack(alignment: .leading) {
                    Text("created \(model.dateAdded.formatted(date: .long, time: .shortened))")
                    Text(model.sentence.text)
                    Text(model.sentence.attribution)
                }
                Spacer()
            }
            .padding()
            WordSettingsView(model: WordSettingsViewModelPreview())
        }
        .frame(maxWidth: .infinity)
        .navigationTitle(model.text)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    model.onFavoriteTap()
                }, label: {
                    Image(model.isFavorite ? Theme.Favorite.iconOn : Theme.Favorite.iconOff)
                        .animation(.bouncy, value: model.isFavorite)
                })
                .tint(Theme.Favorite.color)
            }
        }
        .errorAlert("Failed to toggle favorite", error: $model.toggleFavoriteError)
        .errorAlert("Failed to delete \"\(model.text)\"", error: $model.deleteWordError)
    }
}

#Preview {
    NavigationStack {
        WordDetailView(model: WordDetailViewModelPreview())
    }
}

protocol WordDetailViewModel: AnyObject, Observable {
    var text: String { get }
    var actualSyllables: Int { get }
    var dateAdded: Date { get }
    var isFavorite: Bool { get }
    var sentence: SentenceGenerator.Sentence { get }
    
    var deleteConfirmationMessage: String { get }
    var isPresentingDeleteConfirmation: Bool { get set }
    
    var toggleFavoriteError: Error? { get set }
    var deleteWordError: Error? { get set }
    
    func onFavoriteTap()
    func onNewSentenceTap()
    func onDeleteTap()
    func onConfirmDeleteTap()
}

@Observable class WordDetailViewModelPreview: WordDetailViewModel {
    let text = "scronti"
    let actualSyllables = 2
    let dateAdded: Date = .init()
    private(set) var isFavorite: Bool = false
    private(set) var sentence: SentenceGenerator.Sentence = SentenceGenerator.useItInASentence("scronti")
    
    var deleteConfirmationMessage: String { "Are you sure you want to delete \"\(text)\"?" }
    var isPresentingDeleteConfirmation: Bool = false
    
    var toggleFavoriteError: Error?
    var deleteWordError: Error?
    
    func onFavoriteTap() {
        if Bool.random() {
            isFavorite.toggle()
        } else {
            toggleFavoriteError = DatabaseError.mockFailedInitializer
        }
    }
    
    func onNewSentenceTap() { sentence = SentenceGenerator.useItInASentence(text) }
    func onDeleteTap() { isPresentingDeleteConfirmation = true }
    func onConfirmDeleteTap() {
        if Bool.random() {
            deleteWordError = DatabaseError.mockMisc
        }
    }
}

@Observable class WordDetailviewModelProd: WordDetailViewModel {
    private let word: Word
    private let favorites: FavoritesManager
    
    init(word: Word, favorites: FavoritesManager) {
        self.word = word
        self.favorites = favorites
        self.isFavorite = word.isFavorite
        self.sentence = SentenceGenerator.useItInASentence(word.text ?? "")
    }
    
    var text: String { word.text ?? "data_missing" }
    var actualSyllables: Int { Int(word.actualSyllables) }
    var dateAdded: Date { word.dateAdded ?? .init() }
    private(set) var isFavorite: Bool
    var sentence: SentenceGenerator.Sentence
    
    var deleteConfirmationMessage: String { "Are you sure you want to delete \"\(text)\"?" }
    var isPresentingDeleteConfirmation: Bool = false
    
    var toggleFavoriteError: Error?
    var deleteWordError: Error?
    
    func onFavoriteTap() {
        Task {
            do {
                try await favorites.toggleFavorite(word, context: .favoriteDetail)
                await MainActor.run {
                    self.isFavorite.toggle()
                }
            } catch {
                await MainActor.run {
                    self.toggleFavoriteError = error
                }
            }
        }
    }
    
    func onNewSentenceTap() {
        sentence = SentenceGenerator.useItInASentence(text)
    }
    
    func onDeleteTap() {
        isPresentingDeleteConfirmation = true
    }
    
    func onConfirmDeleteTap() {
        Task {
            do {
                #warning("TODO:")
            } catch {
                await MainActor.run {
                    self.deleteWordError = error
                }
            }
        }
    }
}
