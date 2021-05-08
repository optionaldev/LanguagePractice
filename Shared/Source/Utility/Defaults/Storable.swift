//
// The LanguagePractice project.
// Created by optionaldev on 14/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

private struct Constants {
  
  // Main reason for using an underscore is because all rawValues appended start with lowercase letter
  // and it's not worth going through the trouble of uppercasing it
  static let storeValuePrefix = "LanguagePracticeUserDefaults_"
}

protocol Storable {
  
  var storeValue: String { get }
}

extension Storable where Self: RawRepresentable, Self.RawValue: StringProtocol {
  
  var storeValue: String {
    return Constants.storeValuePrefix + rawValue
  }
}
