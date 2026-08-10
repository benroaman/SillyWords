//
//  SettingsSyllablesMenuView.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/14/26.
//

import SwiftUI

struct SettingsSyllablesMenuView: View {
    @State var settings: SettingsManager
    
    var body: some View {
        List {
            makeNumberPicker(.minSyllables,
                             options: settings.minimumSyllableOptions,
                             value: $settings.minSyllables)
            makeNumberPicker(.maxSyllables,
                             options: settings.maximumSyllableOptions,
                             value: $settings.maxSyllables)
        }
        .tint(Style.Color.wordGenerateTheme)
        .navigationTitle("Syllables")
    }
    
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
}

#Preview {
    SettingsSyllablesMenuView(settings: SettingsManager())
}

