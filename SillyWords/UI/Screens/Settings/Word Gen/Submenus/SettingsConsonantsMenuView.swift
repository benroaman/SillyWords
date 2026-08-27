//
//  SettingsConsonantsMenuView.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/14/26.
//

import SwiftUI

// MARK: Base
struct SettingsConsonantsMenuView<S: ConsonantSettings>: View {
    // MARK: Instance Variables - State
    @State var settings: S
    
    // MARK: Body
    var body: some View {
        List {
            initialSection
            middleSection
            finalSection
            miscSection
        }
        .tint(Style.Theme.Color.wordGenerate)
        .navigationTitle("Consonants")
    }
}

// MARK: Private API - ViewBuilders
private extension SettingsConsonantsMenuView {
    @ViewBuilder var initialSection: some View {
        Section("Initial") {
            SettingInputSwitchPicker(setting: .initialDigraphs,
                                     value: $settings.initialDigraphs)
            SettingInputSwitchPicker(setting: .initialDigraphBlends,
                                     value: $settings.initialDigraphBlends)
            SettingInputSwitchPicker(setting: .initial2LetterBlends,
                                     value: $settings.initial2LetterBlends)
            SettingInputSwitchPicker(setting: .initial3LetterBlends,
                                     value: $settings.initial3LetterBlends)
        }
    }
    
    @ViewBuilder var middleSection: some View {
        Section("Middle") {
            SettingInputSwitchPicker(setting: .middleDigraphs,
                                     value: $settings.middleDigraphs)
            SettingInputSwitchPicker(setting: .middleDigraphBlends,
                                     value: $settings.middleDigraphBlends)
            SettingInputSwitchPicker(setting: .middle2LetterBlends,
                                     value: $settings.middle2LetterBlends)
            SettingInputSwitchPicker(setting: .middle3LetterBlends,
                                     value: $settings.middle3LetterBlends)
        }
    }
    
    @ViewBuilder var finalSection: some View {
        Section("Final") {
            SettingInputSwitchPicker(setting: .finalDigraphs,
                                     value: $settings.finalDigraphs)
            SettingInputSwitchPicker(setting: .finalDigraphBlends,
                                     value: $settings.finalDigraphBlends)
            SettingInputSwitchPicker(setting: .final2LetterBlends,
                                     value: $settings.final2LetterBlends)
            SettingInputSwitchPicker(setting: .final3LetterBlends,
                                     value: $settings.final3LetterBlends)
        }
    }
    
    @ViewBuilder var miscSection: some View {
        Section("Misc") {
            SettingInputSwitchPicker(setting: .soloQs,
                                     value: $settings.soloQs)
        }
    }
}

// MARK: Support Types
protocol ConsonantSettings: AnyObject, Observable {
    var soloQs: Bool { get set }
    var initialDigraphs: Bool { get set }
    var initialDigraphBlends: Bool { get set }
    var initial2LetterBlends: Bool { get set }
    var initial3LetterBlends: Bool { get set }
    var middleDigraphs: Bool { get set }
    var middleDigraphBlends: Bool { get set }
    var middle2LetterBlends: Bool { get set }
    var middle3LetterBlends: Bool { get set }
    var finalDigraphs: Bool { get set }
    var finalDigraphBlends: Bool { get set }
    var final2LetterBlends: Bool { get set }
    var final3LetterBlends: Bool { get set }
}

// MARK: Previews
#Preview {
    SettingsConsonantsMenuView(settings: SettingsManager())
}
