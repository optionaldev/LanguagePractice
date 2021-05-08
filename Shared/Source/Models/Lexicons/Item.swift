//
// The LanguagePractice project.
// Created by optionaldev on 13/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

protocol Item: Codable {
  
  var id: String { get }
  
  var roman: String { get }
}

extension Item {
  
  /// Returns the roman representation of this word
  ///
  /// To use 'id' as a unique identifier, 'id' often contains digits
  /// to separate words that are written exactly the same
  var roman: String {
    return id.removingDigits()
  }
}
