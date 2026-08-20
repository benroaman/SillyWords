//
//  SettingsManager.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/3/26.
//

import Foundation
import BRWordGeneration

@Observable
class SettingsManager {
    private typealias S = Settings.WordGeneration
    
    // MARK: Instance Constants
    static let minimumAllowableSyllables: Int = 1
    static let maximumAllowableSyllables: Int = 5
    
    // MARK: Syllables
    var minSyllables: Int = S.MinSyllables.current {
        didSet { S.MinSyllables.set(minSyllables) }
    }
    
    var maxSyllables: Int = S.MaxSyllables.current {
        didSet { S.MaxSyllables.set(maxSyllables) }
    }
    
    // MARK: Vowels
    var allowVowelCombos: Bool = S.AllowVowelCombos.current {
        didSet { S.AllowVowelCombos.set(allowVowelCombos) }
    }
    
    var allowsYAsVowel: Bool = S.AllowYAsVowel.current {
        didSet { S.AllowYAsVowel.set(allowsYAsVowel) }
    }
    
    // MARK: Explitives
    var filterSortOfBadWords: Bool = S.FilterSortOfBadWords.current {
        didSet { S.FilterSortOfBadWords.set(filterSortOfBadWords) }
    }
    
    // MARK: Consonants
    var soloQs: Bool = S.Consonants.SoloQs.current {
        didSet { S.Consonants.SoloQs.set(soloQs) }
    }
    
    var initialDigraphs: Bool = S.Consonants.InitialDigraphs.current {
        didSet { S.Consonants.InitialDigraphs.set(initialDigraphs) }
    }
    
    var initialDigraphBlends: Bool = S.Consonants.InitialDigraphBlends.current {
        didSet { S.Consonants.InitialDigraphBlends.set(initialDigraphBlends) }
    }
    
    var initial2LetterBlends: Bool = S.Consonants.Initial2LetterBlends.current {
        didSet { S.Consonants.Initial2LetterBlends.set(initial2LetterBlends) }
    }
    
    var initial3LetterBlends: Bool = S.Consonants.Initial3LetterBlends.current {
        didSet { S.Consonants.Initial3LetterBlends.set(initial3LetterBlends) }
    }
    
    var middleDigraphs: Bool = S.Consonants.MiddleDigraphs.current {
        didSet { S.Consonants.MiddleDigraphs.set(middleDigraphs) }
    }
    
    var middleDigraphBlends: Bool = S.Consonants.MiddleDigraphBlends.current {
        didSet { S.Consonants.MiddleDigraphBlends.set(middleDigraphBlends) }
    }
    
    var middle2LetterBlends: Bool = S.Consonants.Middle2LetterBlends.current {
        didSet { S.Consonants.Middle2LetterBlends.set(middle2LetterBlends) }
    }
    
    var middle3LetterBlends: Bool = S.Consonants.Middle3LetterBlends.current {
        didSet { S.Consonants.Middle3LetterBlends.set(middle3LetterBlends) }
    }
    
    var finalDigraphs: Bool = S.Consonants.FinalDigraphs.current {
        didSet { S.Consonants.FinalDigraphs.set(finalDigraphs) }
    }
    
    var finalDigraphBlends: Bool = S.Consonants.FinalDigraphBlends.current {
        didSet { S.Consonants.FinalDigraphBlends.set(finalDigraphBlends) }
    }
    
    var final2LetterBlends: Bool = S.Consonants.Final2LetterBlends.current {
        didSet { S.Consonants.Final2LetterBlends.set(final2LetterBlends) }
    }
    
    var final3LetterBlends: Bool = S.Consonants.Final3LetterBlends.current {
        didSet { S.Consonants.Final3LetterBlends.set(final3LetterBlends) }
    }
    
    // MARK: Computed Values
    var minimumSyllableOptions: [Int] { Array(Self.minimumAllowableSyllables...maxSyllables) }
    var maximumSyllableOptions: [Int] { Array(minSyllables...Self.maximumAllowableSyllables) }
    var settingsPackage: BRWordGenerationSettings {
        .init(minSyllables: minSyllables,
              maxSyllables: maxSyllables,
              allowVowelCombos: allowVowelCombos,
              allowsYAsVowel: allowsYAsVowel,
              filterSortOfBadWords: filterSortOfBadWords,
              soloQs: soloQs,
              initialDigraphs: initialDigraphs,
              initialDigraphBlends: initialDigraphBlends,
              initial2LetterBlends: initial2LetterBlends,
              initial3LetterBlends: initial3LetterBlends,
              middleDigraphs: middleDigraphs,
              middleDigraphBlends: middleDigraphBlends,
              middle2LetterBlends: middle2LetterBlends,
              middle3LetterBlends: middle3LetterBlends,
              finalDigraphs: finalDigraphs,
              finalDigraphBlends: finalDigraphBlends,
              final2LetterBlends: final2LetterBlends,
              final3LetterBlends: final3LetterBlends)
    }
}

@propertyWrapper struct SettingBacked<S: BRSetting> {
    private var value: S.Value
    
    var wrappedValue: S.Value {
        get { value }
        set {
            value = newValue
            S.set(newValue)
        }
    }
    
    init() {
        self.value = S.current
    }
}
