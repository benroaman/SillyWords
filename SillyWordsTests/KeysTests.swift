//
//  KeysTests.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/29/26.
//

import Testing
import UIKit

@Suite("Keys Tests")
class KeysTests {
    private var keys: NSDictionary?
    
    init() throws {
        guard let path = Bundle.main.path(forResource: KeyKeys.filename, ofType: KeyKeys.fileExtension),
              let keys = NSDictionary(contentsOfFile: path) else {
            return
        }
        self.keys = keys
    }
    
    deinit {
        self.keys = nil
    }
    
    @Test("Mixpanel Project Token")
    func mixpanelProjectToken() {
        #expect(keys != nil)
        let token = keys?[KeyKeys.mixpanelProjectToken] as? String
        #expect(token != nil)
    }
}
