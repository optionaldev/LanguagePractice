//
// The LanguagePractice project.
// Created by optionaldev on 14/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

final class Defaults {
    
    #if os(iOS)
    static let iOS = iOSDefaults()
    #else
    static let macOS = MacDefaults()
    #endif
}
