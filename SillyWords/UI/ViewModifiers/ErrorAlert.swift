//
//  ErrorAlert.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/29/26.
//

import SwiftUI

struct ErrorAlert<Actions: View>: ViewModifier {
    // MARK: Instance Variables - State
    @Binding var error: (any Error)?
    
    // MARK: Instance Constants
    let baseMessage: String
    @ViewBuilder let actions: () -> Actions
    
    // MARK: Computed Values
    private var message: String {
        if let message = (error as? DatabaseError)?.userMessage {
            return baseMessage + ": \(message)"
        } else {
            return baseMessage
        }
    }
    
    private var errorBinding: Binding<Bool> {
        .init(get: {
            self.error != nil
        }, set: { isPresented in
            if !isPresented { self.error = nil }
        })
    }
    
    // MARK: Initializers
    init(_ baseMessage: String, error: Binding<(any Error)?>, @ViewBuilder actions: @escaping () -> Actions) {
        self.baseMessage = baseMessage
        self._error = error
        self.actions = actions
    }
    
    // MARK: Body
    func body(content: Content) -> some View {
        content
            .alert(message, isPresented: errorBinding, actions: actions)
    }
}

// MARK: Modifier Function
extension View {
    func errorAlert<Actions: View>(
        _ baseMessage: String,
        error: Binding<(any Error)?>,
        @ViewBuilder actions: @escaping () -> Actions = { Button("Okay", action: { }) }
    ) -> some View {
        modifier(ErrorAlert(baseMessage, error: error, actions: actions))
    }
}

// MARK: Previews
#Preview("Default Actions") {
    PreviewWrapperDefaultActions()
}

#Preview("Custom Actions") {
    PreviewWrapperCustomActions()
}

fileprivate struct PreviewWrapperDefaultActions: View {
    @State var error: Error? = DatabaseError.mockDiskFull
    
    var body: some View {
        Text("App Content")
            .errorAlert("Failed to save record of \"scriznit\"", error: $error)
    }
}

fileprivate struct PreviewWrapperCustomActions: View {
    @State var error: Error? = DatabaseError.mockMisc
    
    var body: some View {
        Text("App Content")
            .errorAlert("Failed to update favorites", error: $error) {
                Button(action: { }, label: {
                    Text("Explode")
                })
                Button(action: { }, label: {
                    Text("Implode")
                })
            }
    }
}
