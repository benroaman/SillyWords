//
//  BadRouteView.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/20/26.
//

import SwiftUI

struct BadRouteView: View {
    let route: MainRoute
    @State var didReport: Bool = false
    
    var body: some View {
        VStack {
            Text("Whoops!")
                .font(.largeTitle)
            Spacer().frame(height: 12)
            Text("This route is not wired up correctly. A report has been sent to the developer. Thank you for your patience!")
                .multilineTextAlignment(.center)
        }.onAppear() {
            guard !didReport else { return }
            Telemetry.reportUnsupportedMainRoute(route)
            didReport = true
        }
    }
}

#Preview {
    BadRouteView(route: .settingsWordGen)
}
