//
//  SettingInputNumberPicker.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/22/26.
//

import SwiftUI

struct SettingInputNumberPicker: View {
    let setting: SettingInput
    let options: [Int]
    @Binding var value: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Picker(setting.title, selection: $value) {
                ForEach(options, id: \.self) { option in
                    Text("\(option)").tag(option)
                }
            }
            .font(.headline)
            SettingInfoView(setting: setting)
        }
    }
}

#Preview {
    PreviewWrapper()
}

fileprivate struct PreviewWrapper: View {
    @State private var value: Int = 1
    
    var body: some View {
        List {
            SettingInputNumberPicker(setting: .minSyllables, options: [1, 2, 3, 4, 5], value: $value)
        }
        .tint(.green)
    }
}
