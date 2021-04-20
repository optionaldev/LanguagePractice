//
// The LanguagePractice (iOS) project.
// Created by optionaldev on 20/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

/**
 Inspired from Matteo Pacini's answer:
 
 https://stackoverflow.com/questions/56507839/swiftui-how-to-make-textfield-become-first-responder
 
 Using this instead of traditional SwiftUI TextField for 2 reasons:
 1) SwiftUI TextField cannot become first responder
 2) SwiftUI TextField has a bug where swiping to input a second word doesn't update the text binding
 */

import class Foundation.NotificationCenter
import class Foundation.NSObject
import class UIKit.UITextField

import protocol SwiftUI.UIViewRepresentable
import protocol UIKit.UITextFieldDelegate

import struct SwiftUI.Binding
import struct SwiftUI.UIViewRepresentableContext


struct CustomTextField: UIViewRepresentable {

    class Coordinator: NSObject, UITextFieldDelegate {

        @Binding var text: String
        
        var didBecomeFirstResponder = false

        init(text: Binding<String>) {
            self._text = text
        }
    }

    @Binding var text: String
    
    var isFirstResponder: Bool = true
    
    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.textAlignment = .center
        textField.autocapitalizationType = .none
        
        NotificationCenter.default.addObserver(
            forName: UITextField.textDidChangeNotification,
            object: nil,
            queue: .main)
        { notification in
            self.backwardUpdate(textField: textField)
        }
        
        return textField
    }

    func makeCoordinator() -> CustomTextField.Coordinator {
        return Coordinator(text: $text)
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
        forwardUpdate(textField: uiView)
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
    
    private func forwardUpdate(textField: UITextField) {
        if textField.text != text && text == "" {
            textField.text = ""
        }
    }
    
    private func backwardUpdate(textField: UITextField) {
        if textField.text == "" || textField.text == nil || textField.text != text {
            text = textField.text ?? ""
        }
    }
}
