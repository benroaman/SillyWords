//
//  Telemetry+Event.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/24/26.
//

import Foundation

extension Telemetry {
    enum Event: String {
        /// Errors
        case databaseError
        case badRoute
        
        /// User Action - Word Gen
        case createWord
        case createSentence
        
        /// User Action - Favorites
        case addFavorite
        case removeFavorite
        case clearFavorites
    }
}

extension Telemetry.Event {
    var name: String { rawValue }
}
