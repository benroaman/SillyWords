//
//  Favorite.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/3/26.
//

import Foundation

struct Favorite: Hashable, Equatable, Codable {
    let word: String
    let dateCreated: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(word)
    }
    
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.word == rhs.word
    }
}

// MARK: Mock Values
extension Favorite {
    static var mock1: Self { .init(word: "Okaydokay", dateCreated: Date()) }
}
