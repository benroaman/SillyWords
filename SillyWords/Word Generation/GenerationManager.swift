//
//  GenerationManager.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/10/26.
//

import Foundation
import BRWordGeneration

class GenerationManager {
    private let settings: SettingsManager
    private let generator: BRWordGenerator
    
    init(_ settings: SettingsManager) {
        self.settings = settings
        self.generator = BRWordGenerator()
    }
}

// MARK: Public API
extension GenerationManager {
    func makeWordAsync(previousWord: String) async -> (word: String, syllables: Int, settings: BRWordGenerationSettings) {
        makeWord(previousWord: previousWord)
    }

    func makeWord(previousWord: String) -> (word: String, syllables: Int, settings: BRWordGenerationSettings) {
        let settingsPackage = settings.settingsPackage
        let result = generator.makeWord(with: settingsPackage, previousWord: previousWord)
        return (word: result.word, syllables: result.syllables, settings: settingsPackage)
    }
}
