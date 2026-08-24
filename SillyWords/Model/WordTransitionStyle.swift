//
//  WordGenTransitionStyle.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/23/26.
//

import Foundation

enum WordTransitionStyle: Int, CaseIterable {
    case crossfade
    case splode
    
    var displayName: String {
        switch self {
        case .crossfade: return "Crossfade"
        case .splode: return "'Splode"
        }
    }
}

extension WordTransitionStyle: Identifiable {
    var id: Int { rawValue }
}
