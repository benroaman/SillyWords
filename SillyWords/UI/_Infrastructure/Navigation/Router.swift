//
//  Router.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/19/26.
//

import Foundation

// MARK: Base
@Observable final class Router<R: Hashable> {
    // MARK: Public Variables
    var path: [R] = []
}

// MARK: Public API
extension Router {
    func push(_ route: R) {
        DispatchQueue.asyncOnMain {
            self.path.append(route)
        }
    }
    
    func popOne() {
        DispatchQueue.asyncOnMain {
            guard !self.path.isEmpty else { return }
            self.path.removeLast()
        }
    }
    
    func popToRoot() {
        DispatchQueue.asyncOnMain {
            self.path = []
        }
    }
}
