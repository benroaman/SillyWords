//
//  TabIterable.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/19/26.
//

import Foundation

protocol TabIterable: RawRepresentable, Identifiable {
    var icon: SFSymbol { get }
    var title: String { get }
    static var available: [Self] { get }
}

