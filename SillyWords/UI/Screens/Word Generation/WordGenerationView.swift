//
//  WordGenerationView.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/3/26.
//

import SwiftUI
import MessageUI
import BRWordGeneration

struct WordGenerationView<M: WordGenerationViewModel>: View {
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
                toggleFavoriteButton
                Spacer()
                historyButton
                Spacer()
                settingsButton
                Spacer()
                reportButton
                Spacer()
            }
        }
        .padding()
    }
}

// MARK: Private API - View Builders
private extension WordGenerationView {
    @ViewBuilder var currentWordLabel: some View {
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
    }
    
    @ViewBuilder var generateWordButton: some View {
        Button(action: model.onWordGenerationNewWordTap, label: {
            Image(.pencilAndScribble)
        })
        .tint(Style.Color.wordGenerateTheme)
        .wordViewButton()
        .accessibilityLabel("Generate New Word")
    }
    
    @ViewBuilder var toggleFavoriteButton: some View {
        Button(action: model.onWordGenerationFavoriteTap, label: {
            Image(systemName: model.isCurrentWordFavorite ? "heart.fill" : "heart")
        })
        .tint(Style.Color.favoriteTheme)
        .wordViewButton()
        .animation(.easeIn(duration: 0.75), value: model.currentWord)
        .accessibilityLabel("\(model.isCurrentWordFavorite ? "Remove" : "Add") \(model.currentWord) as Favorite")
    }
    
    @ViewBuilder var historyButton: some View {
        Button(action: {
            model.onWordGenerationHistoryTap()
        }, label: {
            Image(.clock)
        })
        .tint(Style.Color.historyTheme)
        .wordViewButton()
        .accessibilityLabel("Open History")
    }
    
    @ViewBuilder var settingsButton: some View {
        Button(action: {
            model.onWordGenerationSettingsTap()
        }, label: {
            Image(.gearshape)
        })
        .tint(Style.Color.mainTheme)
        .wordViewButton()
        .accessibilityLabel("Open Word Generation Settings")
    }
    
    @ViewBuilder var reportButton: some View {
        Menu("", systemImage: "exclamationmark.bubble") {
            Button(action: model.onWordGenerationReportOffensive, label: {
                Label("Offensive", systemImage: "envelope.fill")
            })
            .tint(Style.Color.offensiveTheme)
            Button(action: model.onWordGenerationReportLowQuality, label: {
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
    WordGenerationView(model: WordGenerationViewModelMock())
}

// MARK: Convenience View Modifiers
/**
 Applies the shared styling for primary buttons in WordGenerationView
 */
struct WordViewButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.medium)
    }
}

/**
 Applies the shared styling for primary buttons in WordGenerationView
 */
extension View {
    func wordViewButton() -> some View {
        modifier(WordViewButton())
    }
}

/**
 Applies the frame-affecting styling for the current word label in WordGenerationView
 */
struct CurrentWordLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 60, weight: .medium))
            .frame(maxWidth: .infinity)
    }
}

/**
 Applies the frame-affecting styling for the current word label in WordGenerationView
 */
extension View {
    func currentWordLabel() -> some View {
        modifier(CurrentWordLabel())
    }
}
