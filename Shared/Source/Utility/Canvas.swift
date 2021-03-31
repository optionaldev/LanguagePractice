//
// The LanguagePractice project.
// Created by optionaldev on 15/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

#if os(iOS)
import class UIKit.UIScreen

import struct UIKit.CGFloat
#endif

import struct SwiftUI.CGFloat
/**
    Typically represents the area where the challenge appears.
    on iOS, this is the Screen width in portrait mode (landscape mode TBD how to dela with)
    on MacOS, this is the portion of the window where the challenge is displayed
 */
final class Canvas {
    
    static var height: CGFloat {
        #if os(iOS)
        return UIScreen.main.bounds.height
        #else
        return 300
        #endif
    }
    
    static var width: CGFloat {
        #if os(iOS)
        return UIScreen.main.bounds.width
        #else
        return 700
        #endif
    }
}
