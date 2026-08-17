//
//  GenerationManager.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/10/26.
//

import Foundation
import BRWordGeneration

@Observable
class GenerationManager {
    private let settings: SettingsManager
    private let generator: BRWordGenerator
    
    private(set) var currentWordText: String = ""
    private(set) var words: [GeneratedWord] = []
    
    init(_ settings: SettingsManager) {
        self.settings = settings
        self.generator = BRWordGenerator()
        self.makeWord()
    }
}

// MARK: Public API
extension GenerationManager {
    func makeWordAsync() async {
        makeWord()
    }

    func makeWord() {
        let settingsPackage = settings.settingsPackage
        #warning("TODO: Consider making this pass a set of all words in the list, or removing it altogether")
        let result = generator.makeWord(with: settingsPackage, previousWord: words.first?.word ?? "")
        let generated = GeneratedWord(word: result.word,
                             syllables: result.syllables,
                             settings: settingsPackage)
        
        currentWordText = generated.word
        words.insert(generated, at: 0)
    }
}
