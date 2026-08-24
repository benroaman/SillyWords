//
//  SettingsMainMenuViewModel.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/22/26.
//

import Foundation

// MARK: Requirements
protocol SettingsMainMenuViewModel: AnyObject {
    func onSettingsMainMenuTabOptionSelected(_ option: SettingsMainMenuOption)
}

// MARK: Preview Implementation
class SettingsMainMenuViewModelPreview: SettingsMainMenuViewModel {
    func onSettingsMainMenuTabOptionSelected(_ option: SettingsMainMenuOption) { print(option.title) }
}

// MARK: Prod Implementation
class SettingsMainMenuViewModelProd<N: SettingsTabNavigation>: SettingsMainMenuViewModel {
    /// Instance Constants
    let navigation: N
    
    /// Initializers
    init(_ navigation: N) {
        self.navigation = navigation
    }
    
    /// SettingsMainMenuViewModel Implementation
    func onSettingsMainMenuTabOptionSelected(_ option: SettingsMainMenuOption) {
        switch option {
        case .wordGen: navigation.settingsTabRouter.push(.settingsWordGen)
        case .favorites: navigation.settingsTabRouter.push(.settingsFavorites)
        case .userInterface: navigation.settingsTabRouter.push(.settingsUserInterface)
        case .feedback: navigation.presentedEmail = .feedback
        }
    }
}

