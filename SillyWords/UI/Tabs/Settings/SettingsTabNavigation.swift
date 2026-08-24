//
//  SettingsTabNavigation.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/22/26.
//

import Foundation

// MARK: Requirements
protocol SettingsTabNavigation: AnyObject, Observable, EmailNavigation {
    var settingsTabRouter: Router<MainRoute> { get set }
}

// MARK: Preview Implementation
@Observable class SettingsTabNavigationPreview: SettingsTabNavigation {
    var settingsTabRouter: Router<MainRoute> = .init()
    var presentedEmail: Email?
}
