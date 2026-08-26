//
//  Telemetry+WordGen.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/24/26.
//

import Foundation

extension Telemetry {
    static func trackCreateWord() {
        track(.createWord)
    }
}
