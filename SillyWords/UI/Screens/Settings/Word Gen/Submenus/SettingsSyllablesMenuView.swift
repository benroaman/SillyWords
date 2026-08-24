//
//  SettingsSyllablesMenuView.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/14/26.
//

import SwiftUI

struct SettingsSyllablesMenuView<S: SyllableSettings>: View {
    @State var settings: S
    
    var body: some View {
        List {
            SettingInputNumberPicker(setting: .minSyllables,
                                     options: settings.minimumSyllableOptions,
                                     value: $settings.minSyllables)
            SettingInputNumberPicker(setting: .maxSyllables,
                                     options: settings.maximumSyllableOptions,
                                     value: $settings.maxSyllables)
        }
        .tint(Style.Color.wordGenerateTheme)
        .navigationTitle("Syllables")
    }
}

protocol SyllableSettings: AnyObject, Observable {
    var minSyllables: Int { get set }
    var maxSyllables: Int { get set }
    var minimumSyllableOptions: [Int] { get }
    var maximumSyllableOptions: [Int] { get }
}

#Preview {
    SettingsSyllablesMenuView(settings: SettingsManager())
}

