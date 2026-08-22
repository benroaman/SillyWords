//
//  MainTabFlowModel.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/20/26.
//

//import Foundation
//
//// MARK: Model Requirements
//protocol MainTabFlowModel: AnyObject, Observable {
//    associatedtype WordGenerationModel: WordGenerationTabFlowModel
//    associatedtype FavoritesModel: FavoritesTabFlowModel
//    associatedtype TabThreeModel: TabThreeFlowModel
//    
//    var navigation: any MainNavigationManager { get set }
//    func makeTabOneFlowModel() -> TabOneModel
//    func makeTabTwoFlowModel() -> TabTwoModel
//    func makeTabThreeFlowModel() -> TabThreeModel
//}
//
//// MARK: Prod Model
//@Observable final class MainTabFlowModelProd: MainTabFlowModel {
//    /// Instance Constants
//    private let state: AppState
//    
//    /// Initializers
//    init(state: AppState) {
//        self.state = state
//        self.navigation = state.mainNavigation
//    }
//    
//    /// MainTabFlowModel
//    typealias TabOneModel = TabOneFlowModelProd
//    typealias TabTwoModel = TabTwoFlowModelProd
//    typealias TabThreeModel = TabThreeFlowModelProd
//    
//    var navigation: any MainNavigationManager
//    
//    func makeTabOneFlowModel() -> TabOneFlowModelProd { .init(state) }
//    func makeTabTwoFlowModel() -> TabTwoFlowModelProd { .init(state) }
//    func makeTabThreeFlowModel() -> TabThreeFlowModelProd { .init(state) }
//}
//
//protocol SettingsTabModel: AnyObject, Observable {
//    
//}
//
//protocol GenerationTabModel: AnyObject, Observable {
//    
//}
//
//protocol SettingsTabModel: AnyObject, Observable {
//    
//}
