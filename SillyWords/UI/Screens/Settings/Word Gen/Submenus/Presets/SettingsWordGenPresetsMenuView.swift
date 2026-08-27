//
//  SettingsWordGenPresetsMenuView.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/26/26.
//

import SwiftUI

// MARK: Base
struct SettingsWordGenPresetsMenuView<M: SettingsWordGenPresetsMenuViewModel>: View {
    // MARK: Instance Variables - State
    @State var model: M
    
    static var transitionStyle: AnyTransition { .scale.combined(with: .opacity) }
    
    // MARK: Body
    var body: some View {
        List {
            ForEach(WordGenSettingsPreset.available) { preset in
                let isApplied = model.isPresetApplied(preset)
                VStack(alignment: .leading, spacing: Style.Settings.Spacing.optionTitleBottom) {
                    HStack {
                        Text(preset.displayName)
                            .font(Style.Settings.Font.optionTitle)
                            .foregroundStyle(Style.Settings.Color.optionTitle)
                        Spacer()
                        if isApplied {
                            Image(.checkmark)
                                .foregroundStyle(Style.Theme.Color.selected)
                                .font(Style.Settings.Icon.actionFont)
                                .transition(Self.transitionStyle)
                        } else {
                            Button(action: {
                                withAnimation {
                                    model.applyPreset(preset)
                                }
                            }, label: {
                                Text("Apply")
                                    .font(Style.Settings.Font.actionFont)
                            })
                            .tint(Style.Theme.Color.main)
                            .transition(Self.transitionStyle)
                            
                        }
                    }
                    SettingInfoView(wordGenPreset: preset)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    guard !isApplied else { return }
                    withAnimation {
                        model.applyPreset(preset)
                    }
                }
            }
        }
        .navigationTitle("Word Gen Presets")
    }
}

// MARK: Previews
#Preview {
    SettingsWordGenPresetsMenuView(model: SettingsWordGenPresetsMenuViewModelPreview())
}

