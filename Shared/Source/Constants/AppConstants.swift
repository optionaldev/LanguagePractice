//
// The LanguagePractice project.
// Created by optionaldev on 10/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct AppConstants {
    
    #if JAPANESE
    static let hiragana = Hiragana()
    #endif
    
    // Main reason for using an underscore is because all rawValues appended start with lowercase letter
    // and it's not worth going through the trouble of uppercasing it
    static let storeValuePrefix = "LanguagePracticeUserDefaults_"
}
