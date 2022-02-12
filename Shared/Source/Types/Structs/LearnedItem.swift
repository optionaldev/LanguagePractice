//
// The LanguagePractice project.
// Created by optionaldev on 03/05/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import struct Foundation.TimeInterval

/**
 A list of items that the user learned during the challenge.
 Based on time, the plan is to have every word shown
 with a different intensity / size, proportional to how
 fast the word was guessed, applying metrics relative
 to the user.
 */
struct LearnedItem: Equatable, Distinguishable {
  
  init(character: String, averageTime: TimeInterval) {
    id = character
    challengeAverageTime = Formatters.string(forInterval: averageTime)
  }
  
  var id: String
  var challengeAverageTime: String
}
