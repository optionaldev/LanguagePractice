//
// The LanguagePractice (macOS) project.
// Created by optionaldev on 14/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 


enum MacDefaultsKey: String, Storable {
    
    case sideMenuShowLabels

    // MARK: - Storable conformance

    var storeValue: String {
        return AppConstants.storeValuePrefix + rawValue
    }

}
