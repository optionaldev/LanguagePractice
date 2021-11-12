//
// The LanguagePractice project.
// Created by optionaldev on 12/11/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import class UIKit.UIScreen
import struct CoreGraphics.CGFloat

struct Screen {
  
  static var width: CGFloat {
    UIScreen.main.bounds.width
  }
  
  static var height: CGFloat {
    UIScreen.main.bounds.height
  }
}
