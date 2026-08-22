//
//  SettingsTabModel.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/14/26.
//

import Foundation
import SwiftUI

protocol SettingsTabFlowModel: AnyObject, Observable, SettingsMainMenuViewModel, SettingsFavoritesMenuViewModel, SettingsWordGenMenuViewModel {
    
}

@Observable
final class SettingsTabModel: SettingsMainMenuViewModel, SettingsFavoritesMenuViewModel, SettingsWordGenMenuViewModel {
    private let settings: SettingsManager
    private let favorites: FavoritesManager
    
    init(_ settings: SettingsManager, favorites: FavoritesManager) {
        self.settings = settings
        self.favorites = favorites
    }
    
    var clearFavoritesFailure: String?
    
    // MARK: SettingsMainMenuViewModel
    var path: [SettingsRoute] = []

    @ViewBuilder func destination(for route: SettingsRoute) -> some View {
        switch route {
        case .wordGeneration: SettingsWordGenMenuView(model: self)
        case .favorites: SettingsFavoritesMenuView(model: self)
        case .syllables: SettingsSyllablesMenuView(settings: settings)
        case .vowels: SettingsVowelsMenuView(settings: settings)
        case .consonants: SettingsConsonantsMenuView(settings: settings)
        }
    }
    
    // MARK: SettingsMainMenuViewModel
    var settingsMainMenuPresentedEmail: Email?
    
    func onSettingsMainMenuTabOptionSelected(_ option: SettingsMainMenuOption) {
        switch option {
        case .wordGeneration: path.append(.wordGeneration)
        case .favorites: path.append(.favorites)
        case .feedback: settingsMainMenuPresentedEmail = .feedback
        }
    }
    
    // MARK: SettingsFavoritesMenuViewModel
    var settingsFavoritesMenuViewIsPresentingPurgeConfirm: Bool = false
    
    func settingsFavoritesMenuViewDoPurge() {
        Task {
            do {
                try await favorites.clearFavorites()
            } catch let error as DatabaseError {
                await MainActor.run {
                    self.clearFavoritesFailure = "Failed to clear favorites: \(error.description)"
                }
            } catch {
                await MainActor.run {
                    self.clearFavoritesFailure = "Failed to clear favorites: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func settingsFavoritesMenuDoSelectOption(_ option: SettingsFavoritesMenuOption) {
        switch option {
        case .clear: settingsFavoritesMenuViewIsPresentingPurgeConfirm = true
        }
    }
    
    // MARK: SettingsWordGenMenuViewModel
    func settingsWordGenMenuDoSelectOption(_ option: SettingsWordGenMenuOption) {
        switch option {
        case .syllables: path.append(.syllables)
        case .vowels: path.append(.vowels)
        case .consonants: path.append(.consonants)
        }
    }
}
