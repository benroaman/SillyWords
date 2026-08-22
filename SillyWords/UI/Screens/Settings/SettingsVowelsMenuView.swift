//
//  SettingsVowelsMenuView.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/14/26.
//

import SwiftUI

struct SettingsVowelsMenuView<S: VowelSettings>: View {
    @State var settings: S
    
    var body: some View {
        List {
            SettingInputSwitchPicker(setting: .allowVowelCombos,
                                     value: $settings.allowVowelCombos)
            SettingInputSwitchPicker(setting: .allowYAsVowel,
                                     value: $settings.allowsYAsVowel)
        }
        .tint(Style.Color.wordGenerateTheme)
        .navigationTitle("Vowels")
    }
}

protocol VowelSettings: AnyObject, Observable {
    var allowVowelCombos: Bool { get set }
    var allowsYAsVowel: Bool { get set }
}

#Preview {
    SettingsVowelsMenuView(settings: SettingsManager())
}
