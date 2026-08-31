//
//  GeneratedWord.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/16/26.
//

import Foundation
import BRWordGeneration

// MARK: Base
struct GeneratedWord {
    let word: String
    let syllables: Int
    let settings: BRWordGenerationSettings
}

// MARK: Identifiable Conformation
extension GeneratedWord: Identifiable {
    var id: String { word }
}

// MARK: Mock Data
extension GeneratedWord {
    private static var mockSettings: BRWordGenerationSettings { .init(minSyllables: 1, maxSyllables: 5, allowVowelCombos: true, allowsYAsVowel: true, filterSortOfBadWords: true, soloQs: true, initialDigraphs: true, initialDigraphBlends: true, initial2LetterBlends: true, initial3LetterBlends: true, middleDigraphs: true, middleDigraphBlends: true, middle2LetterBlends: true, middle3LetterBlends: true, finalDigraphs: true, finalDigraphBlends: true, final2LetterBlends: true, final3LetterBlends: true)}
    
    static var mock1: Self { .init(word: "glunde", syllables: 2, settings: Self.mockSettings) }
    static var mock2: Self { .init(word: "brismucect", syllables: 3, settings: Self.mockSettings) }
    static var mock3: Self { .init(word: "phivumpta", syllables: 2, settings: Self.mockSettings) }
    static var mock4: Self { .init(word: "scronti", syllables: 2, settings: Self.mockSettings) }
    static var mock5: Self { .init(word: "ostugo", syllables: 3, settings: Self.mockSettings) }
    static var mock6: Self { .init(word: "ujinchi", syllables: 3, settings: Self.mockSettings) }
}
