//
//  FavoritesTabNavigation.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/21/26.
//

import Foundation

// MARK: Requirements
protocol FavoritesTabNavigation: AnyObject, Observable, EmailNavigation {
    var favoritesTabRouter: Router<MainRoute> { get set }
}

// MARK: Preview Implementation
@Observable class FavoritesTabNavigationPreview: FavoritesTabNavigation {
    var favoritesTabRouter: Router<MainRoute> = .init()
    var presentedEmail: Email?
}
