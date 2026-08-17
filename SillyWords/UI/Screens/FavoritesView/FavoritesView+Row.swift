//
//  FavoritesView+Row.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/6/26.
//

import SwiftUI

extension FavoritesView {
    struct Row<M: FavoritesViewRowModel>: View {
        // MARK: Instance Variables - State
        @State var model: M
        
        // MARK: Instance Constants
        let favorite: Favorite
        
        // MARK: Body
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    ZStack(alignment: .leading) {
                        // Text("REF") helps Text(favorite.word) take a uniform amount of space as it scales
                        Text("REF")
                            .font(.largeTitle)
                            .foregroundStyle(.clear)
                            .frame(maxWidth: .infinity)
                        Text(favorite.word)
                            .font(.largeTitle)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                    Text(favorite.dateCreated.formatted(date: .long, time: .shortened))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
            }
            .swipeActions(allowsFullSwipe: false) {
                makeRowSwipeActions(for: favorite)
            }
        }
    }
}

// MARK: Private API - View Builders
private extension FavoritesView.Row {
    @ViewBuilder func makeRowSwipeActions(for favorite: Favorite) -> some View {
        Button(action: {
            model.onDeleteTapped(for: favorite)
        }, label: {
            Image(Self.deleteActionIcon)
        })
        .tint(Style.Color.deleteTheme)
        Menu(Self.reportMenuIcon) {
            Button(action: {
                model.onReportPoorQualityTapped(for: favorite)
            }, label: {
                Label(title: Self.reportPoorQualityActionTitle, symbol: Self.reportActionIcon)
            })
            Button(action: {
                model.onReportOffensiveTapped(for: favorite)
            }, label: {
                Label(title: Self.reportOffensiveActionTitle, symbol: Self.reportActionIcon)
            })
            .tint(Style.Color.offensiveTheme)
        }
        .tint(Style.Color.reportTheme)
    }
}

// MARK: Copy
extension FavoritesView.Row {
    static var reportPoorQualityActionTitle: String { "Poor Quality" }
    static var reportOffensiveActionTitle: String { "Offensive" }
    
    static var deleteActionIcon: SFSymbol { .trash }
    static var reportMenuIcon: SFSymbol { .exclamationmarkBubble }
    static var reportActionIcon: SFSymbol { .envelope }
}

// MARK: Model Requirements
protocol FavoritesViewRowModel {
    func onDeleteTapped(for favorite: Favorite)
    func onReportPoorQualityTapped(for favorite: Favorite)    
    func onReportOffensiveTapped(for favorite: Favorite)
}

// MARK: Previews
#Preview {
    PreviewWrapper()
}

fileprivate struct PreviewWrapper: View {
    @State private var model = FavoritesView.Model(FavoritesManager(Database()))
    
    var body: some View {
        List {
            FavoritesView.Row(model: model, favorite: .mock1)
        }
    }
}
