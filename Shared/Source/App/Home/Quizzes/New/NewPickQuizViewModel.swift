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
  
  func generatePick(fromPool pool: [Distinguishable], index: Int) -> PickChallenge
  func generateTyping(fromPool pool: [Distinguishable], index: Int) -> TypingChallenge
}

protocol ResultsInterpretable {
  
  func assessResults(entries: [Distinguishable], states: [TimeStorable]) -> [LearnedItem]
}

final class NewPickQuizViewModel: Quizing, ObservableObject, SpeechDelegate, VoiceChallengeable, InputTappable {
  
  @Published var visibleChallenges: [PickChallenge] = []
  @Published var itemsLearned: [LearnedItem] = []
  
  var nextChallenge: PickChallenge?
  
  private(set) var challengeEntries: [Distinguishable]
  private(set) var challengeMeasurement = ChallengeMeasurement()
  private(set) var challengeProvider: ChallengeProvidable
  
  init(entryProvider: EntryProvidable,
       challengeProvider: ChallengeProvidable,
       resultsInterpreter: ResultsInterpretable,
       speech: Speech = .shared)
  {
    self.challengeProvider = challengeProvider
    self.resultsInterpreter = resultsInterpreter
    self.speech = speech
    challengeEntries = entryProvider.generate()
    performInitialSetup()
  }
  
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
    nextChallenge = challengeProvider.generatePick(fromPool: challengeEntries, index: visibleChallenges.count)
  }
  
  // MARK: - InputTappable conformance
  
  func inputTapped() {
    // TODO
  }
  
  // MARK: - SpeechDelegate conformance
  
  func speechEnded() {
    if case .voice = currentChallenge.inputRep {
      challengeMeasurement.start()
    } else if case .voice = currentChallenge.correctOutput,
              currentChallenge.correctAnswerIndex == voiceLastTappedIndex
    {
      challengeMeasurement.start()
    }
  }
  
  // MARK: - VoiceChallengeable conformance
  
  func chose(index: Int) {
    if case .voice(let rep) = currentChallenge.outputRep[index] {
      
      // When voice is the output type of the challenge, the user first has to tap on the
      // output button to hear the answer and tap the same output button again to choose
      // that answer, so we always remember what the last pressed button was
      if voiceLastTappedIndex == index && currentChallenge.correctAnswerIndex == index {
        goToNext()
        voiceLastTappedIndex = -1
      } else {
        voiceLastTappedIndex = index
        speech.speak(string: rep)
      }
    } else {
      if currentChallenge.correctAnswerIndex == index {
        goToNext()
      } else {
        if challengeStates.count != visibleChallenges.count {
          challengeStates.append(.guessedIncorrectly)
        }
      }
    }
  }
  
  // MARK: - Private
  
  private var challengeStates: [PickChallengeState] = []
  private var resultsInterpreter: ResultsInterpretable
  private var speech: Speech
  private var voiceLastTappedIndex: Int = -1
}
