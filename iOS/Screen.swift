//
// The LanguagePractice project.
// Created by optionaldev on 15/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import class UIKit.UIScreen

import struct UIKit.CGFloat

final class Screen {
    
    static var height: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static var width: CGFloat {
        return UIScreen.main.bounds.width
    }
}
