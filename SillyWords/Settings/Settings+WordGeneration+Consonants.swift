//
//  Settings+WordGeneration+Consonants.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/14/26.
//

import Foundation
import Combine

extension Settings.WordGeneration {
    struct Consonants {
        private init() { }
    }
}

extension Settings.WordGeneration.Consonants {
    struct SoloQs: BRSetting {
        typealias Value = Bool
        static var key: String { "com.beebooapps.SillyWords.WordGeneration.Consonants.SoloQs" }
        static var initial: Value { false }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
    
    struct InitialDigraphs: BRSetting {
        typealias Value = Bool
        static var key: String { "com.beebooapps.SillyWords.WordGeneration.Consonants.InitialDigraphs" }
        static var initial: Value { false }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
    
    struct InitialDigraphBlends: BRSetting {
        typealias Value = Bool
        static var key: String { "com.beebooapps.SillyWords.WordGeneration.Consonants.InitialDigraphBlends" }
        static var initial: Value { false }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
    
    struct Initial2LetterBlends: BRSetting {
        typealias Value = Bool
        static var key: String { "com.beebooapps.SillyWords.WordGeneration.Consonants.Initial2LetterBlends" }
        static var initial: Value { false }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
        
    struct Initial3LetterBlends: BRSetting {
        typealias Value = Bool
        static var key: String { "com.beebooapps.SillyWords.WordGeneration.Consonants.Initial3LetterBlends" }
        static var initial: Value { false }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
    
    struct MiddleDigraphs: BRSetting {
        typealias Value = Bool
        static var key: String { "com.beebooapps.SillyWords.WordGeneration.Consonants.MiddleDigraphs" }
        static var initial: Value { false }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
    
    struct MiddleDigraphBlends: BRSetting {
        typealias Value = Bool
        static var key: String { "com.beebooapps.SillyWords.WordGeneration.Consonants.MiddleDigraphBlends" }
        static var initial: Value { false }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
    
    struct Middle2LetterBlends: BRSetting {
        typealias Value = Bool
        static var key: String { "com.beebooapps.SillyWords.WordGeneration.Consonants.Middle2LetterBlends" }
        static var initial: Value { false }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
        
    struct Middle3LetterBlends: BRSetting {
        typealias Value = Bool
        static var key: String { "com.beebooapps.SillyWords.WordGeneration.Consonants.Middle3LetterBlends" }
        static var initial: Value { false }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
    
    struct FinalDigraphs: BRSetting {
        typealias Value = Bool
        static var key: String { "com.beebooapps.SillyWords.WordGeneration.Consonants.FinalDigraphs" }
        static var initial: Value { false }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
    
    struct FinalDigraphBlends: BRSetting {
        typealias Value = Bool
        static var key: String { "com.beebooapps.SillyWords.WordGeneration.Consonants.FinalDigraphBlends" }
        static var initial: Value { false }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
    
    struct Final2LetterBlends: BRSetting {
        typealias Value = Bool
        static var key: String { "com.beebooapps.SillyWords.WordGeneration.Consonants.Final2LetterBlends" }
        static var initial: Value { false }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
        
    struct Final3LetterBlends: BRSetting {
        typealias Value = Bool
        static var key: String { "com.beebooapps.SillyWords.WordGeneration.Consonants.Final3LetterBlends" }
        static var initial: Value { false }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
}
