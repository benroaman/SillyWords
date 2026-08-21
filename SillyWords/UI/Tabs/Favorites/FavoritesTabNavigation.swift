//
//  FavoritesTabNavigation.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/21/26.
//

import Foundation

protocol FavoritesTabNavigation: AnyObject, Observable {
    var favoritesTabRouter: Router<MainRoute> { get set }
    var presentedEmail: Email? { get set }
}

@Observable class FavoritesTabNavigationPreview: FavoritesTabNavigation {
    var favoritesTabRouter: Router<MainRoute> = .init()
    var presentedEmail: Email?
}
