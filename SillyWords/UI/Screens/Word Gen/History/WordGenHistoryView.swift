//
//  WordGenHistoryView.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/20/26.
//

import SwiftUI

#warning("TODO: Clean up this view")
struct WordGenHistoryView<M: WordGenHistoryViewModel>: View {
    @FetchRequest private var words: FetchedResults<Word>
    @State var model: M
    
    init(model: M) {
        self.model = model
        self._words = FetchRequest<Word>(
            sortDescriptors: [SortDescriptor(\Word.dateAdded, order: .reverse)],
            animation: .default
        )
    }
    
    var body: some View {
        List {
            ForEach(words, id: \.self) { word in
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        if let text = word.text {
                            Text(text)
                                .font(.headline)
                        }
                        if let date = word.dateAdded {
                            Text(date.formatted(.dateTime))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    Button(action: {
                        model.toggleFavorite(word: word)
                    }, label: {
                        Image(word.isFavorite ? .heartFill : .heart)
                            .tint(Style.Theme.Color.favorite)
                            .animation(.linear(duration: 0.35), value: word.isFavorite)
                    })
                    .sensoryFeedback(.impact(weight: .light), trigger: word.isFavorite)
                }
                .swipeActions(allowsFullSwipe: false) {
                    makeRowSwipeActions(for: word)
                }
            }
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
    
    @ViewBuilder func makeRowSwipeActions(for word: Word) -> some View {
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
            .tint(Style.Theme.Color.offensive)
        }
        .tint(Style.Theme.Color.report)
        Button(action: {
            #warning("TODO:")
        }, label: {
            Image(.space)
        })
        .tint(Style.Theme.Color.sentenceGenerate)
    }
}

#Preview {
    #warning("TODO: give this data to render")
    WordGenHistoryView(model: WordGenHistoryViewModelPreview())
}
