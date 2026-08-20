//
//  Settings+WordGeneration.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/3/26.
//

import Foundation
import Combine

extension Settings {
    struct WordGeneration {
        private init() { }
    }
}

extension Settings.WordGeneration {
    struct MinSyllables: BRSetting {
        typealias Value = Int
        static var key: String { "com.beebooapps.SillyWords.WordGeneration.MinSyllables" }
        static var initial: Value { 2 }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
    
    struct MaxSyllables: BRSetting {
        typealias Value = Int
        static var key: String { "com.beebooapps.SillyWords.WordGeneration.MaxSyllables" }
        static var initial: Value { 3 }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
    
    struct AllowYAsVowel: BRSetting {
        typealias Value = Bool
        static var key: String { "com.beebooapps.SillyWords.WordGeneration.AllowYAsVowel" }
        static var initial: Value { false }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
    
    struct AllowVowelCombos: BRSetting {
        typealias Value = Bool
        static var key: String { "com.beebooapps.SillyWords.WordGeneration.AllowVowelCombos" }
        static var initial: Value { false }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
    
    struct FilterSortOfBadWords: BRSetting {
        typealias Value = Bool
        static var key: String { "com.beebooapps.SillyWords.WordGeneration.FilterSortOfBadWords" }
        static var initial: Value { true }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
}
