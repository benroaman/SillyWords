//
//  FavoritesListViewModel.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/21/26.
//

import SwiftUI
import CoreData

// MARK: Requirements
protocol FavoritesListViewModel: AnyObject, Observable, FavoritesListRowViewModel {
    var hasFavorites: Bool { get }
    var deleteConfirmationMessage: String { get }
    var isPresentingDeleteConfirmation: Binding<Bool> { get }
    var sort: SortMode { get set }
    var deleteErrorMessage: String? { get }
    var isPresentingDeleteError: Binding<Bool> { get }
    
    func onFavoriteListConfirmDeleteTapped()
}

// MARK: Preview Implementation
@Observable class FavoritesListViewModelPreview: FavoritesListViewModel {
    /// Instance Constants
    let someFavorite: Favorite = try! Database.preview.viewContext.fetch(Favorite.fetchRequest()).randomElement()!
    
    /// Instance Variables
    private var _isPresentingDeleteConfirmation: Bool = false
    
    /// FavoritesListViewModel Implementation
    private(set) var deleteErrorMessage: String?
    
    var isPresentingDeleteError: Binding<Bool> {
        .init(
            get: {
                self.deleteErrorMessage != nil
            },
            set: { isPresented in
                if !isPresented { self.deleteErrorMessage = nil }
            }
        )
    }
    
    let hasFavorites: Bool = true
    
    let deleteConfirmationMessage: String = "Delete?"
    
    var isPresentingDeleteConfirmation: Binding<Bool> {
        .init(
            get: {
                self._isPresentingDeleteConfirmation
            },
            set: { isPresented in
                self._isPresentingDeleteConfirmation = isPresented
            }
        )
    }
    
    var sort: SortMode = .mostRecent
    
    func onFavoriteListConfirmDeleteTapped() { _isPresentingDeleteConfirmation = false }
    
    /// FavoritesListRowViewModel Implementation
    func onFavoriteListRowDeleteTap(for favorite: Favorite) { _isPresentingDeleteConfirmation = true }
    func onFavoriteListRowReportPoorQualityTap(for favorite: Favorite) { print("Quality") }
    func onFavoriteListRowReportOffensiveTap(for favorite: Favorite) { print("Offensive") }
}

@Observable class FavoritesListviewModelProd: FavoritesListViewModel {
    /// Instance Constants
    private let manager: FavoritesManager
    private let navigation: FavoritesTabNavigation
    
    /// Instance Variables
    private var pendingDelete: Favorite?
    
    /// Initializers
    init(manager: FavoritesManager, navigation: FavoritesTabNavigation) {
        self.manager = manager
        self.navigation = navigation
    }
    
    /// FavoritesListViewModel Implementation
    var hasFavorites: Bool { manager.hasFavorites }
    
    var deleteConfirmationMessage: String {
        var word: String?
        pendingDelete?.managedObjectContext?.performAndWait {
            word = pendingDelete?.word
        }
        
        return "Delete \"\(word ?? "Favorite")\"?"
    }
    
    var isPresentingDeleteConfirmation: Binding<Bool> {
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
    
    var sort: SortMode = .mostRecent
    
    private(set) var deleteErrorMessage: String?
    
    var isPresentingDeleteError: Binding<Bool> {
        .init(
            get: {
                self.deleteErrorMessage != nil
            },
            set: { isPresented in
                if !isPresented {
                    self.deleteErrorMessage = nil
                }
            }
        )
    }
    
    func onFavoriteListConfirmDeleteTapped() {
        guard let pendingDelete else { return }
        
        Task {
            do {
                try await manager.removeFavorite(pendingDelete)
            } catch let error as DatabaseError {
                await MainActor.run {
                    self.deleteErrorMessage = "Could not delete favorite: \(error.description)"
                }
            } catch {
                await MainActor.run {
                    self.deleteErrorMessage = "Could not delete favorite: \(error.localizedDescription)"
                }
            }
        }
    }
    
    /// FavoritesListRowViewModel Implementation
    func onFavoriteListRowDeleteTap(for favorite: Favorite) {
        pendingDelete = favorite
    }
    
    func onFavoriteListRowReportPoorQualityTap(for favorite: Favorite) {
        #warning("TODO: How do I feel about not explicity accessing this on the managed object context thread, even though in this context it will implicitly always execute on the main thread and context will always be viewContext?")
        guard let word = favorite.word else { return }
        navigation.presentedEmail = .poorQuality(word: word)
    }
    
    func onFavoriteListRowReportOffensiveTap(for favorite: Favorite) {
        #warning("TODO: How do I feel about not explicity accessing this on the managed object context thread, even though in this context it will implicitly always execute on the main thread and context will always be viewContext?")
        guard let word = favorite.word else { return }
        navigation.presentedEmail = .offensive(word: word)
    }
}
