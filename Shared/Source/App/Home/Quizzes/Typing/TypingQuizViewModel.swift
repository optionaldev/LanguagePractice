//
// The LanguagePractice project.
// Created by optionaldev on 29/11/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import class Foundation.DispatchQueue
import class Foundation.NumberFormatter

import protocol Foundation.ObservableObject

import struct Foundation.Date
import struct Foundation.Published
import struct Foundation.TimeInterval


final class TypingQuizViewModel: OutputQuizable, ObservableObject, SpeechDelegate {
  
  @Published var visibleChallenges: [TypingChallenge] = []
  
  @Published private(set) var itemsLearned: [LearnedItem] = []
  
  private(set) var challengeMeasurement = ChallengeMeasurement()
  
  private(set) var challengeEntries: [EntryProtocol] = []
  
  var nextChallenge: TypingChallenge? = nil
  
  init() {
    performInitialSetup()
    
    Speech.shared.delegate = self
  }
  
  var voiceLastTappedIndex: Int = -1
  
  func finishedCurrentChallenge() {
  }
  
  func prepareNextChallenge() {
  }
  
  func handleFinish() {
  }
  
  // MARK: - SpeechDelegate conformance
  func chose(index: Int) {
    
  }
  
  func speechEnded() {
  }
}
