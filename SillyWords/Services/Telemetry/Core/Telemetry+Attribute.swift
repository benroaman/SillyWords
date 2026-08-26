//
//  Telemetry+Attribute.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/24/26.
//

import Foundation

extension Telemetry {
    enum Attribute: String {
        case category
        case description
        case route
        case flow
        case word
        case context
        case code
    }
}

extension Telemetry.Attribute {
    var key: String { rawValue }
}
