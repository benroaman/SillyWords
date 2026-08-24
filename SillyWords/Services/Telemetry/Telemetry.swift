//
//  Telemetry.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/20/26.
//

import Foundation
import Mixpanel

// MARK: Base
struct Telemetry {
    private init() { }
    
    @MainActor private static var initialized = false
    
    static func initialize() {
        guard let path = Bundle.main.path(forResource: KeyKeys.filename, ofType: KeyKeys.fileExtension),
              let keys = NSDictionary(contentsOfFile: path),
              let token = keys[KeyKeys.mixpanelProjectToken] as? String else {
            return
        }
        guard !initialized else { return }
        
        initialized = true
        
        let options = MixpanelOptions(token: token)
        Mixpanel.initialize(options: options)
        
        #if DEBUG
        Mixpanel.mainInstance().loggingEnabled = true
        Mixpanel.mainInstance().registerSuperPropertiesOnce([SuperProperties.environment: "dev"])
        #else
        Mixpanel.mainInstance().registerSuperPropertiesOnce([SuperProperties.environment: "live"])
        Mixpanel.mainInstance().loggingEnabled = false
        #endif
    }
    
    private struct SuperProperties {
        private init() { }
        static let environment: String = "environment"
    }
}

// MARK: Tracking
extension Telemetry {
    static func track(_ event: Event, attributes: [Attribute: Any] = [:]) {
        Mixpanel.mainInstance().track(event: event.name, properties: mapToMixpanelProperties(attributes))
    }
    
    private static func mapToMixpanelProperties(_ attributes: [Attribute: Any]) -> Properties {
        var result = Properties()
        for key in attributes.keys {
            guard let value = attributes[key] as? MixpanelType else { continue }
            result[key.key] = value
        }
        return result
    }
}

extension Telemetry {
    static func reportUnsupportedMainRoute(_ route: MainRoute) {
        #warning("TODO:")
    }
    
    static func reportDatabaseError(_ error: DatabaseError) {
        track(.databaseError, attributes: [.category: "", .description: error.description])
    }
}
