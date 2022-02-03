//
// The LanguagePractice project.
// Created by optionaldev on 09/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

enum Language: String, Equatable, CustomStringConvertible {
  
  case english
  case foreign = "japanese"
  
  var other: Self {
    self == .english ? .foreign : .english
  }
  
  // MARK: - CustomStringConvertible conformance
  
  var description: String {
    return rawValue
  }
}
