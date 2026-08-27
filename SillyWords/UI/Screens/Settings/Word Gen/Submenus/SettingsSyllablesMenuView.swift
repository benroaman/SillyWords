//
//  SettingsSyllablesMenuView.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/14/26.
//

import SwiftUI

// MARK: Base
struct SettingsSyllablesMenuView<S: SyllableSettings>: View {
    // MARK: Instance Variables - State
    @State var settings: S
    
    // MARK: Body
    var body: some View {
        List {
            SettingInputNumberPicker(setting: .minSyllables,
                                     options: settings.minimumSyllableOptions,
                                     value: $settings.minSyllables)
            SettingInputNumberPicker(setting: .maxSyllables,
                                     options: settings.maximumSyllableOptions,
                                     value: $settings.maxSyllables)
        }
        .tint(Style.Theme.Color.wordGenerate)
        .navigationTitle("Syllables")
    }
}

// MARK: Support Types
protocol SyllableSettings: AnyObject, Observable {
    var minSyllables: Int { get set }
    var maxSyllables: Int { get set }
    var minimumSyllableOptions: [Int] { get }
    var maximumSyllableOptions: [Int] { get }
}

// MARK: Previews
#Preview {
    SettingsSyllablesMenuView(settings: SettingsManager())
}

