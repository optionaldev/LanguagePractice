//
// The LanguagePractice project.
// Created by optionaldev on 18/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 


import class Foundation.DispatchQueue
import class Foundation.NumberFormatter

import protocol Foundation.ObservableObject

import struct Foundation.Date
import struct Foundation.Published
import struct Foundation.TimeInterval

protocol EntryProvidable {
  
  func generate() -> [Distinguishable]
}

final class NewPickQuizViewModel: Quizing, ObservableObject, SpeechDelegate {
  var nextChallenge: PickChallenge?
  
  func finishedCurrentChallenge() {
    
  }
  
  func handleFinish() {
    
  }
  
  func prepareNextChallenge() {
    
  }
  
  
  @Published var visibleChallenges: [PickChallenge] = []
  
  @Published private(set) var itemsLearned: [LearnedItem] = []
  
  private(set) var challengeMeasurement = ChallengeMeasurement()
  
  private(set) var challengeEntries: [Distinguishable]
  
  init(entryProvider: EntryProvidable) {
    challengeEntries = entryProvider.generate()
    performInitialSetup()
  }
  
  // MARK: - SpeechDelegate conformance
  
  func speechStarted() {}
  func speechEnded() {}
}
