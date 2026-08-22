//
//  SettingInfoView.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/22/26.
//

import SwiftUI

struct SettingInfoView: View {
    let setting: SettingInput
    
    var body: some View {
        if let description = setting.description {
            Text(description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        if let example = setting.example {
            Text(example)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

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
