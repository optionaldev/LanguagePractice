//
// The LanguagePractice project.
// Created by optionaldev on 23/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

import Dispatch

import struct Foundation.Date
import struct Foundation.TimeInterval

import protocol SwiftUI.ObservableObject

protocol OutputQuizable: Quizable {
  
  var voiceLastTappedIndex: Int { get set }
  
  func chose(index: Int)
}

extension OutputQuizable where Challenge == PickChallenge {
  
  func chose(index: Int) {
    switch currentChallenge.outputRepresentations[index] {
      case .voice(let rep):
        // When voice is the output type of the challenge, the user first has to tap on the
        // output button to hear the answer and tap the same output button again to choose
        // that answer, so we always remember what the last pressed button was
        if voiceLastTappedIndex == index && currentChallenge.correctAnswerIndex == index {
          goToNext()
          voiceLastTappedIndex = -1
        } else {
          voiceLastTappedIndex = index
          Speech.shared.speak(string: rep.text, language: rep.language)
        }
      default:
        if currentChallenge.correctAnswerIndex == index {
          goToNext()
        } else {
          visibleChallenges[visibleChallenges.count - 1].state = .guessedIncorrectly
        }
    }
  }
  
  func challengeAppeared() {
    if !currentChallenge.inputRepresentation.voiceChallenge &&
        !currentChallenge.outputRepresentations[0].voiceChallenge
    {
      challengeMeasurement.start()
    }
  }
}

final class ChallengeMeasurement {
  
  /// Defines the point at which the challenge measurement time starts.
  ///
  /// When a challenge starts is different based on the type of challenge the user is given.
  ///
  /// For challenges where information is instantly visible (e.g: text challenges, image
  /// challenges), the value is set as soon as all the challenge elements are visible
  /// (taking animation into consideration)
  ///
  /// For challenges where information is not instantly visible (e.g: voice challenges)
  /// the value is set after the sound is heard. For input, this means after the screen is
  /// presented and the sound has been heard. For output, this means after the correct
  /// answer has been heart the firs time
  private var startTime: Date? = nil
  
  func start() {
    if startTime == nil {
      log("challenge measurement START >>>>>>>>")
      startTime = Date()
    }
  }
  
  func stopAndFetchResult() -> TimeInterval {
    if let time = startTime {
      let measurement = time.distance(to: Date())
      startTime = nil
      log("challenge measurement STOP ||||||| measurement = \(measurement)")
      return measurement
    }
    startTime = nil
    log("Should always called fetch after starting", type: .unexpected)
    return .zero
  }
}

protocol Quizable: ObservableObject {
  
  associatedtype Challenge: ChallengeProtocol
  
  var challengeEntries: [EntryProtocol] { get }
  
  var challengeMeasurement: ChallengeMeasurement { get }
  
  /// Challenge that the user is currently seeing (unless the content was scrolled)
  var currentChallenge: Challenge { get }
  
  /// Challenge that was prepared for when the user finished the current one. When the
  /// value is nil, there are no more challenges and the results screen should be prepared.
  var nextChallenge: Challenge? { get set }
  
  /// Holds all the challenge that have been completed and the challenge that is currently
  /// being done.
  var visibleChallenges: [Challenge] { get set }
  
  /// Used to display words that were considered "learned", based on different metrics.
  ///
  /// This is populated after the last challenge has been completed.
  var itemsLearned: [LearnedItem] { get }
  
  init(entryType: EntryType)
  
  func challengeAppeared()
  func finishedCurrentChallenge()
  func handleFinish()
  func inputTapped()
  func goToNext()
  func performInitialSetup()
  func prepareNextChallenge()
}

extension Quizable {
  
  var currentChallenge: Challenge {
    return visibleChallenges.last!
  }
  
  func inputTapped() {
    if case .voice(let rep) = currentChallenge.inputRepresentation {
      Speech.shared.speak(string: rep.text, language: rep.language)
    }
  }
  
  func goToNext() {
    finishedCurrentChallenge()
    
    if let nextChallenge = nextChallenge {
      visibleChallenges.append(nextChallenge)
      challengeAppeared()
    } else {
      handleFinish()
    }
    
    // At this point, we've already appended the `nextChallenge` to the `history` array
    nextChallenge = nil
    
    DispatchQueue.global(qos: .userInitiated).async {
      self.prepareNextChallengeIfAvailable()
    }
  }
  
  func performInitialSetup() {
    prepareNextChallengeIfAvailable()
    
    guard let challenge = nextChallenge else {
      log("no next challenge", type: .unexpected)
      return
    }
    visibleChallenges.append(challenge)
    challengeAppeared()
    
    prepareNextChallengeIfAvailable()
  }
  
  func challengeAppeared() {
    if !currentChallenge.inputRepresentation.voiceChallenge {
      challengeMeasurement.start()
    }
  }
  
  // MARK: - Private
  
  private func prepareNextChallengeIfAvailable() {
    guard visibleChallenges.count < challengeEntries.count else {
      return
    }
    
    prepareNextChallenge()
  }
}
