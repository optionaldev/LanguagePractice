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

extension OutputQuizable where Challenge == OldPickChallenge {
  
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

protocol Quizable: ObservableObject {
  
  associatedtype Challenge: ChallengeProtocol
  
  /**
   An immutable list of challenge entries. These reflect the baseline for the quiz
   at hand. The actual challenges that are presented to the user are based on the
   entries.
   
   The reason why the actual challenges are not generated at the beginning of the
   quiz is because we might have for example an image that is currently being
   downloaded or in queue to be downloaded and we can't assume it will finish
   by the time the challenge is reached. Instead if we postpone the challenge
   generation, we can simply verify if the image download is finish and if not
   we generate a different type of challenge for that word.
   */
  var challengeEntries: [EntryProtocol] { get }
  
  /**
   In order to have stats to display to the user, measurements are made for each
   challenge and based on these measurements, we adjust not only our expectations
   from the user, but also if a challenge should be deemed completed or not.
   
   For someone that grinds all day, his version of a challenge being completed
   might be in under 2 seconds even for a long word. For someone that casually
   uses the app for 10 minutes a week, even 10 seconds might be within expectations.
   */
  var challengeMeasurement: ChallengeMeasurement { get }
  
  /**
   Challenge that the user is currently being done.
   */
  var currentChallenge: Challenge { get }
  
  /**
   Challenge that was prepared while the user was completing the current one. If __nil__,
   there are no more challenges and the results screen should be shown.
   */
  var nextChallenge: Challenge? { get set }
  
  /**
   Holds all the challenge that have been completed and the challenge that is currently
   being done. The user can scroll through all of these challenges at any give time.
   */
  
  var visibleChallenges: [Challenge] { get set }
  
  /**
   Used to display words that were considered "learned", based on different metrics.
   This is populated after the last challenge has been completed.
   */
  var itemsLearned: [LearnedItem] { get }
  
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
