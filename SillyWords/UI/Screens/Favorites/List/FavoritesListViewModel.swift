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
    var removeFavoriteError: Error? { get set }
    
    func onFavoriteListConfirmDeleteTapped()
}

// MARK: Preview Implementation
@Observable class FavoritesListViewModelPreview: FavoritesListViewModel {
    /// Instance Constants
    let someFavorite: Word = try! Database.preview.viewContext.fetch(Word.fetchRequest()).randomElement()!
    
    /// Instance Variables
    private var _isPresentingDeleteConfirmation: Bool = false
    
    /// FavoritesListViewModel Implementation
    var removeFavoriteError: (any Error)?
    
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
    func onFavoriteListRowDeleteTap(for word: Word) { _isPresentingDeleteConfirmation = true }
    func onFavoriteListRowReportPoorQualityTap(for word: Word) { print("Quality") }
    func onFavoriteListRowReportOffensiveTap(for word: Word) { print("Offensive") }
}

@Observable class FavoritesListviewModelProd: FavoritesListViewModel {
    /// Instance Constants
    private let manager: FavoritesManager
    private let navigation: FavoritesTabNavigation
    
    /// Instance Variables
    private var pendingDelete: Word?
    
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
            word = pendingDelete?.text
        }
        
        return "Unfavorite \"\(word ?? "Favorite")\"?"
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
    
    var removeFavoriteError: (any Error)?
    
    func onFavoriteListConfirmDeleteTapped() {
        guard let pendingDelete else { return }
        
        Task {
            do {
                try await manager.removeFavorite(pendingDelete, context: .favoritesList)
                Telemetry.trackRemoveFavorite(.favoritesList)
            } catch {
                await MainActor.run {
                    self.removeFavoriteError = error
                }
            }
        }
    }
    
    /// FavoritesListRowViewModel Implementation
    func onFavoriteListRowDeleteTap(for word: Word) {
        pendingDelete = word
    }
    
    func onFavoriteListRowReportPoorQualityTap(for word: Word) {
        #warning("TODO: How do I feel about not explicity accessing this on the managed object context thread, even though in this context it will implicitly always execute on the main thread and context will always be viewContext?")
        guard let text = word.text else { return }
        navigation.presentedEmail = .poorQuality(word: text)
    }
    
    func onFavoriteListRowReportOffensiveTap(for word: Word) {
        #warning("TODO: How do I feel about not explicity accessing this on the managed object context thread, even though in this context it will implicitly always execute on the main thread and context will always be viewContext?")
        guard let text = word.text else { return }
        navigation.presentedEmail = .offensive(word: text)
    }
}
