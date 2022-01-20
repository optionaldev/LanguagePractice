//
// The LanguagePractice (iOS) project.
// Created by optionaldev on 03/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

struct PickChallenge: Challengeable {
  
  let inputRep: InputRepresentation
  let outputRep: [OutputRepresentation] // x4 or x6
  
  let correctAnswerIndex: Int
  
  var correctOutput: OutputRepresentation {
    return outputRep[correctAnswerIndex]
  }
  
  // MARK: - Distinguishable conformance
  
  var id: String {
    inputRep.description + outputRep.map { $0.description }.joined()
  }
  
  // MARK: - Equatable conformance
  
  static func ==(lhs: Self, rhs: Self) -> Bool {
    return lhs.id == rhs.id
  }
}
