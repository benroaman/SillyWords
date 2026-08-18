//
//  FavoritesView+SortMode.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/6/26.
//

import Foundation
import CoreData

extension FavoritesView {
    enum SortMode: CaseIterable {
        case alpha
        case mostRecent
//        case highestRated
        
        var icon: SFSymbol {
            switch self {
            case .alpha: .charactersUppercase
            case .mostRecent: .calendar
//            case .highestRated: .star
            }
        }
        
        var favoriteSortOrder: SortOrder {
            switch self {
            case .alpha: .forward
            case .mostRecent: .reverse
//            case .highestRated: .reverse
            }
        }
        
        var favoriteSortDescriptors: [SortDescriptor<Flavorite>] {
            switch self {
            case .alpha: [SortDescriptor(\Flavorite.word, order: favoriteSortOrder)]
            case .mostRecent: [SortDescriptor(\Flavorite.dateAdded, order: favoriteSortOrder)]
//            case .highestRated: [SortDescriptor(\Flavorite.rating, order: favoriteSortOrder)]
            }
        }
    }
}
