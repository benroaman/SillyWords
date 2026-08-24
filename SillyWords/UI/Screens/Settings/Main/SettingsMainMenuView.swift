//
//  SettingsView.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/3/26.
//

import SwiftUI

// MARK: Base
struct SettingsMainMenuView<M: SettingsMainMenuViewModel>: View {
    // MARK: Instance Variables - State
    @State var model: M
    
    // MARK: Body
    var body: some View {
        List {
            ForEach(SettingsMainMenuOption.allCases, id: \.self) { option in
                makeSettingsOption(option, action: {
                    model.onSettingsMainMenuTabOptionSelected(option)
                })
            }
        }
    }
}

// MARK: Private API - View Builders
private extension SettingsMainMenuView {
    @ViewBuilder func makeSettingsOption(_ option: SettingsMainMenuOption, action: @escaping () -> Void) -> some View {
        Button(action: action, label: {
            SettingsSimpleMenuRow(option: option)
        })
    }
}

// MARK: Previews
#Preview {
    SettingsMainMenuView(model: SettingsMainMenuViewModelPreview())
}
