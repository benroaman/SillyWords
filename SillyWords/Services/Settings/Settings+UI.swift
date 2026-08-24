//
//  Settings+UI.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/23/26.
//

import Foundation
import Combine

extension Settings {
    struct UserInterface {
        private init() { }
    }
}

extension Settings.UserInterface {
    struct WordGenCurrentWordTransitionStyle: BRSetting {
        typealias Value = WordTransitionStyle
        static var key: String { "com.beebooapps.SillyWords.UserInterface.WordGenCurrentWordTransitionStyle" }
        static var initial: Value { .splode }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
}
