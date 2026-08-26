//
//  Telemetry+Errors.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/24/26.
//

import Foundation

extension Telemetry {
    enum NavFlow: String {
        case wordGenTab
        case favoritesTab
        case settingsTab
    }
    
    static func trackUnsupportedMainRoute(_ route: MainRoute, in flow: NavFlow) {
        track(.badRoute, attributes: [
            .route: route.telemetryName,
            .flow: flow
        ])
    }
    
    static func trackDatabaseError(_ error: DatabaseError) {
        var attributes: [Attribute: Any] = [.category: error.category]
        
        let identity = error.identity
        attributes[.code] = identity.code
        attributes[.operation] = identity.operation.rawValue
        attributes[.caller] = identity.caller.rawValue
        
        if let info = error.info {
            attributes[.description] = info.description
            attributes[.reason] = info.reason
            attributes[.suggestion] = info.suggestion
            attributes[.underlyingCode] = info.underlyingCode
            attributes[.underlyingDescription] = info.underlyingDescription
            attributes[.underlyingReason] = info.underlyingReason
            attributes[.underlyingSuggestion] = info.underlyingSuggestion
        }
        
        if let validation = error.validation {
            attributes[.validationKey] = validation.validationKey
            attributes[.validationValue] = validation.validationValue
            attributes[.validationPredicate] = validation.validationPredicate
        }
        
        track(.databaseError, attributes: attributes)
    }
}
