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

protocol ChallengeProvidable {
  
  func generate(fromPool pool: [Distinguishable], index: Int) -> PickChallenge
}

protocol ResultsInterpretable {
  
  func assessResults(entries: [Distinguishable], states: [TimeStorable]) -> [LearnedItem]
}

final class NewPickQuizViewModel: Quizing, ObservableObject, SpeechDelegate {
  
  @Published var visibleChallenges: [PickChallenge] = []
  
  @Published private(set) var itemsLearned: [LearnedItem] = []
  
  private(set) var challengeMeasurement = ChallengeMeasurement()
  
  private(set) var challengeEntries: [Distinguishable]
  
  init(entryProvider: EntryProvidable, challengeProvider: ChallengeProvidable, resultsInterpreter: ResultsInterpretable) {
    self.challengeProvider = challengeProvider
    self.resultsInterpreter = resultsInterpreter
    challengeEntries = entryProvider.generate()
    performInitialSetup()
  }
  
  var nextChallenge: PickChallenge?
  
  func handleFinish() {
    itemsLearned = resultsInterpreter.assessResults(entries: challengeEntries, states: challengeStates)
  }
  
  func finishedCurrentChallenge() {
    if challengeStates.count == visibleChallenges.count && challengeStates.last != .guessedIncorrectly {
      let challengeTime = challengeMeasurement.stopAndFetchResult()
      challengeStates[visibleChallenges.count - 1] = .finished(challengeTime)
    }
  }
  
  func prepareNextChallenge() {
    nextChallenge = challengeProvider.generate(fromPool: challengeEntries, index: visibleChallenges.count)
  }
  
  // MARK: - SpeechDelegate conformance
  
  func speechStarted() {}
  func speechEnded() {}
  
  // MARK: - Private
  
  private var challengeProvider: ChallengeProvidable
  private var challengeStates: [PickChallengeState] = []
  private var resultsInterpreter: ResultsInterpretable
}
