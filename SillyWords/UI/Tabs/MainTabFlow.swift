//
//  MainTabFlow.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/19/26.
//

//import SwiftUI
//
//struct MainTabFlow<M: MainTabFlowModel>: View {
//    // MARK: Instance Variables - State
//    @State var model: M
//    
//    // MARK: Body
//    var body: some View {
//        TabView(selection: $model.navigation.mainTabSelection) {
//            ForEach(MainTab.available, id: \.self) { tab in
//                makeTab(for: tab, content: makeContent(for: tab))
//            }
//        }
//        .sheet(item: $model.navigation.sheet, content: { makeSheet(for: $0) })
//    }
//}
//
//// MARK: Private API - View Builders
//private extension MainTabFlow {
//    func makeTab<V: View>(for tab: MainTab, content: V) -> Tab<MainTab, V, Label<Text, Image>> {
//        Tab(value: tab, content: {
//            content
//        }, label: {
//            Label(tab.title, symbol: tab.icon)
//        })
//    }
//    
//    @ViewBuilder func makeContent(for tab: MainTab) -> some View {
//        switch tab {
//        case .one: TabOneFlow(model: model.makeTabOneFlowModel())
//        case .two: TabTwoFlow(model: model.makeTabTwoFlowModel())
//        case .three: TabThreeFlow(model: model.makeTabThreeFlowModel())
//        }
//    }
//    
//    @ViewBuilder func makeSheet(for sheet: MainSheet) -> some View {
//        switch sheet {
//        case .test1: Text("Sheet One")
//        case .test2: Text("Sheet Two")
//        case .test3: Text("Sheet Three")
//        }
//    }
//}
//
//// MARK: Previews
//#Preview {
//    MainTabFlow(model: MainTabFlowModelPreview())
//}
//
//@Observable final class MainTabFlowModelPreview: MainTabFlowModel {
//    typealias TabOneModel = TabOneFlowModelPreview
//    typealias TabTwoModel = TabTwoFlowModelPreview
//    typealias TabThreeModel = TabThreeFlowModelPreview
//    
//    var navigation: any MainNavigationManager = MainNavigationManagerProd()
//    
//    func makeTabOneFlowModel() -> TabOneFlowModelPreview { .init() }
//    func makeTabTwoFlowModel() -> TabTwoFlowModelPreview { .init() }
//    func makeTabThreeFlowModel() -> TabThreeFlowModelPreview { .init() }
//}
//
