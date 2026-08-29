//
//  MainTabFlowModel.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/20/26.
//

import SwiftUI

// MARK: Model Requirements
protocol MainTabFlowModel: AnyObject, Observable {
    associatedtype Content: View
    @ViewBuilder func makeContent(for tab: SillyTab) -> Content
    var currentTab: Binding<SillyTab> { get }
}

// MARK: Preview Model
@Observable final class MainTabFlowModelPreview: MainTabFlowModel {
    /// Instance Variables
    private var _currentTab: SillyTab = .words
    
    /// MainTabFlowModel Implementation
    var currentTab: Binding<SillyTab> {
        .init(get: {
            self._currentTab
        }, set: {
            self._currentTab = $0
        })
    }
    
    @ViewBuilder func makeContent(for tab: SillyTab) -> some View {
        switch tab {
        case .words: WordGenTabNavFlow(model: WordGenTabFlowModelPreview())
        case .favorites: FavoritesTabNavFlow(model: FavoritesTabFlowModelPreview())
        case .settings: SettingsTabNavFlow(model: SettingsTabFlowModelPreview())
        }
    }
}

// MARK: Prod Model
@Observable final class MainTabFlowModelProd: MainTabFlowModel {
    /// Instance Constants
    private let state: AppState
    
    /// Initializers
    init(state: AppState) {
        self.state = state
    }
    
    /// MainTabFlowModel Implementation
    var currentTab: Binding<SillyTab> {
        .init(get: {
            self.state.navigation.currentTab
        }, set: { newValue in
            self.state.navigation.currentTab = newValue
        })
    }
    
    @ViewBuilder func makeContent(for tab: SillyTab) -> some View {
        switch tab {
        case .words: WordGenTabNavFlow(model: WordGenTabFlowModelProd(state: state))
        case .favorites: FavoritesTabNavFlow(model: FavoritesTabFlowModelProd(state: state))
        case .settings: SettingsTabNavFlow(model: SettingsTabFlowModelProd(state: state))
        }
    }
}
