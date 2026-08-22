//
//  SettingsTabView.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/14/26.
//

import SwiftUI

struct SettingsTabFlow<M: SettingsTabFlowModel>: View {
    @State var model: M
    
    var body: some View {
        NavigationStack(path: $model.navigation.settingsTabRouter.path) {
            SettingsMainMenuView(model: SettingsMainMenuViewModelProd(model.navigation))
                .navigationTitle("Settings")
                .navigationDestination(for: MainRoute.self, destination: model.destination(for:))
        }
    }
}

#Preview {
    SettingsTabFlow(model: SettingsTabFlowModelPreview())
}

