//
//  SettingsFavoriteMenuViewModel.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/22/26.
//

import SwiftUI

// MARK: Model Requirements
protocol SettingsFavoritesMenuViewModel: AnyObject, Observable {
    var settingsFavoritesMenuIsPresentingPurgeConfirm: Bool { get set }
    var settingsFavoritesMenuPurgeErrorMessage: String? { get }
    var settingsFavoritesMenuIsPresentingPurgeErrorMessage: Binding<Bool> { get }
    
    func settingsFavoritesMenuDoSelectOption(_ option: SettingsFavoritesMenuOption)
    func settingsFavoritesMenuViewDoPurge()
}

@Observable class SettingsFavoritesMenuViewModelPreview: SettingsFavoritesMenuViewModel {
    var settingsFavoritesMenuIsPresentingPurgeConfirm: Bool = false
    var settingsFavoritesMenuPurgeErrorMessage: String? = "Puge Error: Message"
    var settingsFavoritesMenuIsPresentingPurgeErrorMessage: Binding<Bool> {
        .init(
            get: {
                self.settingsFavoritesMenuPurgeErrorMessage == nil
            }, set: { isPresented in
                if !isPresented { self.settingsFavoritesMenuPurgeErrorMessage = nil }
            }
        )
    }
    
    func settingsFavoritesMenuDoSelectOption(_ option: SettingsFavoritesMenuOption) {
        switch option {
            case .clear: settingsFavoritesMenuIsPresentingPurgeConfirm = true
        }
    }
    
    func settingsFavoritesMenuViewDoPurge() { print("PURGE") }
}

@Observable class SettingsFavoritesMenuViewModelProd: SettingsFavoritesMenuViewModel {
    let manager: FavoritesManager
    
    init(_ manager: FavoritesManager) {
        self.manager = manager
    }
    
    var settingsFavoritesMenuIsPresentingPurgeConfirm: Bool = false
    var settingsFavoritesMenuPurgeErrorMessage: String?
    var settingsFavoritesMenuIsPresentingPurgeErrorMessage: Binding<Bool> {
        .init(
            get: {
                self.settingsFavoritesMenuPurgeErrorMessage == nil
            }, set: { isPresented in
                if !isPresented { self.settingsFavoritesMenuPurgeErrorMessage = nil }
            }
        )
    }
    
    func settingsFavoritesMenuDoSelectOption(_ option: SettingsFavoritesMenuOption) {
        switch option {
            case .clear: settingsFavoritesMenuIsPresentingPurgeConfirm = true
        }
    }
    
    func settingsFavoritesMenuViewDoPurge() {
        Task {
            do {
                try await manager.clearFavorites()
            } catch {
                await MainActor.run {
                    self.settingsFavoritesMenuPurgeErrorMessage = "Clear favorites failed: \((error as? DatabaseError)?.description ?? error.localizedDescription)"
                }
            }
        }
    }
}
