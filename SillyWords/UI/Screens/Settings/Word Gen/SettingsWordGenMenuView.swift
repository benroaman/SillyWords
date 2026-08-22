//
//  SettingsWordGenMenuView.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/14/26.
//

import SwiftUI

struct SettingsWordGenMenuView<M: SettingsWordGenMenuViewModel>: View {
    // MARK: Instance Variables - State
    @State var model: M
    
    // MARK: Body
    var body: some View {
        List(SettingsWordGenMenuOption.allCases, id: \.self) { option in
            Button(action: {
                model.settingsWordGenMenuDoSelectOption(option)
            }, label: {
                SettingsSimpleMenuRow(option: option)
            })
        }
        .navigationTitle("Word Generation")
    }
}

// MARK: Previews
#Preview {
    SettingsWordGenMenuView(model: SettingsWordGenMenuViewModelPreview())
}
