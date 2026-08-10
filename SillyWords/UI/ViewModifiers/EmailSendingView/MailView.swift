//
//  MailView.swift
//  SillyWords
//
//  Created by Ben Roaman on 5/5/26.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    @Environment(\.dismiss) var dismiss
    @Binding var result: Result<MFMailComposeResult, Error>?
    let message: Email
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients([message.recipient])
        vc.setSubject(message.subject)
        vc.setMessageBody(message.body, isHTML: false)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) { /** NOT USED **/ }
    
    static func canSendMail() -> Bool { MFMailComposeViewController.canSendMail() }
}

// MARK: Coordinator
extension MailView {
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView
        
        init(_ parent: MailView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            if let error = error {
                parent.result = .failure(error)
            } else {
                parent.result = .success(result)
            }
            parent.dismiss()
        }
    }
}

enum Email: Identifiable {
    case offensive(word: String), poorQuality(word: String), feedback
    
    var recipient: String {
        switch self {
        case .offensive: "sillywordsapp+offensive@gmail.com"
        case .poorQuality: "sillywordsapp+quality@gmail.com"
        case .feedback: "sillywordsapp+feedback@gmail.com"
        }
    }
    
    var subject: String {
        switch self {
        case .offensive: "SillyWords - Offensive Content"
        case .poorQuality: "SillyWords - Poor Quality Word"
        case .feedback: "SillyWords - Feedback"
        }
    }
    
    var body: String {
        switch self {
        case .offensive(let word): "\(word)"
        case .poorQuality(let word): "\"\(word)\"\n\nPlease describe below why \"\(word)\" is a low quality word. Thank you for your feedback!\n\n"
        case .feedback: ""
        }
    }
    
    var id: String {
        switch self {
        case .offensive(let word): "offensive:" + word
        case .poorQuality(let word): "poorQuality:" + word
        case .feedback: "feedback"
        }
    }
    
    var emailUnavailableMessage: String {
        switch self {
        case .offensive: "Offensive words are reported via email, but email is not set up for this device. Please check your settings or use another method to send this report to \(recipient)."
        case .poorQuality: "Poor quality words are reported via email, but email is not set up for this device. Please check your settings or use another method to send this report to \(recipient)."
        case .feedback: "Feedback is submitted via email, but email is not set up for this device. Please check your settings or use another method to send your feedback to \(recipient)."
        }
    }
}
