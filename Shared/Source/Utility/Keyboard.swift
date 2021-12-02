//
// The LanguagePractice project.
// Created by optionaldev on 01/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import class UIKit.UIApplication
import class UIKit.UIResponder

final class Keyboard {
  
  static func dismiss() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                    to: nil,
                                    from: nil,
                                    for: nil)
  }
}
