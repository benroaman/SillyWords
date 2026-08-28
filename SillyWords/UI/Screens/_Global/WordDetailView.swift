//
//  WordDetailView.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/28/26.
//

import SwiftUI

struct WordDetailView<M : WordDetailViewModel>: View {
    let model: M
    
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
                    Image(model.isFavorite ? Style.Theme.Icon.favoriteYes : Style.Theme.Icon.favoriteNo)
                        .animation(.bouncy, value: model.isFavorite)
                })
                .tint(Style.Theme.Color.favorite)
            }
        }
        .alert(model.deleteWordFailure ?? "Delete Failed", isPresented: model.isPresentingDeleteWordFailure, actions: {
            Button(action: { }, label: {
                Text("Okay")
            })
        })
        .alert(model.toggleFavoriteFailure ?? "Toggle Favorite Failed", isPresented: model.isPresentingToggleFavoriteFailure, actions: {
            Button(action: { }, label: {
                Text("Okay")
            })
        })
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
    
    var toggleFavoriteFailure: String? { get }
    var isPresentingToggleFavoriteFailure: Binding<Bool> { get }
    var deleteWordFailure: String? { get }
    var isPresentingDeleteWordFailure: Binding<Bool> { get }
    
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
    
    private(set) var toggleFavoriteFailure: String?
    var isPresentingToggleFavoriteFailure: Binding<Bool> {
        .init(get: {
            self.toggleFavoriteFailure != nil
        }, set: { isPresented in
            if !isPresented { self.toggleFavoriteFailure = nil }
        })
    }
    
    private(set) var deleteWordFailure: String?
    var isPresentingDeleteWordFailure: Binding<Bool> {
        .init(get: {
            self.deleteWordFailure != nil
        }, set: { isPresented in
            if !isPresented { self.deleteWordFailure = nil }
        })
    }
    
    func onFavoriteTap() {
        if Bool.random() {
            isFavorite.toggle()
        } else {
            toggleFavoriteFailure = "Favorite Error"
        }
    }
    
    func onNewSentenceTap() { sentence = SentenceGenerator.useItInASentence(text) }
    func onDeleteTap() { isPresentingDeleteConfirmation = true }
    func onConfirmDeleteTap() {
        if Bool.random() {
            deleteWordFailure = "Delete Error"
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
    
    private(set) var toggleFavoriteFailure: String?
    var isPresentingToggleFavoriteFailure: Binding<Bool> {
        .init(get: {
            self.toggleFavoriteFailure != nil
        }, set: { isPresented in
            if !isPresented { self.toggleFavoriteFailure = nil }
        })
    }
    
    private(set) var deleteWordFailure: String?
    var isPresentingDeleteWordFailure: Binding<Bool> {
        .init(get: {
            self.deleteWordFailure != nil
        }, set: { isPresented in
            if !isPresented { self.deleteWordFailure = nil }
        })
    }
    
    func onFavoriteTap() {
        Task {
            do {
                try await favorites.toggleFavorite(word, context: .favoriteDetail)
                await MainActor.run {
                    self.isFavorite.toggle()
                }
            } catch {
                await MainActor.run {
                    if let userMessage = (error as? DatabaseError)?.userMessage {
                        self.toggleFavoriteFailure = "Failed to toggle favorite: \(userMessage)"
                    } else {
                        self.toggleFavoriteFailure = "Failed to toggle favorite"
                    }
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
                    if let userMessage = (error as? DatabaseError)?.userMessage {
                        self.deleteWordFailure = "Failed to toggle favorite: \(userMessage)"
                    } else {
                        self.deleteWordFailure = "Failed to toggle favorite"
                    }
                }
            }
        }
    }
}
