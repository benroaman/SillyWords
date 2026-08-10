//
//  EmailSendingView.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/6/26.
//

import SwiftUI
import MessageUI

struct EmailSendingView: ViewModifier {
    @State var emailResult: Result<MFMailComposeResult, Error>?
    @State var infoAlertMessage: String?
    @Binding var presentedEmail: Email?
    
    func body(content: Content) -> some View {
        if MailView.canSendMail() {
            content
                .sheet(item: $presentedEmail, onDismiss: {
                    switch emailResult {
                    case .success(let result):
                        switch result {
                        case .failed: infoAlertMessage = "Email failed to send"
                        default: break
                        }
                    case .failure(let error): infoAlertMessage = "Email failed to send: \(error.localizedDescription)"
                    default: break
                    }
                }, content: { email in
                    MailView(result: $emailResult, message: email)
                })
                .alert(infoAlertMessage ?? "No Info", isPresented: .init(get: { self.infoAlertMessage != nil }, set: { isPresented in if !isPresented { self.infoAlertMessage = nil } }), actions: {
                    Button(action: { }, label: {
                        Text("Okay")
                    })
                })
        } else {
            content
                .alert(presentedEmail?.emailUnavailableMessage ?? "Words are reported via email, but email is not set up for this device. Please check your settings.", isPresented: .init(get: { self.presentedEmail != nil }, set: { isPresented in if !isPresented { self.presentedEmail = nil } }), actions: {
                    Button(action: { }, label: {
                        Text("Okay")
                    })
                })
        }
        
    }
}

extension View {
    func sendEmail(_ email: Binding<Email?>) -> some View {
        modifier(EmailSendingView(presentedEmail: email))
    }
}
