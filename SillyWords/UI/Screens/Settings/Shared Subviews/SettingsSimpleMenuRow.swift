//
//  SettingsSimpleMenuRow.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/15/26.
//

import SwiftUI

struct SettingsSimpleMenuRow<O: SettingsSimpleMenuRowOption>: View {
    let option: O
    let value: String?
    
    init(option: O, value: String? = nil) {
        self.option = option
        self.value = value
    }
    
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
            if let accessory = option.accessory {
                Image(accessory)
                    .tint(.secondary)
                    .fixedSize()
            }
        }
    }
}

protocol SettingsSimpleMenuRowOption {
    var title: String { get }
    var icon: SFSymbol { get }
    var iconColor: Color { get }
    var accessory: SFSymbol? { get }
}
