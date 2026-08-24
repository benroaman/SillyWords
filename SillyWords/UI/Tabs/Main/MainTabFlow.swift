//
//  MainTabFlow.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/19/26.
//

import SwiftUI

// MARK: Base
struct MainTabFlow<M: MainTabFlowModel>: View {
    // MARK: Instance Variables - State
    @State var model: M
    
    // MARK: Body
    var body: some View {
        TabView(selection: model.currentTab) {
            ForEach(SillyTab.available, id: \.self) { tab in
                makeTab(for: tab, content: model.makeContent(for: tab))
            }
        }
    }
}

// MARK: Private API - View Builders
private extension MainTabFlow {
    func makeTab<V: View>(for tab: SillyTab, content: V) -> Tab<SillyTab, V, ModifiedContent<Image, AccessibilityAttachmentModifier>> {
        Tab(value: tab, content: {
            content
        }, label: {
            Image(tab.icon)
                .accessibilityLabel(tab.title)
        })
    }
}

// MARK: Previews
#Preview {
    MainTabFlow(model: MainTabFlowModelPreview())
}

