//
//  SettingInput.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/3/26.
//

import Foundation

enum SettingInput {
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
    
    var description: String? {
        switch self {
        case .minSyllables: "The minimum number of syllables in generated words"
        case .maxSyllables: "The maximum number of syllables in generated words"
        case .allowVowelCombos: "e.g. \"ou\", \"ea\""
        case .allowYAsVowel: nil
        case .filterSortOfBadWords: "Truly bad words like \"f%#&\" are always filtered out, \"sort of\" bad words include \"poop\""
        case .soloQs: "Allow \"Q\"s that are not followed by a \"U\""
        case .initialDigraphs: "Allow words to start with consonant digraphs"
        case .initialDigraphBlends: "Allow words to start with consonant digraph blends"
        case .initial2LetterBlends: "Allow words to start with two consonant blends"
        case .initial3LetterBlends: "Allow words to start with three consonant blends"
        case .middleDigraphs: "Allow consonant digraphs to appear in the middle of words"
        case .middleDigraphBlends: "Allow consonant digraph blends to appear in the middle of words"
        case .middle2LetterBlends: "Allow two consonant blends to appear in the middle of words"
        case .middle3LetterBlends: "Allow three letter consonant blends to appear in the middle of words"
        case .finalDigraphs: "Allow words to end with consonant digraphs"
        case .finalDigraphBlends: "Allow words to end with consonant digraph blends"
        case .final2LetterBlends: "Allow words to end with two consonant blends"
        case .final3LetterBlends: "Allow words to end with three consonant blends"
        }
    }
}
