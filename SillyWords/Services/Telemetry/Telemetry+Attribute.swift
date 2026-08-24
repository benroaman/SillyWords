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
    }
}

extension Telemetry.Attribute {
    var key: String { rawValue }
}
