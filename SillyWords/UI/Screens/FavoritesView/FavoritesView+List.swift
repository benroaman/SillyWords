//
//  FavoritesView+List.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/18/26.
//

import SwiftUI

struct FavoritesViewList<M: FavoritesViewRowModel>: View {
    @FetchRequest private var favorites: FetchedResults<Flavorite>
    @State private var model: M
    
    init(model: M, sortedBy: FavoritesView.SortMode) {
        self.model = model
        self._favorites = FetchRequest<Flavorite>(
            sortDescriptors: sortedBy.favoriteSortDescriptors,
            animation: .default
        )
    }

    var body: some View {
        List {
            ForEach(favorites, id: \.self) { entry in
                FavoritesView.Row(model: model, favorite: entry)
            }
        }
    }
}
