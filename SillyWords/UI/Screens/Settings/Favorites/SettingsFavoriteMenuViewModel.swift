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

// MARK: Preview Implementation
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

// MARK: Prod Implementation
@Observable class SettingsFavoritesMenuViewModelProd: SettingsFavoritesMenuViewModel {
    /// Instance Constants
    let manager: FavoritesManager
    
    /// Initializers
    init(_ manager: FavoritesManager) {
        self.manager = manager
    }
    
    /// SettingsFavoritesMenuViewModel Implementation
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
