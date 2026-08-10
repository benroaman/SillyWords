//
//  SettingsConsonantsMenuView.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/14/26.
//

import SwiftUI

struct SettingsConsonantsMenuView: View {
    @State var settings: SettingsManager
    
    var body: some View {
        List {
            Section("Initial") {
                makeSwitchPicker(.initialDigraphs, value: $settings.initialDigraphs)
                makeSwitchPicker(.initialDigraphBlends, value: $settings.initialDigraphBlends)
                makeSwitchPicker(.initial2LetterBlends, value: $settings.initial2LetterBlends)
                makeSwitchPicker(.initial3LetterBlends, value: $settings.initial3LetterBlends)
            }
            
            Section("Middle") {
                makeSwitchPicker(.middleDigraphs, value: $settings.middleDigraphs)
                makeSwitchPicker(.middleDigraphBlends, value: $settings.middleDigraphBlends)
                makeSwitchPicker(.middle2LetterBlends, value: $settings.middle2LetterBlends)
                makeSwitchPicker(.middle3LetterBlends, value: $settings.middle3LetterBlends)
            }
            
            Section("Final") {
                makeSwitchPicker(.finalDigraphs, value: $settings.finalDigraphs)
                makeSwitchPicker(.finalDigraphBlends, value: $settings.finalDigraphBlends)
                makeSwitchPicker(.final2LetterBlends, value: $settings.final2LetterBlends)
                makeSwitchPicker(.final3LetterBlends, value: $settings.final3LetterBlends)
            }
            
            Section("Misc") {
                makeSwitchPicker(.soloQs, value: $settings.soloQs)
            }
        }
        .tint(Style.Color.wordGenerateTheme)
        .navigationTitle("Consonants")
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
    SettingsConsonantsMenuView(settings: SettingsManager())
}
