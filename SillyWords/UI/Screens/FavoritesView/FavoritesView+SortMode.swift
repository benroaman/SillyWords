//
//  FavoritesView+SortMode.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/6/26.
//

import Foundation

extension FavoritesView {
    enum SortMode: CaseIterable {
        case alpha
        case date
        
        var icon: SFSymbol {
            switch self {
            case .alpha: .charactersUppercase
            case .date: .calendar
            }
        }
    }
}
