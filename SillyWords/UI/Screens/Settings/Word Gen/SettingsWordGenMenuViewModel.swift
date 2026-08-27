//
//  SettingsWordGenMenuViewModel.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/22/26.
//

import Foundation

// MARK: Requirements
protocol SettingsWordGenMenuViewModel: AnyObject {
    func settingsWordGenMenuDoSelectOption(_ option: SettingsWordGenMenuOption)
}

// MARK: Preview
class SettingsWordGenMenuViewModelPreview: SettingsWordGenMenuViewModel {
    func settingsWordGenMenuDoSelectOption(_ option: SettingsWordGenMenuOption) { print(option.title) }
}

// MARK: Prod
class SettingsWordGenMenuViewModelProd: SettingsWordGenMenuViewModel {
    /// Instance Members
    let router: Router<MainRoute>
    
    /// Initializers
    init(_ router: Router<MainRoute>) {
        self.router = router
    }
    
    /// SettingsWordGenMenuViewModel Implementation
    func settingsWordGenMenuDoSelectOption(_ option: SettingsWordGenMenuOption) {
        switch option {
        case .syllables: router.push(.settingsSyllables)
        case .vowels: router.push(.settingsVowels)
        case .consonants: router.push(.settingsConsonants)
        case .sentence: router.push(.settingsSentences)
        case .presets: router.push(.settingsWordGenPresets)
        }
    }
}
