//
//  SettingsTabNavigation.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/22/26.
//

import Foundation

protocol SettingsTabNavigation: AnyObject, Observable, EmailNavigation {
    var settingsTabRouter: Router<MainRoute> { get set }
}

@Observable class SettingsTabNavigationPreview: SettingsTabNavigation {
    var settingsTabRouter: Router<MainRoute> = .init()
    var presentedEmail: Email?
}
