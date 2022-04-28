//
// The LanguagePractice project.
// Created by optionaldev on 18/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

import class Foundation.DispatchQueue
import class Foundation.NumberFormatter
import class Foundation.UserDefaults
import class Foundation.NSKeyValueObservation

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

enum PickState {
  
  case incorrect(_ attempts: [PickPress])
  case correct(_ timeToCompletion: TimeInterval)
}

struct TypingState {
  
}


protocol ResultsInterpretable {
  
  func assess(entries: [Distinguishable], challenges: [PickChallenge], states: [PickState]) -> QuizResult
  func assess(entries: [Distinguishable], challenges: [TypingChallenge], states: [TypingState]) -> QuizResult
}

// TODO: remove extension
extension ResultsInterpretable {
  
  func assess(entries: [Distinguishable], challenges: [PickChallenge], states: [PickState]) -> QuizResult { return .learnedNothing }
  func assess(entries: [Distinguishable], challenges: [TypingChallenge], states: [TypingState]) -> QuizResult { return .learnedNothing }
}

extension UserDefaults {
  @objc dynamic var voiceEnabled: Int {
    return integer(forKey: "voiceEnabled")
  }
}

final class PickQuizViewModel: Quizing, ObservableObject, SpeechDelegate, VoiceChallengeable, InputTappable {
  
  @Published var visibleChallenges: [PickChallenge] = []
  @Published var quizResult: QuizResult?
  
  var observer: NSKeyValueObservation?
  
  var inputSpoken: Bool = false
  var nextChallenge: PickChallenge?
  var queuedVoiceLine: String?
  
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
    challengeEntries = entryProvider.generate()
    
    self.speech = speech
    speech.delegate = self
    
    performInitialSetup()
    
    observer = UserDefaults.standard.observe(\.voiceEnabled, options: [.new], changeHandler: { [weak self] (_, _) in
      self?.removeVoiceChallengesIfTurnedOff()
    })
  }
  
  private func removeVoiceChallengesIfTurnedOff() {
    var newChallengeNeeded = false
    if case .voice = currentChallenge.inputRep {
      newChallengeNeeded = true
    }
    if case .voice = currentChallenge.correctOutput {
      newChallengeNeeded = true
    }
    
    if newChallengeNeeded {
      let newChallenge = challengeProvider.generatePick(fromPool: challengeEntries,
                                                        index: visibleChallenges.count - 1)
      var copy = visibleChallenges
      copy.removeLast()
      copy.append(newChallenge)
      self.visibleChallenges = copy
    }
  }
  
  deinit {
    observer?.invalidate()
  }
  
  func challengeAppeared() {
    if case .voice = currentChallenge.inputRep {
      // nothing to do here
    } else if case .voice = currentChallenge.correctOutput {
      // nothing to do here
    } else {
      challengeMeasurement.start()
    }
  }
  
  func handleFinish() {
    quizResult = resultsInterpreter.assess(entries: challengeEntries, challenges: visibleChallenges, states: challengeStates)
  }
  
  func finishedCurrentChallenge() {
    voiceLastTappedIndex = -1
    let lastMeasurement = challengeMeasurement.stopAndFetchResult()
    if valuesPressed.isEmpty {
      challengeStates.append(.correct(lastMeasurement))
    } else {
      valuesPressed.append(PickPress(index: currentChallenge.correctAnswerIndex, time: lastMeasurement))
      challengeStates.append(.incorrect(valuesPressed))
      valuesPressed = []
    }
  }
  
  func prepareNextChallenge() {
    nextChallenge = challengeProvider.generatePick(fromPool: challengeEntries, index: visibleChallenges.count)
  }
  
  // MARK: - SpeechDelegate conformance
  
  func speechEnded() {
    if let voiceLine = queuedVoiceLine {
      queuedVoiceLine = nil
      speech.speak(string: voiceLine)
    } else {
      if case .voice = currentChallenge.inputRep {
        challengeMeasurement.start()
      } else if case .voice = currentChallenge.correctOutput,
                currentChallenge.correctAnswerIndex == voiceLastTappedIndex
      {
        challengeMeasurement.start()
      }
    }
  }
  
  // MARK: - VoiceChallengeable conformance
  
  func chose(index: Int) {
    if case .voice(let rep) = currentChallenge.outputRep[index] {
      // When voice is the output type of the challenge, the user first has to tap on the
      // output button to hear the answer and tap the same output button again to choose
      // that answer, so we always remember what the last pressed button was
      if voiceLastTappedIndex == index {
        if currentChallenge.correctAnswerIndex == index {
          goToNext()
        } else {
          addCurrentFailure(index: index)
        }
      } else {
        speech.speak(string: rep)
        if voiceLastTappedIndex != -1 {
          // If we already have failing values, it means the user chose a wrong value again
          addCurrentFailure(index: index)
        }
        voiceLastTappedIndex = index
      }
    } else {
      if currentChallenge.correctAnswerIndex == index {
        goToNext()
      } else {
        addCurrentFailure(index: index)
      }
    }
  }

  // MARK: - Private
  
  private var challengeStates: [PickState] = []
  private var resultsInterpreter: ResultsInterpretable
  private var speech: Speech
  private var valuesPressed: [PickPress] = []
  private var voiceLastTappedIndex: Int = -1
  
  private func addCurrentFailure(index: Int) {
    guard challengeMeasurement.isStarted else {
      // For voice challenge, we don't start the measurement immediately 
      return
    }
    valuesPressed.append(PickPress(index: index, time: challengeMeasurement.fetchElapsedAndContinue()))
  }
}

struct PickPress {
  
  let index: Int
  let time: TimeInterval
}
