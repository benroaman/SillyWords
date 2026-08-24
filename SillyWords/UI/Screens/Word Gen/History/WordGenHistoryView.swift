//
//  WordGenHistoryView.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/20/26.
//

import SwiftUI

#warning("TODO: Clean up this view")
struct WordGenHistoryView<M: WordGenHistoryViewModel>: View {
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
    WordGenHistoryView(model: WordGenHistoryViewModelPreview())
}
