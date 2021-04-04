//
// The LanguagePractice project.
// Created by optionaldev on 10/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

import struct Foundation.TimeInterval


let iOS: Bool = {
    #if os(iOS)
    return true
    #else
    return false
    #endif
}()

struct AppConstants {
    
    #if JAPANESE
    static let hiragana = Hiragana()
    #endif
    
    // Primarily used in order to differentiate between the guessing word and the answers
    static let defaultOpacity = 0.3
    
    // If an answer has a time interval between these two values, it is a successful answer
    static let successRange = 0.0...10.0
}
