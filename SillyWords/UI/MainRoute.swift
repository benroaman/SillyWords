//
//  MainRoute.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/19/26.
//

import Foundation
import CoreData

enum MainRoute: Hashable {
    case settingsWordGeneration
    case settingsFavorites
    case settingsSyllables
    case settingsConsonants
    case settingsVowels
    case historyList
    case favoriteWordDetail(Favorite)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .settingsWordGeneration: hasher.combine(0)
        case .settingsFavorites: hasher.combine(1)
        case .settingsSyllables: hasher.combine(2)
        case .settingsConsonants: hasher.combine(3)
        case .settingsVowels: hasher.combine(4)
        case .historyList: hasher.combine(5)
        case .favoriteWordDetail(let favorite): hasher.combine(6 + favorite.objectID.hashValue)
        }
    }
    
    public static func == (lhs: MainRoute, rhs: MainRoute) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
