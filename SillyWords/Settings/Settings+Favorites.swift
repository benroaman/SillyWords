//
//  Settings+Favorites.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/3/26.
//

import Foundation
import Combine

extension Settings {
    struct Favorites {
        private init() { }
    }
}

extension Settings.Favorites {
    struct Favorites: BRSetting {
        typealias Value = [Favorite]
        static var key: String { "com.beebooapps.SillyWords.Favorites.Favorites" }
        static var initial: Value { [] }
        static let pub: CurrentValueSubject<Value, Never> = .init(current)
    }
}
