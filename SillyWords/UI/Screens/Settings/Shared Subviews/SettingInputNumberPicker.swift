//
//  SettingInputNumberPicker.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/22/26.
//

import SwiftUI

// MARK: Base
struct SettingInputNumberPicker: View {
    // MARK: Instance Constants
    let setting: SettingInput
    let options: [Int]
    
    // MARK: Instance Variables - State
    @Binding var value: Int
    
    // MARK: Body
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Picker(setting.title, selection: $value) {
                ForEach(options, id: \.self) { option in
                    Text("\(option)").tag(option)
                }
            }
            .font(.headline)
            .sensoryFeedback(.selection, trigger: value)
            SettingInfoView(setting: setting)
        }
    }
}

// MARK: Previews
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
