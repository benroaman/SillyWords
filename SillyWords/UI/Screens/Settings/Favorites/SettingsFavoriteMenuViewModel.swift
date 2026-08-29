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
    var removeAllFavoritesError: (any Error)? { get set }
    
    func settingsFavoritesMenuDoSelectOption(_ option: SettingsFavoritesMenuOption)
    func settingsFavoritesMenuViewDoPurge()
}

// MARK: Preview Implementation
@Observable class SettingsFavoritesMenuViewModelPreview: SettingsFavoritesMenuViewModel {
    var settingsFavoritesMenuIsPresentingPurgeConfirm: Bool = false
    var removeAllFavoritesError: (any Error)?
    
    func settingsFavoritesMenuDoSelectOption(_ option: SettingsFavoritesMenuOption) {
        switch option {
            case .clear: settingsFavoritesMenuIsPresentingPurgeConfirm = true
        }
    }
    
    func settingsFavoritesMenuViewDoPurge() {
        if Bool.random() {
            removeAllFavoritesError = DatabaseError.mockMisc
        }
    }
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
    var removeAllFavoritesError: (any Error)?
    
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
                    self.removeAllFavoritesError = error
                }
            }
        }
    }
}
