//
//  WordGenSettingsPreset.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/26/26.
//

import Foundation
import BRWordGeneration

enum WordGenSettingsPreset: Int, Identifiable {
    case simple
    case moderate
    case complex
    case scifi
    
    var id: Int { rawValue }
    
    static var available: [Self] { [.simple, .moderate, .complex, .scifi] }
    
    var displayName: String {
        switch self {
        case .simple: "Simple"
        case .moderate: "Moderate"
        case .complex: "Complex"
        case .scifi: "Science Fiction"
        }
    }
    
    var description: String {
        switch self {
        case .simple: "2 syllables, no blends or digraphs"
        case .moderate: "2 - 3 syllables, some blends and digraphs"
        case .complex: "3 - 4, more blends and digraphs"
        case .scifi: "2-5 syllables, all blends, digraphs, and all the weird stuff"
        }
    }
    
    var example: String {
        switch self {
        case .simple:
            """
            e.g. "bekag", "asok"
            """
        case .moderate:
            """
            e.g. "izejalt", "thalopt"
            """
        case .complex:
            """
            e.g. "quetakiwa", "gonctiwa"
            """
        case .scifi:
            """
            e.g. "swyntritu", "orchuplascamai"
            """
        }
    }
        
    var settings: BRWordGenerationSettings {
        switch self {
        case .simple:
                .init(
                    minSyllables: 2,
                    maxSyllables: 2,
                    allowVowelCombos: false,
                    allowsYAsVowel: false,
                    filterSortOfBadWords: true,
                    soloQs: false,
                    initialDigraphs: false,
                    initialDigraphBlends: false,
                    initial2LetterBlends: false,
                    initial3LetterBlends: false,
                    middleDigraphs: false,
                    middleDigraphBlends: false,
                    middle2LetterBlends: false,
                    middle3LetterBlends: false,
                    finalDigraphs: false,
                    finalDigraphBlends: false,
                    final2LetterBlends: false,
                    final3LetterBlends: false
                )
        case .moderate:
                .init(
                    minSyllables: 2,
                    maxSyllables: 3,
                    allowVowelCombos: true,
                    allowsYAsVowel: false,
                    filterSortOfBadWords: true,
                    soloQs: false,
                    initialDigraphs: true,
                    initialDigraphBlends: false,
                    initial2LetterBlends: false,
                    initial3LetterBlends: false,
                    middleDigraphs: false,
                    middleDigraphBlends: false,
                    middle2LetterBlends: true,
                    middle3LetterBlends: false,
                    finalDigraphs: false,
                    finalDigraphBlends: false,
                    final2LetterBlends: true,
                    final3LetterBlends: false
                )
        case .complex:
                .init(
                    minSyllables: 3,
                    maxSyllables: 4,
                    allowVowelCombos: true,
                    allowsYAsVowel: false,
                    filterSortOfBadWords: true,
                    soloQs: false,
                    initialDigraphs: true,
                    initialDigraphBlends: true,
                    initial2LetterBlends: true,
                    initial3LetterBlends: false,
                    middleDigraphs: true,
                    middleDigraphBlends: false,
                    middle2LetterBlends: true,
                    middle3LetterBlends: true,
                    finalDigraphs: true,
                    finalDigraphBlends: false,
                    final2LetterBlends: true,
                    final3LetterBlends: false
                )
        case .scifi:
                .init(
                    minSyllables: 2,
                    maxSyllables: 5,
                    allowVowelCombos: true,
                    allowsYAsVowel: true,
                    filterSortOfBadWords: true,
                    soloQs: true,
                    initialDigraphs: true,
                    initialDigraphBlends: true,
                    initial2LetterBlends: true,
                    initial3LetterBlends: true,
                    middleDigraphs: true,
                    middleDigraphBlends: true,
                    middle2LetterBlends: true,
                    middle3LetterBlends: true,
                    finalDigraphs: true,
                    finalDigraphBlends: true,
                    final2LetterBlends: true,
                    final3LetterBlends: true
                )
        }
    }
}
