////
////  MainNavigationManager.swift
////  SillyWords
////
////  Created by Ben Roaman on 8/19/26.
////
//
//import SwiftUI
//
//// MARK: Requirements
//protocol MainNavigationManager: AnyObject, Observable {
//    var mainTabSelection: MainTab { get set }
//    var tabOneRouter: Router<MainRoute> { get }
//    var tabTwoRouter: Router<MainRoute> { get }
//    var tabThreeRouter: Router<MainRoute> { get }
//    var sheet: MainSheet? { get set }
//}
//
//// MARK: Prod Implementation
//@Observable final class MainNavigationManagerProd: MainNavigationManager {
//    var mainTabSelection: MainTab = .one
//    private(set) var tabOneRouter: Router<MainRoute> = .init()
//    private(set) var tabTwoRouter: Router<MainRoute> = .init()
//    private(set) var tabThreeRouter: Router<MainRoute> = .init()
//    var sheet: MainSheet? = nil
//}
