//
//  SettingsUserInterfaceMenuView.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/23/26.
//

import SwiftUI

struct SettingsUserInterfaceMenuView<M: SettingsUserInterfaceMenuViewModel>: View {
    @State var model: M
    
    var body: some View {
        List {
            ForEach(SettingsUserInterfaceMenuOption.allCases, id: \.self) { option in
                Button(action: {
                    model.settingsUserInterfaceMenuDoSelectOption(option)
                }, label: {
                    SettingsSimpleMenuRow(option: option, value: model.settingsUserInterfaceMenuOptionCurrentValue(option))
                })
            }
        }
        .navigationTitle("User Interface")
    }
}

// MARK: Previews
#Preview {
    SettingsUserInterfaceMenuView(model: SettingsUserInterfaceMenuViewModelPreview())
}
