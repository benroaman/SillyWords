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
    private let database: Database
    private let generator: BRWordGenerator
    
    private(set) var currentWord: GeneratedWord
    var currentWordText: String { currentWord.word }
    var currentSentence: SentenceGenerator.Sentence = .init(text: "", attribution: "")
    
    init(_ settings: SettingsManager, database: Database) {
        self.settings = settings
        self.database = database
        self.generator = BRWordGenerator()
        self.currentWord = Self.emptyWord
        try? self.makeWord()
    }
}

// MARK: Public API
extension GenerationManager {
    func makeWord() throws {
        let settingsPackage = settings.settingsPackage
        #warning("TODO: Consider making this pass a set of all words in the list, or removing it altogether")
        let result = generator.makeWord(with: settingsPackage, previousWord: currentWordText)
        let generated = GeneratedWord(word: result.word,
                             syllables: result.syllables,
                             settings: settingsPackage)
        
        currentWord = generated
        currentSentence = SentenceGenerator.useItInASentence(currentWordText)
        try database.createWord(content: generated)
    }
    
    func makeSentence() {
        currentSentence = SentenceGenerator.useItInASentence(currentWordText)
    }
}

extension GenerationManager {
    static var emptyWord: GeneratedWord {
        .init(word: "", syllables: 0, settings: .init(minSyllables: 0, maxSyllables: 0, allowVowelCombos: false, allowsYAsVowel: false, filterSortOfBadWords: false, soloQs: false, initialDigraphs: false, initialDigraphBlends: false, initial2LetterBlends: false, initial3LetterBlends: false, middleDigraphs: false, middleDigraphBlends: false, middle2LetterBlends: false, middle3LetterBlends: false, finalDigraphs: false, finalDigraphBlends: false, final2LetterBlends: false, final3LetterBlends: false))
    }
}
