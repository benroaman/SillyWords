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
        .alert("Delete all favorites?", isPresented: $model.settingsFavoritesMenuViewIsPresentingPurgeConfirm, actions: {
            Button(role: .cancel, action: { })
            Button("Delete", role: .destructive, action: {
                model.settingsFavoritesMenuViewDoPurge()
            })
        })
    }
}

// MARK: Model Requirements
protocol SettingsFavoritesMenuViewModel: Observable {
    var settingsFavoritesMenuViewIsPresentingPurgeConfirm: Bool { get set }
    func settingsFavoritesMenuDoSelectOption(_ option: SettingsFavoritesMenuOption)
    func settingsFavoritesMenuViewDoPurge()
}

// MARK: Support Types
enum SettingsFavoritesMenuOption: Int, SettingsSimpleMenuRowOption, CaseIterable {
    case clear
    
    var title: String {
        switch self {
        case .clear: "Clear All Favorites"
        }
    }
    
    var icon: SFSymbol {
        switch self {
        case .clear: .trash
        }
    }
    
    var iconColor: Color {
        switch self {
        case .clear: Style.Color.deleteTheme
        }
    }
    
    var accessory: SFSymbol? {
        switch self {
        case .clear: nil
        }
    }
}

// MARK: Previews
#Preview {
    SettingsFavoritesMenuView(model: MockSettingsFavoritesMenuViewModel())
}

@Observable
fileprivate class MockSettingsFavoritesMenuViewModel: SettingsFavoritesMenuViewModel {
    var settingsFavoritesMenuViewIsPresentingPurgeConfirm: Bool = false
    
    func settingsFavoritesMenuDoSelectOption(_ option: SettingsFavoritesMenuOption) {
        switch option {
            case .clear: settingsFavoritesMenuViewIsPresentingPurgeConfirm = true
        }
    }
    
    func settingsFavoritesMenuViewDoPurge() { print("do_purge") }
}
