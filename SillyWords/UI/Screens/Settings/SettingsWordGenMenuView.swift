//
//  SettingsWordGenMenuView.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/14/26.
//

import SwiftUI

struct SettingsWordGenMenuView<M: SettingsWordGenMenuViewModel>: View {
    @State var model: M
    
    var body: some View {
        List(SettingsWordGenMenuOption.allCases, id: \.self) { option in
            Button(action: {
                model.settingsWordGenMenuDoSelectOption(option)
            }, label: {
                SettingsSimpleMenuRow(option: option)
            })
        }
        .navigationTitle("Word Generation")
    }
}

enum SettingsWordGenMenuOption: Int, SettingsSimpleMenuRowOption, CaseIterable {
    case syllables
    case vowels
    case consonants
    
    var title: String {
        switch self {
        case .syllables: "Syllables"
        case .vowels: "Vowels"
        case .consonants: "Consonants"
        }
    }
    
    var icon: SFSymbol {
        switch self {
        case .syllables: .ruler
        case .vowels: .aCircle
        case .consonants: .bCircle
        }
    }
    
    var iconColor: Color {
        Style.Color.wordGenerateTheme
    }
    
    var accessory: SFSymbol? {
        .chevronRight
    }
}

protocol SettingsWordGenMenuViewModel {
    func settingsWordGenMenuDoSelectOption(_ option: SettingsWordGenMenuOption)
}

#Preview {
    SettingsWordGenMenuView(model: MockSettingsWordGenMenuViewModel())
}

fileprivate class MockSettingsWordGenMenuViewModel: SettingsWordGenMenuViewModel {
    func settingsWordGenMenuDoSelectOption(_ option: SettingsWordGenMenuOption) { print("\(option.title) SELECTED") }
}
