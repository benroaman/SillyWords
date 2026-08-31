//
//  SettingsWordGenCurrentWordTransitionMenuView.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/23/26.
//

import SwiftUI

#warning("TODO: cleanup")
#warning("TODO: add demo videos")
struct SettingsWordGenCurrentWordTransitionMenuView<M: SettingsWordGenCurrentWordTransitionMenuViewModel>: View {
    @State var model: M
    
    var body: some View {
        List {
            ForEach(WordTransitionStyle.allCases) { style in
                Button(action: {
                    withAnimation() {
                        model.select(style: style)
                    }
                }, label: {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(style.displayName)
                                .font(Style.Settings.Font.optionTitle)
                            if style == model.selected {
                                Group {
                                    Spacer()
                                    Image(.checkmark)
                                        .font(Style.Settings.Icon.accessoryFont)
                                        .foregroundStyle(Theme.Selected.color)
                                }
                                .transition(.scale.animation(.bouncy(duration: 0.5, extraBounce: (style == model.selected ? 0.2 : 0))))
                            }
                        }
                    }
                })
                .contentShape(Rectangle())
                .tint(Style.Settings.Color.optionTitle)
            }
        }
        .sensoryFeedback(.selection, trigger: model.selected)
        .navigationTitle("Transition Style")
    }
}

#Preview {
    NavigationStack {
        SettingsWordGenCurrentWordTransitionMenuView(model: SettingsWordGenCurrentWordTransitionMenuViewModelPreview())
    }
}
