//
//  SettingsFavoritesMenuView.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/14/26.
//

import SwiftUI

struct SettingsFavoritesMenuView<M: SettingsFavoritesMenuViewModel>: View {
    @State var model: M
    
    var body: some View {
        List {
            ForEach(SettingsFavoritesMenuOption.allCases, id: \.self) { option in
                Button(action: {
                    model.settingsFavoritesMenuDoSelectOption(option)
                }, label: {
                    SettingsSimpleMenuRow(option: option)
                })
            }
        }
        .navigationTitle("Favorites")
        .alert("Delete all favorites?", isPresented: $model.settingsFavoritesMenuIsPresentingPurgeConfirm, actions: {
            Button(role: .cancel, action: { })
            Button("Delete", role: .destructive, action: {
                model.settingsFavoritesMenuViewDoPurge()
            })
        })
    }
}

// MARK: Previews
#Preview {
    SettingsFavoritesMenuView(model: SettingsFavoritesMenuViewModelPreview())
}
