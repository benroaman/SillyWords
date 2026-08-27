//
//  SettingsWordGenPresetsMenuViewModel.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/26/26.
//

// MARK: Requirements
protocol SettingsWordGenPresetsMenuViewModel: AnyObject {
    func applyPreset(_ preset: WordGenSettingsPreset)
    func isPresetApplied(_ preset: WordGenSettingsPreset) -> Bool
}

// MARK: Preview Implementation
class SettingsWordGenPresetsMenuViewModelPreview: SettingsWordGenPresetsMenuViewModel {
    /// Instance Variables
    private var selectedPreset: WordGenSettingsPreset?
    
    /// SettingsWordGenPresetsMenuViewModel Implementation
    func applyPreset(_ preset: WordGenSettingsPreset) {
        selectedPreset = preset
    }
    
    func isPresetApplied(_ preset: WordGenSettingsPreset) -> Bool {
        selectedPreset == preset
    }
}

// MARK: Production Implementation
class SettingsWordGenPresetsMenuViewModelProd: SettingsWordGenPresetsMenuViewModel {
    /// Instance Variables
    private let settings: SettingsManager
    
    // MARK: Initializers
    init(settings: SettingsManager) {
        self.settings = settings
    }
    
    /// SettingsWordGenPresetsMenuViewModel Implementation
    func applyPreset(_ preset: WordGenSettingsPreset) {
        settings.applyPreset(preset)
    }
    
    func isPresetApplied(_ preset: WordGenSettingsPreset) -> Bool {
        settings.settingsPackage == preset.settings
    }
}
