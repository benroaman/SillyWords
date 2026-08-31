//
//  MainRoute.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/19/26.
//

import Foundation
import CoreData

// MARK: Base
enum MainRoute {
    case settingsWordGen
    case settingsFavorites
    case settingsSyllables
    case settingsConsonants
    case settingsVowels
    case settingsUserInterface
    case settingsWordGenCurrentWordTransition
    case settingsSentences
    case settingsWordGenPresets
    case historyList
    case wordDetail(Favorite)
}

// MARK: Values
extension MainRoute {
    var description: String {
        switch self {
        case .settingsWordGen: "Word Gen Settings"
        case .settingsFavorites: "Favorites Settings"
        case .settingsSyllables: "Syllable Settings"
        case .settingsConsonants: "Consonant Settings"
        case .settingsVowels: "Vowel Settings"
        case .historyList: "Word History"
        case .wordDetail: "Word Detail"
        case .settingsUserInterface: "UI Settings"
        case .settingsWordGenCurrentWordTransition: "Word Gen Current Word Transition Settings"
        case .settingsSentences: "Sentence Settings"
        case .settingsWordGenPresets: "Word Gen Presets Settings"
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
        case .wordDetail: "wordDetail"
        case .settingsUserInterface: "settingsUserInterface"
        case .settingsWordGenCurrentWordTransition: "settingsWordGenCurrentWordTransition"
        case .settingsSentences: "settingsSentences"
        case .settingsWordGenPresets: "settingsWordGenPresets"
        }
    }
}

// MARK: Hashable Conformance
extension MainRoute: Hashable {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .settingsWordGen: hasher.combine(0)
        case .settingsFavorites: hasher.combine(1)
        case .settingsSyllables: hasher.combine(2)
        case .settingsConsonants: hasher.combine(3)
        case .settingsVowels: hasher.combine(4)
        case .historyList: hasher.combine(5)
        case .wordDetail(let favorite): hasher.combine(6 + favorite.objectID.hashValue)
        case .settingsUserInterface: hasher.combine(7)
        case .settingsWordGenCurrentWordTransition: hasher.combine(8)
        case .settingsSentences: hasher.combine(9)
        case .settingsWordGenPresets: hasher.combine(10)
        }
    }
}
