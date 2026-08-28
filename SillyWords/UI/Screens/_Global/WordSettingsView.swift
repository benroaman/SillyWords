//
//  WordSettingsView.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/28/26.
//

import SwiftUI

struct WordSettingsView<M: WordSettingsViewModel>: View {
    @State var model: M
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    WordSettingsView(model: WordSettingsViewModelPreview())}

protocol WordSettingsViewModel: AnyObject, Observable {
    var minSyllables: Int { get}
    var maxSyllables: Int { get}
    var allowVowelCombos: Bool { get }
    var allowsYAsVowel: Bool { get }
    var filterSortOfBadWords: Bool { get }
    var soloQs: Bool { get }
    var initialDigraphs: Bool { get }
    var initialDigraphBlends: Bool { get }
    var initial2LetterBlends: Bool { get }
    var initial3LetterBlends: Bool { get }
    var middleDigraphs: Bool { get }
    var middleDigraphBlends: Bool { get }
    var middle2LetterBlends: Bool { get }
    var middle3LetterBlends: Bool { get }
    var finalDigraphs: Bool { get }
    var finalDigraphBlends: Bool { get }
    var final2LetterBlends: Bool { get }
    var final3LetterBlends: Bool { get }
    var isFavorite: Bool { get }
    
    func onApplySettingsTap()
}

@Observable class WordSettingsViewModelPreview: WordSettingsViewModel {
    let minSyllables: Int = Int.random(in: 1...3)
    let maxSyllables: Int = Int.random(in: 3...5)
    let allowVowelCombos: Bool = Bool.random()
    let allowsYAsVowel: Bool = Bool.random()
    let filterSortOfBadWords: Bool = Bool.random()
    let soloQs: Bool = Bool.random()
    let initialDigraphs: Bool = Bool.random()
    let initialDigraphBlends: Bool = Bool.random()
    let initial2LetterBlends: Bool = Bool.random()
    let initial3LetterBlends: Bool = Bool.random()
    let middleDigraphs: Bool = Bool.random()
    let middleDigraphBlends: Bool = Bool.random()
    let middle2LetterBlends: Bool = Bool.random()
    let middle3LetterBlends: Bool = Bool.random()
    let finalDigraphs: Bool = Bool.random()
    let finalDigraphBlends: Bool = Bool.random()
    let final2LetterBlends: Bool = Bool.random()
    let final3LetterBlends: Bool = Bool.random()
    let isFavorite: Bool = Bool.random()
    
    func onApplySettingsTap() { print("APPLY SETTINGS") }
}
