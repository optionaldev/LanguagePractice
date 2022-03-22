//
// The LanguagePractice project.
// Created by optionaldev on 19/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

import Dispatch
import protocol SwiftUI.ObservableObject

protocol Quizing: ObservableObject {
  
  associatedtype Challenge: Challengeable
  
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
  var challengeEntries: [Distinguishable] { get }
  
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
  
  /**
   Use to provide the next challenge.
   In some scenarios, when going to settings tab and coming back, if current challenge isn't viable anymore, it is rebuilt.
   */
  var challengeProvider: ChallengeProvidable { get }
  
  /**
   When the current speech ends, if there is a queued speech, it is immediately played after the current one.
   This separation happens when the first line and the second line are different languages.
   */
  var queuedVoiceLine: String? { get set }
  
  /**
   On appear is triggered even during scrolling of the LazyStack, so we need to differentiate between
   when the view is appearing for the first time and when the view is reappearing
   */
  var inputSpoken: Bool { get set }
  
  func challengeAppeared()
  func finishedCurrentChallenge()
  func handleFinish()
  func inputTapped(initial: Bool)
  func goToNext()
  func performInitialSetup()
  func prepareNextChallenge()
}

extension Quizing {
  
  var currentChallenge: Challenge {
    return visibleChallenges.last!
  }
  
  func inputTapped(initial: Bool) {
    guard (initial && !inputSpoken) || !initial else {
      return
    }
    inputSpoken = true
    if case .voice(let rep) = currentChallenge.inputRep {
      if let secondVoiceLine = rep.secondPart {
        queuedVoiceLine = secondVoiceLine
      }
      Speech.shared.speak(string: rep.firstPart)
    }
  }
  
  func goToNext() {
    inputSpoken = false
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
  
  // MARK: - Private
  
  private func prepareNextChallengeIfAvailable() {
    guard visibleChallenges.count < challengeEntries.count else {
      return
    }
    
    prepareNextChallenge()
  }
}
