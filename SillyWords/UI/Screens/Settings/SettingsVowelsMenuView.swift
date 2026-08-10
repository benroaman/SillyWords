//
//  SettingsVowelsMenuView.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/14/26.
//

import SwiftUI

struct SettingsVowelsMenuView: View {
    @State var settings: SettingsManager
    
    var body: some View {
        List {
            makeSwitchPicker(.allowVowelCombos,
                             value: $settings.allowVowelCombos)
            makeSwitchPicker(.allowYAsVowel,
                             value: $settings.allowsYAsVowel)
        }
        .tint(Style.Color.wordGenerateTheme)
        .navigationTitle("Vowels")
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

#Preview {
    SettingsVowelsMenuView(settings: SettingsManager())
}
