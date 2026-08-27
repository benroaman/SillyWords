//
//  SettingInputSwitchPicker.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/22/26.
//

import SwiftUI

// MARK: Base
struct SettingInputSwitchPicker: View {
    // MARK: Instance Constants
    let setting: SettingInput
    
    // MARK: Instance Variables - State
    @Binding var value: Bool
    
    // MARK: Body
    var body: some View {
        VStack(alignment: .leading, spacing: Style.Settings.Spacing.optionTitleBottom) {
            Toggle(setting.title, isOn: $value)
                .font(Style.Settings.Font.optionTitle)
            SettingInfoView(setting: setting)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            value.toggle()
        }
    }
}

// MARK: Previews
#Preview {
    PreviewWrapper()
}

fileprivate struct PreviewWrapper: View {
    @State private var value: Bool = false
    
    var body: some View {
        SettingInputSwitchPicker(setting: .initial2LetterBlends, value: $value)
    }
}
