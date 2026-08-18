//
//  FavoritesView+Model.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/6/26.
//

import SwiftUI
import CoreData

// MARK: Base
extension FavoritesView {
    @Observable class Model: FavoritesViewRowModel {
        // MARK: Instance Variables
        private let manager: FavoritesManager
        var sort: SortMode = .mostRecent
        var pendingDelete: Favorite?
        var presentedEmail: Email?
        var deleteFailedMessage: String?
        
        // MARK: Initializers
        init(_ manager: FavoritesManager) {
            self.manager = manager
        }
    }
}

// MARK: Public API
extension FavoritesView.Model {
    var hasFavorites: Bool { manager.hasFavorites }
    
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
    
    var deleteConfirmationAlertMessage: String {
        var word: String?
        pendingDelete?.managedObjectContext?.performAndWait {
            word = pendingDelete?.word
        }
        
        return "Delete \"\(word ?? "Favorite")\"?"
    }
    
    // Functions
    func onConfirmDeleteTapped() {
        guard let pendingDelete else { return }
        
        Task {
            do {
                try await manager.removeFavorite(pendingDelete)
            } catch let error as DatabaseError {
                await MainActor.run {
                    self.deleteFailedMessage = "Could not delete favorite: \(error.description)"
                }
            } catch {
                await MainActor.run {
                    self.deleteFailedMessage = "Could not delete favorite: \(error.localizedDescription)"
                }
            }
        }
    }

    // MARK: FavoritesViewRowModel Conformance
    func onDeleteTapped(for favorite: Favorite) {
        pendingDelete = favorite
    }
    
    func onReportPoorQualityTapped(for favorite: Favorite) {
        guard let word = favorite.word else { return }
        presentedEmail = .poorQuality(word: word)
    }
    
    func onReportOffensiveTapped(for favorite: Favorite) {
        guard let word = favorite.word else { return }
        presentedEmail = .offensive(word: word)
    }
}
