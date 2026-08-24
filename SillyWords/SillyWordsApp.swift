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
            TabView(selection: $state.navigation.currentTab, content: {
                Tab(value: .words, content: {
                    WordGenTabFlow(model: WordGenTabFlowModelProd(state: state))
                }, label: {
                    Image(.characterBubble)
                        .accessibilityLabel(SillyTab.words.title)
                })
                Tab(value: .favorites, content: {
                    FavoritesTabFlow(model: FavoritesTabFlowModelProd(state: state))
                }, label: {
                    Image(.heart)
                        .accessibilityLabel(SillyTab.favorites.title)
                })
                Tab(value: .settings, content: {
                    SettingsTabFlow(model: SettingsTabFlowModelProd(state: state))
                }, label: {
                    Image(systemName: SillyTab.settings.systemImageNameUnselected)
                        .accessibilityLabel(SillyTab.settings.title)
                })
            })
            .tint(Style.Color.mainTheme)
            .environment(\.managedObjectContext, state.database.viewContext)
            .sendEmail($state.navigation.presentedEmail)
        }
    }
}
