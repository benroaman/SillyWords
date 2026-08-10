//
//  SettingsView.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/3/26.
//

import SwiftUI

struct SettingsMainMenuView<M: SettingsMainMenuViewModel>: View {
    // MARK: Instance Variables - State
//    @State var settings: SettingsManager
    @State var model: M
    
    // MARK: Body
    var body: some View {
        List {
            ForEach(SettingsMainMenuOption.allCases, id: \.self) { option in
                makeSettingsOption(option, action: {
                    model.onSettingsMainMenuTabOptionSelected(option)
                })
            }
        }
        .sendEmail($model.settingsMainMenuPresentedEmail)
//        NavigationStack {
//            
//            List {
//                Section("Syllable Count") {
//                    makeNumberPicker(.minSyllables,
//                                     options: settings.minimumSyllableOptions,
//                                     value: $settings.minSyllables)
//                    makeNumberPicker(.maxSyllables,
//                                     options: settings.maximumSyllableOptions,
//                                     value: $settings.maxSyllables)
//                }
//                Section("Vowels") {
//                    makeSwitchPicker(.allowVowelCombos,
//                                     value: $settings.allowVowelCombos)
//                    makeSwitchPicker(.allowYAsVowel,
//                                     value: $settings.allowsYAsVowel)
//                }
//                Section("Consonants") {
//                    makeSwitchPicker(.soloQs, value: $settings.soloQs)
//                    
//                    makeSwitchPicker(.initialDigraphs, value: $settings.initialDigraphs)
//                    makeSwitchPicker(.initialDigraphBlends, value: $settings.initialDigraphBlends)
//                    makeSwitchPicker(.initial2LetterBlends, value: $settings.initial2LetterBlends)
//                    makeSwitchPicker(.initial3LetterBlends, value: $settings.initial3LetterBlends)
//                    
//                    makeSwitchPicker(.middleDigraphs, value: $settings.middleDigraphs)
//                    makeSwitchPicker(.middleDigraphBlends, value: $settings.middleDigraphBlends)
//                    makeSwitchPicker(.middle2LetterBlends, value: $settings.middle2LetterBlends)
//                    makeSwitchPicker(.middle3LetterBlends, value: $settings.middle3LetterBlends)
//                    
//                    makeSwitchPicker(.finalDigraphs, value: $settings.finalDigraphs)
//                    makeSwitchPicker(.finalDigraphBlends, value: $settings.finalDigraphBlends)
//                    makeSwitchPicker(.final2LetterBlends, value: $settings.final2LetterBlends)
//                    makeSwitchPicker(.final3LetterBlends, value: $settings.final3LetterBlends)
//                }
//                Section("Misc") {
//                    makeSwitchPicker(.filterSortOfBadWords,
//                                     value: $settings.filterSortOfBadWords)
//                }
//            }
//            .tint(.green)
//            .scrollEdgeEffectStyle(.soft, for: .top)
//        }
    }
    
    @ViewBuilder func makeSettingsOption(_ option: SettingsMainMenuOption, action: @escaping () -> Void) -> some View {
        Button(action: action, label: {
            SettingsSimpleMenuRow(option: option)
        })
    }
}

// MARK: Private API - View Builders
private extension SettingsMainMenuView {
    @ViewBuilder func makeNumberPicker(_ setting: SettingInput, options: [Int], value: Binding<Int>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Picker(setting.title, selection: value) {
                ForEach(options, id: \.self) { option in
                    Text("\(option)").tag(option)
                }
            }
            .font(.headline)
            if let description = setting.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    @ViewBuilder func makeSwitchPicker(_ setting: SettingInput, value: Binding<Bool>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle(setting.title, isOn: value)
                .font(.headline)
            if let description = setting.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            value.wrappedValue.toggle()
        }
    }
}

// MARK: Previews
#Preview {
    PreviewWrapper()
}

fileprivate struct PreviewWrapper: View {
    @State private var settings = SettingsManager()
    
    var body: some View {
        SettingsMainMenuView(model: MockSettingsMainMenuViewModel())
    }
}

@Observable
fileprivate class MockSettingsMainMenuViewModel: SettingsMainMenuViewModel {
    func onSettingsMainMenuTabOptionSelected(_ option: SettingsMainMenuOption) { print("\(option.title) TAP") }
    var settingsMainMenuPresentedEmail: Email?
}

enum SettingsMainMenuOption: SettingsSimpleMenuRowOption, CaseIterable {
    case wordGeneration
    case favorites
    case feedback
    
    var title: String {
        switch self {
        case .wordGeneration: "Word Generation"
        case .favorites: "Favorites"
        case .feedback: "Feedback"
        }
    }
    
    var icon: SFSymbol {
        switch self {
        case .wordGeneration: .pencilAndScribble
        case .favorites: .heart
        case .feedback: .envelope
        }
    }
    
    var iconColor: Color {
        switch self {
        case .wordGeneration: Style.Color.wordGenerateTheme
        case .favorites: Style.Color.favoriteTheme
        case .feedback: Style.Color.feedbackTheme
        }
    }

    var accessory: SFSymbol? {
        switch self {
        case .wordGeneration: .chevronRight
        case .favorites: .chevronRight
        case .feedback: .arrowUpRight
        }
    }
}

enum SettingsRoute: Hashable {
    case wordGeneration, favorites, syllables, consonants, vowels
}

protocol SettingsMainMenuViewModel: Observable {
    func onSettingsMainMenuTabOptionSelected(_ option: SettingsMainMenuOption)
    var settingsMainMenuPresentedEmail: Email? { get set }
}
