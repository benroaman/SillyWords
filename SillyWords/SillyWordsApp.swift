//
//  SillyWordsApp.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/3/26.
//

import SwiftUI

@main
struct SillyWordsApp: App {
    @State private var state = AppState()
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $state.currentTab, content: {
                Tab(value: .words, content: {
                    WordsView(generator: state.generator, favorites: state.favorites)
                }, label: {
                    Image(systemName: SillyTab.words.systemImageNameUnselected)
                })
                Tab(value: .favorites, content: {
                    FavoritesView(model: .init(state.favorites))
                }, label: {
                    Image(systemName: SillyTab.favorites.systemImageNameUnselected)
                })
                Tab(value: .settings, content: {
                    SettingsTabView(model: SettingsTabModel(state.settings, favorites: state.favorites))
                }, label: {
                    Image(systemName: SillyTab.settings.systemImageNameUnselected)
                })
            })
            .tint(.indigo)
            .environment(\.managedObjectContext, state.database.viewContext)
        }
    }
}
