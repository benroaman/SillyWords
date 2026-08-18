//
//  FavoritesView.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/3/26.
//

import SwiftUI

// MARK: Base
struct FavoritesView: View {
    // MARK: Instance Variables - State
    @FetchRequest private var favorites: FetchedResults<Flavorite>
    @State var model: Model
    
    init(model: Model) {
        self._favorites = FetchRequest<Flavorite>(
            sortDescriptors: model.sort.favoriteSortDescriptors,
            animation: .default
        )
        self.model = model
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
        .alert(model.deleteConfirmationAlertMessage,
               isPresented: model.deleteConfirmationIsPresented,
               actions: makeDeleteConfirmationAlertActions)
        .sendEmail($model.presentedEmail)
    }
}

// MARK: Private API - View Builders
private extension FavoritesView {
    @ViewBuilder var zeroItemView: some View {
        zeroItemMessage
            .font(Self.zeroItemMessageFont)
            .foregroundStyle(Style.Color.zeroItemTheme)
            .transition(.opacity.animation(.default))
    }
    
    @ViewBuilder var favoritesList: some View {
        List {
            ForEach(favorites, id: \.self) { entry in
                Row(model: model, favorite: entry)
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
               action: model.onConfirmDeleteTapped)
        Button(Self.deleteConfirmationAlertCancelActionTitle,
               role: .cancel,
               action: { })
    }
}

// MARK: Copy
extension FavoritesView {
    // Instance
    private var zeroItemMessage: Text { Text("Add favorites in the \(Image(systemName: "bubble.fill")) tab") }
    
    // Static
    static let deleteConfirmationAlertConfirmActionTitle: String = "Delete"
    static let deleteConfirmationAlertCancelActionTitle: String = "Cancel"
}

// MARK: Style
extension FavoritesView {
    // Fonts
    static let zeroItemMessageFont: Font = .headline
}

// MARK: Previews
#Preview {
    PreviewWrapper()
}

fileprivate struct PreviewWrapper: View {
    @State private var favorites: FavoritesManager = .init(Database.preview)
    @State private var context = Database.preview.viewContext
    
    var body: some View {
        FavoritesView(model: .init(favorites))
            .environment(\.managedObjectContext, context)
    }
}
