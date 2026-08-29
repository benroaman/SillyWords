//
//  AssetTests.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/29/26.
//

import Testing
import UIKit

@Suite("Asset Tests")
struct AssetTests {
    @Test("SFSymbols", arguments: SFSymbol.allCases)
    func sfSymbols(_ symbol: SFSymbol) {
        #expect(UIImage(systemName: symbol.rawValue) != nil)
    }
}
