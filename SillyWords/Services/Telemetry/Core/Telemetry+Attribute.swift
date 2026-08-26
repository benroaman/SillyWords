//
//  Telemetry+Attribute.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/24/26.
//

import Foundation

extension Telemetry {
    enum Attribute: String {
        case description
        case route
        case flow
        case word
        case context
        
        case category
        case code
        case caller
        case operation
        case reason
        case suggestion
        case underlyingCode
        case underlyingDescription
        case underlyingReason
        case underlyingSuggestion
        case validationKey
        case validationValue
        case validationPredicate
    }
}

extension Telemetry.Attribute {
    var key: String { rawValue }
}
