//
//  String+utils.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/27/26.
//

import Foundation

extension String {
    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
