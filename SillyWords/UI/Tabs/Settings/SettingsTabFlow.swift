//
//  SettingsTabView.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/14/26.
//

import SwiftUI

struct SettingsTabFlow: View {
    @State var model: SettingsTabModel
    
    var body: some View {
        NavigationStack(path: $model.path) {
            SettingsMainMenuView(model: model)
                .navigationTitle("Options")
                .navigationDestination(for: SettingsRoute.self, destination: model.destination(for:))
        }
    }
}

#Preview {
    SettingsTabFlow(model: SettingsTabModel(SettingsManager(), favorites: FavoritesManager(Database())))
}

