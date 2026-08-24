//
//  Telemetry+Event.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/24/26.
//

import Foundation

extension Telemetry {
    enum Event: String {
        case databaseError
    }
}

extension Telemetry.Event {
    var name: String { rawValue }
}
