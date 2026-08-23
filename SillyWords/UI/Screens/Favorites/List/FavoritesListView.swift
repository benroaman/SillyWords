//
//  FavoritesListView.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/3/26.
//

import SwiftUI

// MARK: Base
struct FavoritesListView<M: FavoritesListViewModel>: View {
    // MARK: Instance Variables - State
    @FetchRequest private var favorites: FetchedResults<Favorite>
    @State var model: M
    
    init(model: M) {
        self.model = model
        self._favorites = FetchRequest<Favorite>(
            sortDescriptors: model.sort.favoriteSortDescriptors,
            animation: .default
        )
    }
    
    // MARK: Body
    var body: some View {
        VStack {
            if model.hasFavorites {
                favoritesList
            } else {
                zeroItemView
            }
        }
        .alert(model.deleteConfirmationMessage,
               isPresented: model.isPresentingDeleteConfirmation,
               actions: makeDeleteConfirmationAlertActions)
    }
}

// MARK: Private API - View Builders
private extension FavoritesListView {
    @ViewBuilder var zeroItemView: some View {
        zeroItemMessage
            .font(Self.zeroItemMessageFont)
            .foregroundStyle(Style.Color.zeroItemTheme)
            .transition(.opacity.animation(.default))
    }
    
    @ViewBuilder var favoritesList: some View {
        List {
            ForEach(favorites, id: \.self) { entry in
                FavoritesListRowView(model: model, favorite: entry)
            }
        }
        .onChange(of: model.sort, {_, _ in
            favorites.sortDescriptors = model.sort.favoriteSortDescriptors
        })
        .safeAreaBar(edge: .top, alignment: .trailing) {
            sortButton
        }
        .transition(.opacity.animation(.default))
    }
    
    @ViewBuilder var sortButton: some View {
        Picker(selection: $model.sort, content: {
            ForEach(SortMode.allCases, id: \.self) { mode in
                Image(mode.icon)
                .tag(mode)
            }
        }, label: {
            Image(model.sort.icon)
                .contentTransition(.symbolEffect(.replace))
        })
        .labelsHidden()
        .glassEffect(.clear)
        .padding(.trailing)
    }
    
    @ViewBuilder func makeDeleteConfirmationAlertActions() -> some View {
        Button(Self.deleteConfirmationAlertConfirmActionTitle,
               role: .destructive,
               action: model.onFavoriteListConfirmDeleteTapped)
        Button(Self.deleteConfirmationAlertCancelActionTitle,
               role: .cancel,
               action: { })
    }
}

// MARK: Copy
extension FavoritesListView {
    // Instance
    private var zeroItemMessage: Text { Text("Add favorites in the \(Image(.characterBubbleFill)) tab") }
    
    // Static
    static var deleteConfirmationAlertConfirmActionTitle: String { "Delete" }
    static var deleteConfirmationAlertCancelActionTitle: String { "Cancel" }
}

// MARK: Style
extension FavoritesListView {
    // Fonts
    static var zeroItemMessageFont: Font { .headline }
}

// MARK: Previews
#Preview {
    PreviewWrapper()
}

fileprivate struct PreviewWrapper: View {
    @State private var database = Database.preview
    
    var body: some View {
        FavoritesListView(model: FavoritesListviewModelProd(manager: FavoritesManager(database), navigation: FavoritesTabNavigationPreview()))
            .environment(\.managedObjectContext, database.viewContext)
    }
}
