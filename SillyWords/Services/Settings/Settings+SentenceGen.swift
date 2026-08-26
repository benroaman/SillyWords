//
//  Settings+SentenceGen.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/26/26.
//

import Foundation
import Combine

extension Settings {
    struct SentenceGen {
        private init() { }
    }
}

extension Settings.SentenceGen {
    struct IncludeAttribution: BRSetting {
        typealias Value = Bool
        static var key: String { "com.beebooapps.SillyWords.SentenceGen.IncludeAttribution" }
        static var initial: Value { true }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
    
    struct SentenceOnMainScreen: BRSetting {
        typealias Value = Bool
        static var key: String { "com.beebooapps.SillyWords.SentenceGen.SentenceOnMainScreen" }
        static var initial: Value { true }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
}
