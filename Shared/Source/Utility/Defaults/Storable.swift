//
// The LanguagePractice project.
// Created by optionaldev on 14/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

protocol Storable {
    
    var storeValue: String { get }
}

extension Storable where Self: RawRepresentable, Self.RawValue: StringProtocol {
    
    var storeValue: String {
        log("\(self)")
        return AppConstants.storeValuePrefix + rawValue
    }
}

protocol CodingStorable: Storable {}
protocol BoolStorable: Storable {}
