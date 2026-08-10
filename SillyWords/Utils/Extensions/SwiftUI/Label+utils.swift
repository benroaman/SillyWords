//
//  Label+utils.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/6/26.
//

import SwiftUI

extension Label where Icon == Image, Title == Text {
    init(title: String, symbol: SFSymbol) {
        self.init(title: {
            Text(title)
        }, icon: {
            Image(symbol)
        })
    }
}
