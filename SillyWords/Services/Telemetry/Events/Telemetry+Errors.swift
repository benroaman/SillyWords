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
    
    static func reportUnsupportedMainRoute(_ route: MainRoute, in flow: NavFlow) {
        track(.badRoute, attributes: [
            .route: route.telemetryName,
            .flow: flow
        ])
    }
    
    static func trackDatabaseError(_ error: DatabaseError) {
        track(.databaseError, attributes: [
            .category: error.name,
            .description: error.description
        ])
    }
}
