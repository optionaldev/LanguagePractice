//
// The LanguagePractice project.
// Created by optionaldev on 18/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import class Foundation.DispatchQueue
import class Foundation.NumberFormatter

import protocol Foundation.ObservableObject

import struct Foundation.Date
import struct Foundation.Published
import struct Foundation.TimeInterval

protocol Challengeable: Equatable {
  
  var id: String { get }
}

protocol Quizzical {
  
  associatedtype Challenge: Challengeable
  
  var visibleChallenges: [Challenge] { get }
  
  var currentChallenge: Challenge { get }
  
  var itemsLearned: [LearnedItem] { get }
  
  func inputTapped()
}


final class HiraganaPickQuizViewModel: Quizzical, ObservableObject, SpeechDelegate {
  
  @Published var visibleChallenges: [PickChallenge] = []
  
  @Published private(set) var itemsLearned: [LearnedItem] = []
  
  private(set) var challengeMeasurement = ChallengeMeasurement()
  
  private(set) var challengeEntries: [KanaEntry]
  
  var nextChallenge: PickChallenge? = nil
  
  private let challengeProvider = KanaPickChallengeProvider()
  
  private var challengeResults: [OldPickChallengeState] = []
  
  private let speech: Speech
  private let lexicon: Lexicon
  
  init(lexicon: Lexicon = Lexicon.shared, speech: Speech = Speech.shared) {
    self.lexicon = lexicon
    self.speech = speech
    challengeEntries = KanaEntryProvider().generate()
    performInitialSetup()
    
    Speech.shared.delegate = self
  }
  
  var voiceLastTappedIndex: Int = -1
  
  func finishedCurrentChallenge() {
    let challengeTime = challengeMeasurement.stopAndFetchResult()
    if challengeResults.count <= currentIndex {
      challengeResults.append(.finished(challengeTime))
    } else if challengeResults[currentIndex] != .guessedIncorrectly {
      challengeResults[currentIndex] = .finished(challengeTime)
    }
  }
  
  func prepareNextChallenge() {
    nextChallenge = challengeProvider.generate(fromPool: challengeEntries, index: visibleChallenges.count)
  }
  
  func chose(index: Int) {
    switch currentChallenge.correctOutput {
      case .voice(let spoken):
        // When voice is the output type of the challenge, the user first has to tap on the
        // output button to hear the answer and tap the same output button again to choose
        // that answer, so we always remember what the last pressed button was
        if voiceLastTappedIndex == index && currentChallenge.correctAnswerIndex == index {
          goToNext()
          voiceLastTappedIndex = -1
        } else {
          voiceLastTappedIndex = index
          Speech.shared.speak(string: spoken)
        }
      case .text:
        if currentChallenge.correctAnswerIndex == index {
          goToNext()
        } else {
          if challengeResults.count <= currentIndex {
            challengeResults.append(.guessedIncorrectly)
          }
        }
      default:
        fatalError("Ds")
    }
  }
  
  func challengeAppeared() {
    if case .voice(_) = currentChallenge.inputRep {
      return
    } else if case .voice(_) = currentChallenge.correctOutput {
      return
    }
    challengeMeasurement.start()
  }
  
  func handleFinish() {
//    var guessHistory: [String: [TimeInterval]] = Defaults.history(for: .picking)
//
//    for (index, challenge) in visibleChallenges.enumerated() {
//      // History is recorded based on the foreign word ID, because that's what is being learned
//      let id = challengeEntries[index].id
//
//      if let value = challenge.state?.storeValue {
//        if guessHistory[id] == nil {
//          guessHistory[id] = [value]
//        } else {
//          guessHistory[id]?.append(value)
//        }
//      } else {
//        fatalError("Should never end without a state for every challenge")
//      }
//    }
//
//    // In order to prevent showing items learned for items that have been learned in the past
//    // but have made their way into the challenge because we didn't have enough non-learned
//    // items to fulfill the minimum requirement of AppConstants.challengeInitialSampleSize,
//    // we let the first `for` complete and do another one for newly learned items
//
//    log("Guess history:")
//    let numberFormatter = NumberFormatter()
//    numberFormatter.maximumFractionDigits = 1
//    _ = guessHistory.map { print("\($0.key) \($0.value.compactMap { numberFormatter.string(for: $0) }.joined(separator: " "))") }
//
//    let knownItemsBeforeChallenge = Set(Defaults.knownIds(for: .picking))
//    Defaults.set(guessHistory, forKey: .guessHistory)
//    let knownItemsNow = Set(Defaults.knownIds(for: .picking))
//
//    let newlyLearnedItemIDs = knownItemsNow.subtracting(knownItemsBeforeChallenge)
//
//    if newlyLearnedItemIDs.isEmpty {
//      fatalError("wait just a minute pal")
//    }
//
//    itemsLearned = newlyLearnedItemIDs.map { LearnedItem(character: Lexicon.shared.foreignDictionary[$0]?.written ?? "",
//                                                         averageTime: guessHistory[$0]?.challengeAverage ?? Random.double(inRange: 1..<10)) }
  }
  
  // MARK: - SpeechDelegate conformance
  
  
  func speechEnded() {
    if case .voice(_) = currentChallenge.inputRep {
      challengeMeasurement.start()
    }
    if case .voice(_) = currentChallenge.correctOutput,
       voiceLastTappedIndex == currentChallenge.correctAnswerIndex
    {
      challengeMeasurement.start()
    }
  }
  
  var currentChallenge: PickChallenge {
    return visibleChallenges[currentIndex]
  }
  
  var currentEntry: KanaEntry {
    return challengeEntries[currentIndex]
  }
        
        var currentIndex: Int {
         return visibleChallenges.count - 1
       }
  
  var currentCharacter: ForeignCharacter {
    guard let character = lexicon.foreignDictionary[currentEntry.id] as? ForeignCharacter else {
      fatalError("Couldn't find/cast character for id = \(currentEntry.id)")
    }
    return character
  }
  
  func inputTapped() {
    if case .voice(_) = currentChallenge.inputRep {
      speech.speak(string: currentCharacter.spoken, language: .foreign)
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
  
  // MARK: - Private
  
  private func prepareNextChallengeIfAvailable() {
    guard visibleChallenges.count < challengeEntries.count else {
      return
    }
    
    prepareNextChallenge()
  }
}
