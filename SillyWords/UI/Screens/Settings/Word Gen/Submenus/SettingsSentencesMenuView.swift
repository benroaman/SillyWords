//
//  SettingsSentencesMenuView.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/26/26.
//

import SwiftUI

// MARK: Base
struct SettingsSentencesMenuView<S: SentenceSettings>: View {
    // MARK: Instance Variables - State
    @State var settings: S
    
    // MARK: Body
    var body: some View {
        List {
            SettingInputSwitchPicker(setting: .showSentenceOnMainWordGen,
                                     value: $settings.showSentenceOnMainWordGen)
            SettingInputSwitchPicker(setting: .includeSentenceAttribution,
                                     value: $settings.includeSentenceAttribution)
        }
        .tint(Style.Color.wordGenerateTheme)
        .navigationTitle("Sentences")
    }
}

// MARK: Support Types
protocol SentenceSettings: AnyObject, Observable {
    var includeSentenceAttribution: Bool { get set }
    var showSentenceOnMainWordGen: Bool { get set }
}

// MARK: Previews
#Preview {
    SettingsSentencesMenuView(settings: SettingsManager())
}
