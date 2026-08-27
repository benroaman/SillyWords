//
//  SettingInfoView.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/22/26.
//

import SwiftUI

// MARK: Base
struct SettingInfoView: View {
    // MARK: Instance Constants
    let description: String?
    let example: String?
    
    // MARK: Initializers
    init(description: String?, example: String?) {
        self.description = description
        self.example = example
    }
    
    init(setting: SettingInput) {
        self.description = setting.description
        self.example = setting.example
    }
    
    init(wordGenPreset: WordGenSettingsPreset) {
        self.description = wordGenPreset.description
        self.example = wordGenPreset.example
    }
    
    // MARK: Body
    var body: some View {
        if let description {
            Text(description)
                .font(Style.Settings.Font.optionDescription)
                .foregroundStyle(Style.Settings.Color.optionDescription)
        }
        if let example {
            Text(example)
                .font(Style.Settings.Font.optionExample)
                .foregroundStyle(Style.Settings.Color.optionExample)
        }
    }
}

// MARK: Previews
#Preview {
    List {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(SettingInput.allCases, id: \.self) { setting in
                SettingInfoView(setting: setting)
                Divider()
            }
        }
        .frame(maxWidth: .infinity)
    }
}
