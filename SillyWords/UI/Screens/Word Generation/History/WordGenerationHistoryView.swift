//
//  WordGenerationHistoryView.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/20/26.
//

import SwiftUI

struct WordGenerationHistoryView<M: WordGenerationHistoryViewModel>: View {
    @State var model: M
    
    var body: some View {
        List {
            ForEach(model.words, content: { word in
                HStack {
                    Text(word.word)
                    Spacer()
                    Button(action: {
                        model.toggleFavorite(word: word)
                    }, label: {
                        Image(model.isWordFavorite(word) ? .heartFill : .heart)
                            .tint(Style.Color.favoriteTheme)
                            .animation(.linear(duration: 0.35), value: model.isWordFavorite(word))
                    })
                    .sensoryFeedback(.impact(weight: .light), trigger: model.isWordFavorite(word))
                }
                .swipeActions(allowsFullSwipe: false) {
                    makeRowSwipeActions(for: word)
                }
            })
        }
        .navigationTitle("Generated Word History")
        .alert(
            "Favorite Error",
            isPresented: Binding(
                get: { model.toggleFavoriteFailure != nil },
                set: { if !$0 { model.toggleFavoriteFailure = nil } }
            ),
            presenting: model.toggleFavoriteFailure
        ) { _ in
            Button("Okay") { model.toggleFavoriteFailure = nil }
        } message: { message in
            Text(message)
        }
    }
    
    @ViewBuilder func makeRowSwipeActions(for word: GeneratedWord) -> some View {
        Menu(.exclamationmarkBubble) {
            Button(action: {
                model.reportWordAsLowQuality(word)
            }, label: {
                Label(title: "Poor Quality", symbol: .envelope)
            })
            Button(action: {
                model.reportOffensiveWord(word)
            }, label: {
                Label(title: "Offensive", symbol: .envelope)
            })
            .tint(Style.Color.offensiveTheme)
        }
        .tint(Style.Color.reportTheme)
    }
}

#Preview {
    WordGenerationHistoryView(model: WordGenerationHistoryViewModelPreview())
}

protocol WordGenerationHistoryViewModel: AnyObject, Observable {
    var words: [GeneratedWord] { get }
    var toggleFavoriteFailure: String? { get set }
    
    func isWordFavorite(_ word: GeneratedWord) -> Bool
    func reportOffensiveWord(_ word: GeneratedWord)
    func reportWordAsLowQuality(_ word: GeneratedWord)
    func toggleFavorite(word: GeneratedWord)
}

@Observable class WordGenerationHistoryViewModelPreview: WordGenerationHistoryViewModel {
    let words: [GeneratedWord] = [.mock1, .mock2, .mock3, .mock4, .mock5, .mock6]
    var toggleFavoriteFailure: String?
    private var favorites: Set<String> = []
    
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

@Observable class WordGenerationHistoryViewModelProd: WordGenerationHistoryViewModel {
    private let generator: GenerationManager
    private let favorites: FavoritesManager
    private let navigation: any WordGenerationTabNavigation
    
    init(generator: GenerationManager, favorites: FavoritesManager, navigation: any WordGenerationTabNavigation) {
        self.generator = generator
        self.favorites = favorites
        self.navigation = navigation
    }
    
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
                try await favorites.toggleFavorite(word)
            } catch {
                toggleFavoriteFailure = "Failed to update favorites: \((error as? DatabaseError)?.description ?? error.localizedDescription)"
            }
        }
    }
}
