//
// The LanguagePractice project.
// Created by optionaldev on 29/11/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

import Dispatch

import class Foundation.DispatchQueue
import class Foundation.NumberFormatter

import protocol Foundation.ObservableObject

import struct Foundation.Date
import struct Foundation.Published
import struct Foundation.TimeInterval


final class TypingQuizViewModel: Quizable, ObservableObject, SpeechDelegate {
  
  @Published var visibleChallenges: [TypingChallenge] = []
  
  @Published private(set) var itemsLearned: [LearnedItem] = []
  
  // Reflects whether the answers are displayed when remaining is equal to the 'forfeitRetriesCount' in Constants
  @Published private(set) var challengeState: TypingQuizState = .regular
  
  private(set) var challengeMeasurement = ChallengeMeasurement()
  
  private(set) var challengeEntries: [EntryProtocol]
  
  var nextChallenge: TypingChallenge? = nil
  
  @Published var currentText: String = "" {
    didSet {
//      log("currentText = \(currentText)")
      if currentText != "" {
        verifyText()
      }
    }
  }
  
  init() {
    let entries = EntryProvider.generateTyping()
    
    // We want to take entries in the order of their language during a typing challenge
    // so that the user only has to change his keyboard language once
    let englishEntries = entries.filter { $0.inputLanguage == .english }
    let foreignEntries = entries.filter { $0.inputLanguage == .foreign }
    challengeEntries = englishEntries + foreignEntries
    performInitialSetup()
    
    Speech.shared.delegate = self
  }
  
  func finishedCurrentChallenge() {
    if currentChallenge.state != .guessedIncorrectly,
       let index = currentChallenge.output.firstIndex(of: currentText)
    {
      let challengeTime = challengeMeasurement.stopAndFetchResult()
      visibleChallenges[visibleChallenges.count - 1].state = .finished(challengeTime, index)
    }
  }
  
  func prepareNextChallenge() {
    nextChallenge = ChallengeProvider.generateTyping(pool: challengeEntries, index: visibleChallenges.count)
  }
  
  func handleFinish() {
  }
  
  func forfeitCurrentChallenge() {
    currentText = ""
    challengeState = .forfeited(AppConstants.forfeitRetriesCount)
  }
  
  // MARK: - Private
  
  private func verifyText() {
    // To make it easy to practice in simulator (maybe macOS too)
    // make § key (above Tab key) a quick forfeit
    if currentText.contains("§") {
      forfeitCurrentChallenge()
      return
    }
    
    // In order to avoid having situations like:
    //  - accidental double space between words
    //  - accidental space before the first word
    //  - japanese space vs english space (they are different characters)
    //  - user typing dont instead of don't
    // and other things like this, we ignore any special characters.
    // TODO: Handle allowing 1,2,3 as a guess answer for ー, 二, 三 etc
    let processedGuess = currentText.filter { $0.isLetter }.lowercased()
    let processedAnswers = currentChallenge.output.map { $0.filter { $0.isLetter }.lowercased() }
    
    if processedAnswers.contains(processedGuess) {
      // Trying to immediately set 'currentText' to empty string results in a glitch
      // where the previous text is still visible after making the change
      // This only happens on Release builds even though it doesn't seem related to optimization level
      // This also only happens when trying to change multiple @Published elements, probably causing
      // the view to be in an undefined state
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        self.currentText = ""
      }
      
      switch challengeState {
        case .regular:
          goToNext()
        case .forfeited(let remainingGuessesNeeded):
          handleReset(remaining: remainingGuessesNeeded - 1)
      }
    } else {
//      log("currentText \"\(currentText)\" not part of valid answers: \(currentChallenge.output)")
    }
  }
  
  func handleReset(remaining remainingGuessesNeeded: Int) {
    if remainingGuessesNeeded == 1 {
      challengeState = .regular
    } else {
      challengeState = .forfeited(remainingGuessesNeeded)
    }
  }
  
  // MARK: - SpeechDelegate conformance
  
  func speechEnded() {
    
  }
}
