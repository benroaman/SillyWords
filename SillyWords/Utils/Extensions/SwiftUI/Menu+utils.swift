//
//  Menu+utils.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/6/26.
//

import SwiftUI

extension Menu where Label == SwiftUI.Label<Text, Image> {
    init(_ symbol: SFSymbol, @ViewBuilder content: () -> Content) {
        self.init("", systemImage: symbol.rawValue, content: content)
    }
    
    init(_ title: LocalizedStringKey, symbol: SFSymbol, @ViewBuilder content: () -> Content) {
        self.init(title, systemImage: symbol.rawValue, content: content)
    }
}
