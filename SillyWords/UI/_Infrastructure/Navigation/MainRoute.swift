//
//  MainRoute.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/19/26.
//

import Foundation
import CoreData

enum MainRoute: Hashable {
    case settingsWordGen
    case settingsFavorites
    case settingsSyllables
    case settingsConsonants
    case settingsVowels
    case settingsUserInterface
    case settingsWordGenCurrentWordTransition
    case settingsSentences
    case historyList
    case favoriteWordDetail(Favorite)
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .settingsWordGen: hasher.combine(0)
        case .settingsFavorites: hasher.combine(1)
        case .settingsSyllables: hasher.combine(2)
        case .settingsConsonants: hasher.combine(3)
        case .settingsVowels: hasher.combine(4)
        case .historyList: hasher.combine(5)
        case .favoriteWordDetail(let favorite): hasher.combine(6 + favorite.objectID.hashValue)
        case .settingsUserInterface: hasher.combine(7)
        case .settingsWordGenCurrentWordTransition: hasher.combine(8)
        case .settingsSentences: hasher.combine(9)
        }
    }
    
    var description: String {
        switch self {
        case .settingsWordGen: "settingsWordGen"
        case .settingsFavorites: "settingsFavorites"
        case .settingsSyllables: "settingsSyllables"
        case .settingsConsonants: "settingsConsonants"
        case .settingsVowels: "settingsVowels"
        case .historyList: "historyList"
        case .favoriteWordDetail: "favoriteWordDetail"
        case .settingsUserInterface: "settingsUserInterface"
        case .settingsWordGenCurrentWordTransition: "settingsWordGenCurrentWordTransition"
        case .settingsSentences: "settingsSentences"
        }
    }
    
    var telemetryName: String {
        switch self {
        case .settingsWordGen: "settingsWordGen"
        case .settingsFavorites: "settingsFavorites"
        case .settingsSyllables: "settingsSyllables"
        case .settingsConsonants: "settingsConsonants"
        case .settingsVowels: "settingsVowels"
        case .historyList: "historyList"
        case .favoriteWordDetail: "favoriteWordDetail"
        case .settingsUserInterface: "settingsUserInterface"
        case .settingsWordGenCurrentWordTransition: "settingsWordGenCurrentWordTransition"
        case .settingsSentences: "settingsSentences"
        }
    }
    
    public static func == (lhs: MainRoute, rhs: MainRoute) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
