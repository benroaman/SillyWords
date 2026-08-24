//
//  SettingsUserInterfaceMenuViewModel.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/23/26.
//

import Foundation

// MARK: Requirements
protocol SettingsUserInterfaceMenuViewModel: AnyObject, Observable {
    func settingsUserInterfaceMenuDoSelectOption(_ option: SettingsUserInterfaceMenuOption)
    func settingsUserInterfaceMenuOptionCurrentValue(_ option: SettingsUserInterfaceMenuOption) -> String?
}

// MARK: Preview Implementation
@Observable class SettingsUserInterfaceMenuViewModelPreview: SettingsUserInterfaceMenuViewModel {
    func settingsUserInterfaceMenuDoSelectOption(_ option: SettingsUserInterfaceMenuOption) { print(option.title) }
    func settingsUserInterfaceMenuOptionCurrentValue(_ option: SettingsUserInterfaceMenuOption) -> String? { "Selected Value" }
}

// MARK: Prod Implementation
@Observable class SettingsUserInterfaceMenuViewModelProd: SettingsUserInterfaceMenuViewModel {
    private let settings: SettingsManager
    private let router: Router<MainRoute>
    
    init(settings: SettingsManager, router: Router<MainRoute>) {
        self.settings = settings
        self.router = router
    }
    
    func settingsUserInterfaceMenuDoSelectOption(_ option: SettingsUserInterfaceMenuOption) {
        switch option {
        case .wordGenCurrentWordTransitionStyle: router.push(.settingsWordGenCurrentWordTransition)
        }
    }
    
    func settingsUserInterfaceMenuOptionCurrentValue(_ option: SettingsUserInterfaceMenuOption) -> String? {
        switch option {
        case .wordGenCurrentWordTransitionStyle: return settings.wordGenCurrentWordTransitionStyle.displayName
        }
    }
}
