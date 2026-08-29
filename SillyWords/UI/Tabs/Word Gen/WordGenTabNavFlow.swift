//
//  WordGenTabNavFlow.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/20/26.
//

import SwiftUI

// MARK: Base
struct WordGenTabNavFlow<M: WordGenTabNavFlowModel>: View {
    // MARK: Instance Variables - State
    @State var model: M
    
    // MARK: Body
    var body: some View {
        NavigationStack(path: $model.router.path) {
            WordGenView(model: model.getWordGenViewModel())
            .navigationDestination(for: MainRoute.self, destination: model.destination(for:))
        }
    }
}

// MARK: Previews
#Preview {
    WordGenTabNavFlow(model: WordGenTabFlowModelPreview())
}


