//
//  SillyWordsApp.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/3/26.
//

import SwiftUI

@main
struct SillyWordsApp: App {
    // MARK: Instance Variables - State
    @State private var state = AppState()
    
    // MARK: Body
    var body: some Scene {
        WindowGroup {
            MainTabFlow(model: MainTabFlowModelProd(state: state))
            .tint(Style.Color.mainTheme)
            .environment(\.managedObjectContext, state.database.viewContext)
            .sendEmail($state.navigation.presentedEmail)
        }
    }
}
