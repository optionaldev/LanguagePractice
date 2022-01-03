//
// The LanguagePractice (iOS) project.
// Created by optionaldev on 03/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

typealias Representation = KanaRepresentation

struct ConjugatablePickChallenge {
  
  let inputRep: Representation
  let outputRep: [Representation] // x4 or x6
  
  let correctAnswerIndex: Int
  
  var correctOutput: Representation {
    return outputRep[correctAnswerIndex]
  }
  
  var id: String {
    inputRep.string + outputRep.map { $0.string }.joined()
  }
}
