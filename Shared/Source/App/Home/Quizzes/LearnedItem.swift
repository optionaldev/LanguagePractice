//
// The LanguagePractice project.
// Created by optionaldev on 03/05/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import struct Foundation.TimeInterval

struct LearnedItem: Equatable, Distinguishable {
  
  init(character: String, averageTime: TimeInterval) {
    id = character
    challengeAverageTime = Formatters.string(forInterval: averageTime)
  }
  
  var id: String
  var challengeAverageTime: String
}
