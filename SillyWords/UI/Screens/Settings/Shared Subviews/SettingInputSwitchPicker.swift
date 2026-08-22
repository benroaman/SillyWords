//
//  SettingInputSwitchPicker.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/22/26.
//

import SwiftUI

struct SettingInputSwitchPicker: View {
    let setting: SettingInput
    @Binding var value: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle(setting.title, isOn: $value)
                .font(.headline)
            SettingInfoView(setting: setting)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            value.toggle()
        }
    }
}

#Preview {
    PreviewWrapper()
}

fileprivate struct PreviewWrapper: View {
    @State private var value: Bool = false
    
    var body: some View {
        SettingInputSwitchPicker(setting: .initial2LetterBlends, value: $value)
    }
}
