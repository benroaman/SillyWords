//
//  SettingsSimpleMenuRow.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/15/26.
//

import SwiftUI

// MARK: Base
struct SettingsSimpleMenuRow<O: SettingsSimpleMenuRowOption>: View {
    // MARK: Instance Constants
    let option: O
    let value: String?
    
    // MARK: Initializers
    init(option: O, value: String? = nil) {
        self.option = option
        self.value = value
    }
    
    // MARK: Body
    var body: some View {
        HStack {
            Label(title: {
                Text(option.title)
                    .tint(.primary)
            }, icon: {
                Image(option.icon)
                    .foregroundStyle(option.iconColor)
                    .fontWeight(.medium)
            })
            Spacer()
            if let value {
                Text(value)
                    .foregroundColor(.secondary)
            }
            #warning("TODO: fix issue where value hides accessory")
            if let accessory = option.accessory {
                Image(accessory)
                    .tint(.secondary)
                    .fixedSize()
            }
        }
    }
}

// MARK: Support Types
protocol SettingsSimpleMenuRowOption {
    var title: String { get }
    var icon: SFSymbol { get }
    var iconColor: Color { get }
    var accessory: SFSymbol? { get }
}

// MARK: Previews
#Preview {
    List {
        SettingsSimpleMenuRow(option: SettingsMainMenuOption.favorites)
        SettingsSimpleMenuRow(option: SettingsMainMenuOption.userInterface, value: "5")
    }
}
