//
// The LanguagePractice (iOS) project.
// Created by optionaldev on 08/11/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

import protocol SwiftUI.UIViewRepresentable

import class UIKit.UILabel
import class Foundation.NSAttributedString

import struct SwiftUI.UIViewRepresentableContext


struct CustomLabel: UIViewRepresentable {
  
  var text: NSAttributedString
  
  func makeUIView(context: UIViewRepresentableContext<CustomLabel>) -> UILabel {
    let label = UILabel()
    label.attributedText = text
    return label
  }
  
  func updateUIView(_ uiView: UILabel, context: UIViewRepresentableContext<CustomLabel>) {
    // no implementation required
  }
}
