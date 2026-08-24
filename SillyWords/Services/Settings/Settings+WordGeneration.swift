//
//  Settings+WordGen.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/3/26.
//

import Foundation
import Combine

extension Settings {
    struct WordGen {
        private init() { }
    }
}

extension Settings.WordGen {
    struct MinSyllables: BRSetting {
        typealias Value = Int
        static var key: String { "com.beebooapps.SillyWords.WordGen.MinSyllables" }
        static var initial: Value { 2 }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
    
    struct MaxSyllables: BRSetting {
        typealias Value = Int
        static var key: String { "com.beebooapps.SillyWords.WordGen.MaxSyllables" }
        static var initial: Value { 3 }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
    
    struct AllowYAsVowel: BRSetting {
        typealias Value = Bool
        static var key: String { "com.beebooapps.SillyWords.WordGen.AllowYAsVowel" }
        static var initial: Value { false }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
    
    struct AllowVowelCombos: BRSetting {
        typealias Value = Bool
        static var key: String { "com.beebooapps.SillyWords.WordGen.AllowVowelCombos" }
        static var initial: Value { false }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
    
    struct FilterSortOfBadWords: BRSetting {
        typealias Value = Bool
        static var key: String { "com.beebooapps.SillyWords.WordGen.FilterSortOfBadWords" }
        static var initial: Value { true }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
}
