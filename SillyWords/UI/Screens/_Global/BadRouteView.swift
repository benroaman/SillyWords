//
//  BadRouteView.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/20/26.
//

import SwiftUI

// MARK: Base
struct BadRouteView: View {
    // MARK: Instance Constants
    let route: MainRoute
    let flow: Telemetry.NavFlow
    
    // MARK: Instance Variables - State
    @State var didReport: Bool = false
    
    // MARK: Body
    var body: some View {
        VStack {
            Text("Whoops!")
                .font(.largeTitle)
            Spacer().frame(height: 12)
            Text("This route is not wired up correctly. A report has been sent to the developer. Thank you for your patience!")
                .multilineTextAlignment(.center)
        }.onAppear() {
            guard !didReport else { return }
            Telemetry.reportUnsupportedMainRoute(route, in: flow)
            didReport = true
        }
    }
}

// MARK: Previews
#Preview {
    BadRouteView(route: .settingsWordGen, flow: .wordGenTab)
}
