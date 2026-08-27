//
//  SettingsManager.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/3/26.
//

import Foundation
import BRWordGeneration

@Observable
@MainActor class SettingsManager: ConsonantSettings, SyllableSettings, VowelSettings, SentenceSettings {
    private typealias WG = Settings.WordGen
    private typealias UI = Settings.UserInterface
    private typealias SG = Settings.SentenceGen
    
    // MARK: Instance Constants
    static let minimumAllowableSyllables: Int = 1
    static let maximumAllowableSyllables: Int = 5
    
    // MARK: Syllables
    var minSyllables: Int = WG.MinSyllables.current {
        didSet { WG.MinSyllables.set(minSyllables) }
    }
        
    var maxSyllables: Int = WG.MaxSyllables.current {
        didSet { WG.MaxSyllables.set(maxSyllables) }
    }
    
    // MARK: Vowels
    var allowVowelCombos: Bool = WG.AllowVowelCombos.current {
        didSet { WG.AllowVowelCombos.set(allowVowelCombos) }
    }
    
    var allowsYAsVowel: Bool = WG.AllowYAsVowel.current {
        didSet { WG.AllowYAsVowel.set(allowsYAsVowel) }
    }
    
    // MARK: Explitives
    var filterSortOfBadWords: Bool = WG.FilterSortOfBadWords.current {
        didSet { WG.FilterSortOfBadWords.set(filterSortOfBadWords) }
    }
    
    // MARK: Consonants
    var soloQs: Bool = WG.Consonants.SoloQs.current {
        didSet { WG.Consonants.SoloQs.set(soloQs) }
    }
    
    var initialDigraphs: Bool = WG.Consonants.InitialDigraphs.current {
        didSet { WG.Consonants.InitialDigraphs.set(initialDigraphs) }
    }
    
    var initialDigraphBlends: Bool = WG.Consonants.InitialDigraphBlends.current {
        didSet { WG.Consonants.InitialDigraphBlends.set(initialDigraphBlends) }
    }
    
    var initial2LetterBlends: Bool = WG.Consonants.Initial2LetterBlends.current {
        didSet { WG.Consonants.Initial2LetterBlends.set(initial2LetterBlends) }
    }
    
    var initial3LetterBlends: Bool = WG.Consonants.Initial3LetterBlends.current {
        didSet { WG.Consonants.Initial3LetterBlends.set(initial3LetterBlends) }
    }
    
    var middleDigraphs: Bool = WG.Consonants.MiddleDigraphs.current {
        didSet { WG.Consonants.MiddleDigraphs.set(middleDigraphs) }
    }
    
    var middleDigraphBlends: Bool = WG.Consonants.MiddleDigraphBlends.current {
        didSet { WG.Consonants.MiddleDigraphBlends.set(middleDigraphBlends) }
    }
    
    var middle2LetterBlends: Bool = WG.Consonants.Middle2LetterBlends.current {
        didSet { WG.Consonants.Middle2LetterBlends.set(middle2LetterBlends) }
    }
    
    var middle3LetterBlends: Bool = WG.Consonants.Middle3LetterBlends.current {
        didSet { WG.Consonants.Middle3LetterBlends.set(middle3LetterBlends) }
    }
    
    var finalDigraphs: Bool = WG.Consonants.FinalDigraphs.current {
        didSet { WG.Consonants.FinalDigraphs.set(finalDigraphs) }
    }
    
    var finalDigraphBlends: Bool = WG.Consonants.FinalDigraphBlends.current {
        didSet { WG.Consonants.FinalDigraphBlends.set(finalDigraphBlends) }
    }
    
    var final2LetterBlends: Bool = WG.Consonants.Final2LetterBlends.current {
        didSet { WG.Consonants.Final2LetterBlends.set(final2LetterBlends) }
    }
    
    var final3LetterBlends: Bool = WG.Consonants.Final3LetterBlends.current {
        didSet { WG.Consonants.Final3LetterBlends.set(final3LetterBlends) }
    }
    
    // MARK: UI
    var wordGenCurrentWordTransitionStyle: WordTransitionStyle = UI.WordGenCurrentWordTransitionStyle.current {
        didSet { UI.WordGenCurrentWordTransitionStyle.set(wordGenCurrentWordTransitionStyle) }
    }
    
    // MARK: Sentence Settings
    var includeSentenceAttribution: Bool = SG.IncludeAttribution.current {
        didSet { SG.IncludeAttribution.set(includeSentenceAttribution) }
    }
    
    var showSentenceOnMainWordGen: Bool = SG.SentenceOnMainScreen.current {
        didSet { SG.SentenceOnMainScreen.set(showSentenceOnMainWordGen) }
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

extension SettingsManager {
    func applyPreset(_ preset: WordGenSettingsPreset) {
        let settings = preset.settings
        minSyllables = settings.minSyllables
        maxSyllables = settings.maxSyllables
        allowVowelCombos = settings.allowVowelCombos
        allowsYAsVowel = settings.allowsYAsVowel
        filterSortOfBadWords = settings.filterSortOfBadWords
        soloQs = settings.soloQs
        initialDigraphs = settings.initialDigraphs
        initialDigraphBlends = settings.initialDigraphBlends
        initial2LetterBlends = settings.initial2LetterBlends
        initial3LetterBlends = settings.initial3LetterBlends
        middleDigraphs = settings.middleDigraphs
        middleDigraphBlends = settings.middleDigraphBlends
        middle2LetterBlends = settings.middle2LetterBlends
        middle3LetterBlends = settings.middle3LetterBlends
        finalDigraphs = settings.finalDigraphs
        finalDigraphBlends = settings.finalDigraphBlends
        final2LetterBlends = settings.final2LetterBlends
        final3LetterBlends = settings.final3LetterBlends
    }
}

@propertyWrapper struct SettingBacked<S: BRSetting> {
    private(set) var wrappedValue: S.Value
    
    var value: S.Value {
        get { wrappedValue }
        set {
            wrappedValue = newValue
            S.set(newValue)
        }
    }
    
    init() {
        self.wrappedValue = S.current
    }
}
