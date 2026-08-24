//
//  SettingsMainMenuViewModel.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/22/26.
//

import Foundation

protocol SettingsMainMenuViewModel: AnyObject {
    func onSettingsMainMenuTabOptionSelected(_ option: SettingsMainMenuOption)
}

class SettingsMainMenuViewModelPreview: SettingsMainMenuViewModel {
    func onSettingsMainMenuTabOptionSelected(_ option: SettingsMainMenuOption) { print(option.title) }
}

class SettingsMainMenuViewModelProd<N: SettingsTabNavigation>: SettingsMainMenuViewModel {
    let navigation: N
    
    init(_ navigation: N) {
        self.navigation = navigation
    }
    
    func onSettingsMainMenuTabOptionSelected(_ option: SettingsMainMenuOption) {
        switch option {
        case .wordGen: navigation.settingsTabRouter.push(.settingsWordGen)
        case .favorites: navigation.settingsTabRouter.push(.settingsFavorites)
        case .userInterface: navigation.settingsTabRouter.push(.settingsUserInterface)
        case .feedback: navigation.presentedEmail = .feedback
        }
    }
}

