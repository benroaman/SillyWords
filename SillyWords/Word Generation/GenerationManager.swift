//
//  GenerationManager.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/10/26.
//

import Foundation
import BRWordGeneration

class GenerationManager {
    private let generator: BRWordGenerator<SettingsManager>
    
    init(_ settings: SettingsManager) {
        self.generator = BRWordGenerator(settings)
    }
}

// MARK: Public API
extension GenerationManager {
    func makeWordAsync(previousWord: String) async -> String {
        await generator.makeWordAsync(previousWord: previousWord)
    }

    func makeWord(previousWord: String) -> String {
        generator.makeWord(previousWord: previousWord)
    }
}
