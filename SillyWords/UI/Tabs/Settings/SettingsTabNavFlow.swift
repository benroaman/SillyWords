//
//  SettingsTabNavFlow.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/14/26.
//

import SwiftUI

// MARK: Base
struct SettingsTabNavFlow<M: SettingsTabNavFlowModel>: View {
    // MARK: Instance Variables - State
    @State var model: M
    
    // MARK: Body
    var body: some View {
        NavigationStack(path: $model.router.path) {
            SettingsMainMenuView(model: model.getRootViewModel())
                .navigationTitle("Settings")
                .navigationDestination(for: MainRoute.self, destination: model.destination(for:))
        }
    }
}

// MARK: Previews
#Preview {
    SettingsTabNavFlow(model: SettingsTabFlowModelPreview())
}

