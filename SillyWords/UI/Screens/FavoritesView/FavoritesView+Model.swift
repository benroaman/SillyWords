//
//  FavoritesView+Model.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/6/26.
//

import SwiftUI

// MARK: Base
extension FavoritesView {
    @Observable class Model: FavoritesViewRowModel {
        // MARK: Instance Variables
        private let manager: FavoritesManager
        var sort: SortMode = .date
        var pendingDelete: Favorite?
        var presentedEmail: Email?
        
        // MARK: Initializers
        init(_ manager: FavoritesManager) {
            self.manager = manager
        }
    }
}

// MARK: Public API
extension FavoritesView.Model {
    /// Computed Values
    var favorites: [Favorite] {
        switch sort {
        case .alpha: return manager.favorites.sorted(by: { $0.word < $1.word })
        case .date: return manager.favorites.reversed()
        }
    }
    
    var hasFavorites: Bool {
        !manager.favorites.isEmpty
    }
    
    var deleteConfirmationIsPresented: Binding<Bool> {
        .init(
            get: {
                self.pendingDelete != nil
            },
            set: { isPresented in
                if !isPresented {
                    self.pendingDelete = nil
                }
            }
        )
    }
    
    var deleteConfirmationAlertMessage: String { "Delete \"\(pendingDelete?.word ?? "Favorite")\"?" }
    
    // Functions
    func onConfirmDeleteTapped() {
        manager.removeFavoritee(pendingDelete?.word ?? "")
    }

    // MARK: FavoritesViewRowModel Conformance
    func onDeleteTapped(for favorite: Favorite) {
        pendingDelete = favorite
    }
    
    func onReportPoorQualityTapped(for favorite: Favorite) {
        presentedEmail = .poorQuality(word: favorite.word)
    }
    
    func onReportOffensiveTapped(for favorite: Favorite) {
        presentedEmail = .offensive(word: favorite.word)
    }
}
