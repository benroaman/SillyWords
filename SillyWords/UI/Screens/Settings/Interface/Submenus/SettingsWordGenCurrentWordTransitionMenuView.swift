//
//  SettingsWordGenCurrentWordTransitionMenuView.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/23/26.
//

import SwiftUI

struct SettingsWordGenCurrentWordTransitionMenuView<M: SettingsWordGenCurrentWordTransitionMenuViewModel>: View {
    @State var model: M
    
    var body: some View {
        List {
            ForEach(WordTransitionStyle.allCases) { style in
                Button(action: {
                    withAnimation(/*.bouncy(duration: 0.5, extraBounce: 0.2)*/) {
                        model.select(style: style)
                    }
                }, label: {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(style.displayName)
                                .font(.headline)
                            if style == model.selected {
                                Group {
                                    Spacer()
                                    Image(.checkmark)
                                        .font(.headline)
                                        .foregroundStyle(.green)
                                }
                                .transition(.scale.animation(.bouncy(duration: 0.5, extraBounce: (style == model.selected ? 0.2 : 0))))
                            }
                        }
                    }
                })
                .contentShape(Rectangle())
                .tint(.primary)
            }
//            .animation(.default, value: model.selected)
        }
        .sensoryFeedback(.selection, trigger: model.selected)
        .navigationTitle("Transition Style")
    }
}

protocol SettingsWordGenCurrentWordTransitionMenuViewModel: AnyObject, Observable {
    var selected: WordTransitionStyle { get }
    func select(style: WordTransitionStyle)
}

@Observable class SettingsWordGenCurrentWordTransitionMenuViewModelPreview: SettingsWordGenCurrentWordTransitionMenuViewModel {
    @MainActor private(set) var selected: WordTransitionStyle = .splode
    func select(style: WordTransitionStyle) {
        selected = style
    }
}

@Observable class SettingsWordGenCurrentWordTransitionMenuViewModelProd: SettingsWordGenCurrentWordTransitionMenuViewModel {
    private let settings: SettingsManager
    
    init(settings: SettingsManager) {
        self.settings = settings
    }
    
    var selected: WordTransitionStyle { settings.wordGenCurrentWordTransitionStyle }
    func select(style: WordTransitionStyle) { settings.wordGenCurrentWordTransitionStyle = style }
}

#Preview {
    NavigationStack {
        SettingsWordGenCurrentWordTransitionMenuView(model: SettingsWordGenCurrentWordTransitionMenuViewModelPreview())
    }
}
