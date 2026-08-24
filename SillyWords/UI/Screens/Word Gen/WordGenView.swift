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
    
    // MARK: Body
    var body: some View {
        VStack {
            currentWordLabel
            Spacer()
                .frame(height: 40)
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
//            Spacer()
//                .frame(height: 40)
//            Text(model.currentWordSentence)
//                .font(.callout)
//                .multilineTextAlignment(.center)
//                .animation(.easeInOut(duration: 0.75), value: model.currentWordSentence)
        }
        .padding()
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
    
    @ViewBuilder var generateWordButton: some View {
        Button(action: model.onWordGenNewWordTap, label: {
            Image(.pencilAndScribble)
        })
        .tint(Style.Color.wordGenerateTheme)
        .wordViewButton()
        .accessibilityLabel("Generate New Word")
    }
    
    @ViewBuilder var toggleFavoriteButton: some View {
        Button(action: model.onWordGenFavoriteTap, label: {
            Image(systemName: model.isCurrentWordFavorite ? "heart.fill" : "heart")
        })
        .tint(Style.Color.favoriteTheme)
        .wordViewButton()
        .animation(.easeIn(duration: 0.75), value: model.currentWord)
        .sensoryFeedback(.impact(weight: .light), trigger: model.isCurrentWordFavorite)
        .accessibilityLabel("\(model.isCurrentWordFavorite ? "Remove" : "Add") \(model.currentWord) as Favorite")
    }
    
    @ViewBuilder var historyButton: some View {
        Button(action: {
            model.onWordGenHistoryTap()
        }, label: {
            Image(.clock)
        })
        .tint(Style.Color.historyTheme)
        .wordViewButton()
        .accessibilityLabel("Open History")
    }
    
    @ViewBuilder var settingsButton: some View {
        Button(action: {
            model.onWordGenSettingsTap()
        }, label: {
            Image(.gearshape)
        })
        .tint(Style.Color.mainTheme)
        .wordViewButton()
        .accessibilityLabel("Open Word Generation Settings")
    }
    
    @ViewBuilder var reportButton: some View {
        Menu("", systemImage: "exclamationmark.bubble") {
            Button(action: model.onWordGenReportOffensive, label: {
                Label("Offensive", systemImage: "envelope.fill")
            })
            .tint(Style.Color.offensiveTheme)
            Button(action: model.onWordGenReportLowQuality, label: {
                Label("Poor Quality", systemImage: "envelope.fill")
            })
        }
        .tint(Style.Color.reportTheme)
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
