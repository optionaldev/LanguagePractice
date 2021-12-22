//
// The LanguagePractice project.
// Created by optionaldev on 22/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct WordPickChallenge {
 
  let inputRep: WordRepresentation
  let outputRep: [WordRepresentation] // x4 or x6
  
  let correctAnswerIndex: Int
  
  var correctOutput: WordRepresentation {
    return outputRep[correctAnswerIndex]
  }
  
  var id: String {
    inputRep.string + outputRep.map { $0.string }.joined()
  }
}
