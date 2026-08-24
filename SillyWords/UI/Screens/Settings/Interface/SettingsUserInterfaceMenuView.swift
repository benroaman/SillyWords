//
//  SettingsUserInterfaceMenuView.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/23/26.
//

import SwiftUI

// MARK: Base
struct SettingsUserInterfaceMenuView<M: SettingsUserInterfaceMenuViewModel>: View {
    // MARK: Instance Variables - State
    @State var model: M
    
    // MARK: Body
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
