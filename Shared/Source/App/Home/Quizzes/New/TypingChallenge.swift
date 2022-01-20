//
// The LanguagePractice project.
// Created by optionaldev on 20/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

struct TypingChallenge: Challengeable {
  
  let inputRep: InputRepresentation
  let output: [String]
  
  // MARK: - Distinguishable conformance
  
  var id: String {
    inputRep.description + output.joined()
  }
  
  // MARK: - Equatable conformance
  
  static func ==(lhs: Self, rhs: Self) -> Bool {
    return lhs.id == rhs.id
  }
}
