//
//  WordGenTabNavigation.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/24/26.
//

import Foundation

// MARK: Requirements
protocol WordGenTabNavigation: AnyObject, Observable, EmailNavigation {
    var wordGenTabRouter: Router<MainRoute> { get set }
}

// MARK: Preview Implementation
@Observable class WordGenTabNavigationPreview: WordGenTabNavigation {
    var wordGenTabRouter: Router<MainRoute> = .init()
    var presentedEmail: Email?
}
