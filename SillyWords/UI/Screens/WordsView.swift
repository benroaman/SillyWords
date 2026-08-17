//
//  WordsView.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/3/26.
//

import SwiftUI
import MessageUI
import BRWordGeneration

struct WordsView: View {
    // MARK: Instance Variables - State
    @State var generator: GenerationManager
    @State var favorites: FavoritesManager
    @State var presentedEmail: Email?
    
    // MARK: Initializers
    init(generator: GenerationManager, favorites: FavoritesManager) {
        self.generator = generator
        self.favorites = favorites
    }
    
    // MARK: Body
    var body: some View {
        VStack {
            ZStack {
                Text(generator.currentWordText)
                    .animation(.easeIn(duration: 0.75), value: generator.currentWordText)
                    .font(.system(size: 60, weight: .medium))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: .infinity)
                Text("REF")
                    .font(.system(size: 60, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .fixedSize(horizontal: true, vertical: true)
                    .foregroundStyle(.clear)
            }
            Spacer()
                .frame(height: 40)
            HStack(spacing: 0) {
                Spacer()
                Button(action: doCreateNewWord, label: {
                    Image(.pencilAndScribble)
                })
                .tint(.green)
                .font(.title)
                .fontWeight(.medium)
                Spacer()
                Button(action: doToggleFavorite, label: {
                    Image(systemName: favorites.isFavorite(generator.currentWordText) ? "heart.fill" : "heart")
                })
                .tint(.purple)
                .font(.title)
                .fontWeight(.medium)
                .animation(.easeIn(duration: 0.75), value: generator.currentWordText)
                Spacer()
                Menu("", systemImage: "exclamationmark.bubble") {
                    Button(action: doReportCurrentWordOffensive, label: {
                        Label("Offensive", systemImage: "envelope.fill")
                    })
                    .tint(.red)
                    Button(action: doReportCurrentWordLowQuality, label: {
                        Label("Poor Quality", systemImage: "envelope.fill")
                    })
                }
                .tint(.orange)
                .font(.title)
                .fontWeight(.medium)
                Spacer()
            }
        }
        .padding()
        .sendEmail($presentedEmail)
    }
}

// MARK: Private API - User Interactions
private extension WordsView {
    func doReportCurrentWordOffensive() {
        presentedEmail = .offensive(word: generator.currentWordText)
    }
    
    func doReportCurrentWordLowQuality() {
        presentedEmail = .poorQuality(word: generator.currentWordText)
    }
    
    func doToggleFavorite() {
        guard let word = generator.words.first else { return }
        
        Task {
            do {
                try await favorites.toggleFavorite(word)
            } catch {
                #warning("TODO:")
            }
        }
    }
    
    func doCreateNewWord() {
        generator.makeWord()
    }
}

// MARK: Previews
#Preview {
    PreviewWrapper()
}

fileprivate struct PreviewWrapper: View {
    @State private var state = AppState()
    
    var body: some View {
        WordsView(generator: state.generator, favorites: state.favorites)
    }
}
