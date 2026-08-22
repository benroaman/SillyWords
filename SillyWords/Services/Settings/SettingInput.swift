//
//  SettingInput.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/3/26.
//

import Foundation

enum SettingInput: CaseIterable {
    // Syllables
    case minSyllables
    case maxSyllables
    
    // Vowels
    case allowVowelCombos
    case allowYAsVowel
    
    // Censoring
    case filterSortOfBadWords
    
    // Consonants
    case soloQs
    case initialDigraphs
    case initialDigraphBlends
    case initial2LetterBlends
    case initial3LetterBlends
    case middleDigraphs
    case middleDigraphBlends
    case middle2LetterBlends
    case middle3LetterBlends
    case finalDigraphs
    case finalDigraphBlends
    case final2LetterBlends
    case final3LetterBlends
}

extension SettingInput {
    var title: String {
        switch self {
        case .minSyllables: "Minimum Syllables"
        case .maxSyllables: "Maximum Syllables"
        case .allowVowelCombos: "Vowel Combos"
        case .allowYAsVowel: "Y As Vowel"
        case .filterSortOfBadWords: "Filter \"Sort Of\" Bad Words"
        case .soloQs: "Solo \"Q\"s"
        case .initialDigraphs: "Initial Consonant Digraphs"
        case .initialDigraphBlends: "Initial Consonant Digraph Blends"
        case .initial2LetterBlends: "Initial Two Letter Blends"
        case .initial3LetterBlends: "Initial Three Letter Blends"
        case .middleDigraphs: "Middle Consonant Digraphs"
        case .middleDigraphBlends: "Middle Consonant Digraph Blends"
        case .middle2LetterBlends: "Middle Two Letter Blends"
        case .middle3LetterBlends: "Middle Three Letter Blends"
        case .finalDigraphs: "Final Consonant Digraphs"
        case .finalDigraphBlends: "Final Consonant Digraph Blends"
        case .final2LetterBlends: "Final Two Letter Blends"
        case .final3LetterBlends: "Final Three Letter Blends"
        }
    }
    
    #warning("TODO: Start/End with vowel combos")
    var description: String? {
        switch self {
        case .minSyllables: "The least syllables in a word"
        case .maxSyllables: "The most syllables in a word"
        case .allowVowelCombos: "Words can contain vowel combos"
        case .allowYAsVowel:
            """
            "Y"s can appear as a vowel mid-word
            """
        case .filterSortOfBadWords:
            """
            Truly bad words like "f%#&" are always filtered out, "sort of" bad words include "poop"
            """
        case .soloQs:
            """
            Allow "Q"s that are not followed by a "U"
            """
        case .initialDigraphs: "Allow words to start with consonant digraphs"
        case .initialDigraphBlends: "Words can start with consonant digraph blends"
        case .initial2LetterBlends: "Words can start with two consonant blends"
        case .initial3LetterBlends: "Words can start with three consonant blends"
        case .middleDigraphs: "Consonant digraphs can appear in the middle of words"
        case .middleDigraphBlends: "Consonant digraph blends can appear in the middle of words"
        case .middle2LetterBlends: "Two consonant blends can appear in the middle of words"
        case .middle3LetterBlends: "Three letter consonant blends can appear in the middle of words"
        case .finalDigraphs: "Words can end with consonant digraphs"
        case .finalDigraphBlends: "Words can end with consonant digraph blends"
        case .final2LetterBlends: "Words can end with two consonant blends"
        case .final3LetterBlends: "Words can end with three consonant blends"
        }
    }
    
    var example: String? {
        switch self {
        case .minSyllables, .maxSyllables, .filterSortOfBadWords: nil
        case .allowVowelCombos:
            """
            e.g. "ea", "ou"
            """
        case .allowYAsVowel:
            """
            as in "glyph" and "rhythm"
            """
        case .soloQs:
            """
            as in "niqab"
            """
        case .initialDigraphs:
            """
            e.g. "th", "sh"
            """
        case .initialDigraphBlends:
            """
            e.g. "shr", "thr"
            """
        case .initial2LetterBlends:
            """
            e.g. "bl", "cr", "st"
            """
        case .initial3LetterBlends:
            """
            e.g. "scr", "spl"
            """
        case .middleDigraphs:
            """
            e.g. "ph", "ng"
            """
        case .middleDigraphBlends:
            """
            e.g. "thr", "nch"
            """
        case .middle2LetterBlends:
            """
            e.g. "cl", "fr", "sk"
            """
        case .middle3LetterBlends:
            """
            e.g. "ndr", "str"
            """
        case .finalDigraphs:
            """
            e.g. "ck", "ch"
            """
        case .finalDigraphBlends:
            """
            e.g. "nch", "tch"
            """
        case .final2LetterBlends:
            """
            e.g. "nd", "lf"
            """
        case .final3LetterBlends:
            """
            e.g. "mpt", "lpt"
            """
        }
    }
}
