//
//  WordGenView.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/3/26.
//

import SwiftUI
import MessageUI
import BRWordGeneration

struct WordGenView<M: WordGenViewModel>: View {
    // MARK: Instance Variables - State
    @State var model: M
    @State private var mainContentHeight: CGFloat = 160
    @State private var sentenceHeight: CGFloat = 100
    
    private var sentenceStackFillHeight: CGFloat { mainContentHeight + sentenceHeight }
    
    var body: some View {
        ZStack {
            VStack {
                currentWordLabel
                Spacer()
                    .frame(height: 40)
                mainButtonStack
            }
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear { self.mainContentHeight = geometry.size.height }
                        .onChange(of: geometry.size.height) { _, new in self.mainContentHeight = new }
                }
            )
            if model.showSentence {
                sentenceView
            }
        }
        .padding()
        .errorAlert("Failed to create a record of \"\(model.currentWord)\"", error: $model.createWordRecordError)
        .errorAlert("Failed to toggle favorite", error: $model.toggleFavoriteError)
    }
}

// MARK: Private API - View Builders
private extension WordGenView {
    @ViewBuilder var currentWordLabel: some View {
            switch model.wordTransitionStyle {
            case .crossfade:
                ZStack {
                    Text(model.currentWord)
                        .animation(.easeIn(duration: 0.75), value: model.currentWord)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .currentWordLabel()
                    Text("REF")
                        .fixedSize(horizontal: true, vertical: true)
                        .foregroundStyle(.clear)
                        .currentWordLabel()
                }
            case .splode:
                ExplodingTextView(text: model.currentWord, font: .systemFont(ofSize: 60, weight: .medium))
            }
    }
    
    @ViewBuilder var mainButtonStack: some View {
        HStack(spacing: 0) {
            Spacer()
            generateWordButton
            Spacer()
            historyButton
            Spacer()
            toggleFavoriteButton
            Spacer()
            settingsButton
            Spacer()
            reportButton
            Spacer()
        }
    }
    
    @ViewBuilder var sentenceView: some View {
        let text = model.currentWordSentence.text
        let attribution = model.currentWordSentence.attribution
        let showAttribution = model.showSentenceAttribution
        ShareLink(item: "\"\(text)\"" + (showAttribution ? "\n- \(attribution)" : "")) {
            VStack(alignment: .center, spacing: 60) {
                Spacer()
                    .frame(height: sentenceStackFillHeight)
                    .background(.orange)
                HStack {
                    VStack(alignment: .leading) {
                        Text("\"\(text)\"")
                        if showAttribution {
                            Text("- \(attribution)")
                                .italic()
                                .foregroundStyle(.secondary)
                        }
                    }
                    .font(.callout)
                    Spacer()
                        .frame(width: 8)
                    Button(action: {
                        withAnimation {
                            model.onWordGenNewSentenceTap()
                        }
                    }, label: {
                        Image(Theme.SentenceGen.refreshIcon)
                    })
                    .tint(Theme.SentenceGen.color)
                }
                .animation(.easeInOut(duration: 0.75), value: model.currentWordSentence)
                .background(
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear { self.sentenceHeight = geometry.size.height }
                            .onChange(of: geometry.size.height) { _, new in self.sentenceHeight = new }
                    }
                )
            }
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder var generateWordButton: some View {
        Button(action: {
            withAnimation {
                model.onWordGenNewWordTap()
            }
        }, label: {
            Image(Theme.WordGen.icon)
        })
        .tint(Theme.WordGen.color)
        .wordViewButton()
        .accessibilityLabel("Generate New Word")
    }
    
    @ViewBuilder var toggleFavoriteButton: some View {
        Button(action: model.onWordGenFavoriteTap, label: {
            Image(model.isCurrentWordFavorite ? Theme.Favorite.iconOn : Theme.Favorite.iconOff)
        })
        .tint(Theme.Favorite.color)
        .wordViewButton()
        .animation(.easeIn(duration: 0.75), value: model.currentWord)
        .sensoryFeedback(.impact(weight: .light), trigger: model.isCurrentWordFavorite)
        .accessibilityLabel("\(model.isCurrentWordFavorite ? "Remove" : "Add") \(model.currentWord) as Favorite")
    }
    
    @ViewBuilder var historyButton: some View {
        Button(action: {
            model.onWordGenHistoryTap()
        }, label: {
            Image(Theme.History.icon)
        })
        .tint(Theme.History.color)
        .wordViewButton()
        .accessibilityLabel("Open History")
    }
    
    @ViewBuilder var settingsButton: some View {
        Button(action: {
            model.onWordGenSettingsTap()
        }, label: {
            Image(Theme.Settings.icon)
        })
        .tint(Theme.Settings.color)
        .wordViewButton()
        .accessibilityLabel("Open Word Generation Settings")
    }
    
    @ViewBuilder var reportButton: some View {
        Menu(Theme.Report.icon) {
            Button(action: model.onWordGenReportOffensive, label: {
                Label(title: "Offensive", symbol: Theme.Contact.icon)
            })
            .tint(Theme.Offensive.color)
            Button(action: model.onWordGenReportLowQuality, label: {
                Label(title: "Poor Quality", symbol: Theme.Contact.icon)
            })
            .tint(Theme.PoorQuality.color)
        }
        .tint(Theme.Report.color)
        .wordViewButton()
        .accessibilityLabel("Report \(model.currentWord)")
    }
}

// MARK: Previews
#Preview {
    WordGenView(model: WordGenViewModelPreview())
}

#warning("TODO: Figure out a better place to put these?")
// MARK: Convenience View Modifiers
/**
 Applies the shared styling for primary buttons in WordGenView
 */
fileprivate struct WordViewButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.medium)
    }
}

/**
 Applies the shared styling for primary buttons in WordGenView
 */
fileprivate extension View {
    func wordViewButton() -> some View {
        modifier(WordViewButton())
    }
}

/**
 Applies the frame-affecting styling for the current word label in WordGenView
 */
fileprivate struct CurrentWordLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 60, weight: .medium))
            .frame(maxWidth: .infinity)
    }
}

/**
 Applies the frame-affecting styling for the current word label in WordGenView
 */
fileprivate extension View {
    func currentWordLabel() -> some View {
        modifier(CurrentWordLabel())
    }
}
