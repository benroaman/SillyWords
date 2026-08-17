//
//  DispatchQueue+utils.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/17/26.
//

import Foundation

public extension DispatchQueue {
    class func asyncOnMain(_ task: @escaping () -> Void) {
        Thread.isMainThread ? task() : main.async { task() }
    }
    
    class func syncOnMain(_ task: @escaping () -> Void) {
        Thread.isMainThread ? task() : main.sync { task() }
    }
}
