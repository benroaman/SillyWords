//
//  FavoritesTabFlow.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/20/26.
//

import SwiftUI

// MARK: Base
struct FavoritesTabFlow<M: FavoritesTabFlowModel>: View {
    // MARK: Instance Variables - State
    @State var model: M
    
    // MARK: Body
    var body: some View {
        NavigationStack(path: $model.router.path) {
            FavoritesListView(model: model.makeRootViewModel())
                .navigationDestination(for: MainRoute.self, destination: model.destination(for:))
        }
    }
}

// MARK: Previews
#Preview {
    FavoritesTabFlow(model: FavoritesTabFlowModelPreview())
}
