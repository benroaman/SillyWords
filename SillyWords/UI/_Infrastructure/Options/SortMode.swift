//
//  SortMode.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/6/26.
//

import Foundation
import CoreData

enum SortMode: Int, CaseIterable {
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
    
    var favoriteSortDescriptors: [SortDescriptor<Word>] {
        switch self {
        case .alpha: [SortDescriptor(\Word.text, order: favoriteSortOrder)]
        case .mostRecent: [SortDescriptor(\Word.dateAdded, order: favoriteSortOrder)]
//            case .highestRated: [SortDescriptor(\Favorite.rating, order: favoriteSortOrder)]
        }
    }
}
