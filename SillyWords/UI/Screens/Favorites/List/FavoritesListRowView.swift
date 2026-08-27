//
//  FavoritesListRowView.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/6/26.
//

import SwiftUI

struct FavoritesListRowView<M: FavoritesListRowViewModel>: View {
    // MARK: Instance Variables - State
    @State var model: M
    
    // MARK: Instance Constants
    let word: Word
    
    // MARK: Body
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                if let word = word.text {
                    ZStack(alignment: .leading) {
                        // Text("REF") helps Text(favorite.word) take a uniform amount of space as it scales
                        Text("REF")
                            .font(.largeTitle)
                            .foregroundStyle(.clear)
                            .frame(maxWidth: .infinity)
                        Text(word)
                            .font(.largeTitle)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                }
                if let date = word.dateAdded {
                    Text(date.formatted(date: .long, time: .shortened))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
        .swipeActions(allowsFullSwipe: false) {
            makeRowSwipeActions(for: word)
        }
    }
}

// MARK: Private API - View Builders
private extension FavoritesListRowView {
    @ViewBuilder func makeRowSwipeActions(for word: Word) -> some View {
        Button(action: {
            model.onFavoriteListRowDeleteTap(for: word)
        }, label: {
            Image(Self.deleteActionIcon)
        })
        .tint(Style.Theme.Color.delete)
        Menu(Self.reportMenuIcon) {
            Button(action: {
                model.onFavoriteListRowReportPoorQualityTap(for: word)
            }, label: {
                Label(title: Self.reportPoorQualityActionTitle, symbol: Self.reportActionIcon)
            })
            Button(action: {
                model.onFavoriteListRowReportOffensiveTap(for: word)
            }, label: {
                Label(title: Self.reportOffensiveActionTitle, symbol: Self.reportActionIcon)
            })
            .tint(Style.Theme.Color.offensive)
        }
        .tint(Style.Theme.Color.report)
    }
}

// MARK: Copy
extension FavoritesListRowView {
    static var reportPoorQualityActionTitle: String { "Poor Quality" }
    static var reportOffensiveActionTitle: String { "Offensive" }
    
    static var deleteActionIcon: SFSymbol { .trash }
    static var reportMenuIcon: SFSymbol { .exclamationmarkBubble }
    static var reportActionIcon: SFSymbol { .envelope }
}

// MARK: Model Requirements
protocol FavoritesListRowViewModel {
    func onFavoriteListRowDeleteTap(for word: Word)
    func onFavoriteListRowReportPoorQualityTap(for word: Word)
    func onFavoriteListRowReportOffensiveTap(for word: Word)
}

// MARK: Previews
#Preview {
    PreviewWrapper()
}

fileprivate struct PreviewWrapper: View {
    @State private var model = FavoritesListViewModelPreview()
    
    var body: some View {
        List {
            FavoritesListRowView(model: model, word: model.someFavorite)
        }
    }
}
