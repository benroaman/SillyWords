//
//  SettingsWordGenCurrentWordTransitionMenuViewModel.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/24/26.
//

import SwiftUI

// MARK: Requirements
protocol SettingsWordGenCurrentWordTransitionMenuViewModel: AnyObject, Observable {
    var selected: WordTransitionStyle { get }
    func select(style: WordTransitionStyle)
}

// MARK: Preview Implementation
@Observable class SettingsWordGenCurrentWordTransitionMenuViewModelPreview: SettingsWordGenCurrentWordTransitionMenuViewModel {
    @MainActor private(set) var selected: WordTransitionStyle = .splode
    func select(style: WordTransitionStyle) {
        selected = style
    }
}

// MARK: Prod Implementation
@Observable class SettingsWordGenCurrentWordTransitionMenuViewModelProd: SettingsWordGenCurrentWordTransitionMenuViewModel {
    /// Instance Constants
    private let settings: SettingsManager
    
    /// Initializers
    init(settings: SettingsManager) {
        self.settings = settings
    }
    
    /// SettingsWordGenCurrentWordTransitionMenuViewModel Implementation
    var selected: WordTransitionStyle { settings.wordGenCurrentWordTransitionStyle }
    func select(style: WordTransitionStyle) { settings.wordGenCurrentWordTransitionStyle = style }
}
