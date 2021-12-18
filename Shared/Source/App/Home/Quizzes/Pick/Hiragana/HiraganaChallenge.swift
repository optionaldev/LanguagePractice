//
// The LanguagePractice project.
// Created by optionaldev on 16/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct HiraganaChallenge: Challengeable {
  
  let inputRep: HiraganaRep
  let outputRep: [HiraganaRep] // x4 or x6
  
  let correctAnswerIndex: Int
  
  var correctOutput: HiraganaRep {
    return outputRep[correctAnswerIndex]
  }
  
  var id: String {
    inputRep.string + outputRep.map { $0.string }.joined()
  }
}
