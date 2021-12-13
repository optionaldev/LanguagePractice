//
// The LanguagePractice project.
// Created by optionaldev on 08/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

import class Foundation.DispatchQueue
import class Foundation.NumberFormatter

import protocol Foundation.ObservableObject

import struct Foundation.Date
import struct Foundation.Published
import struct Foundation.TimeInterval


final class PickQuizViewModel: OutputQuizable, ObservableObject, SpeechDelegate {
  
  @Published var visibleChallenges: [PickChallenge] = []
  
  @Published private(set) var itemsLearned: [LearnedItem] = []
  
  private(set) var challengeMeasurement = ChallengeMeasurement()
  
  private(set) var challengeEntries: [EntryProtocol]
  
  var nextChallenge: PickChallenge? = nil
  
  init(entryType: EntryType) {
    challengeEntries = EntryProvider.generate(entryType)
    performInitialSetup()
    
    Speech.shared.delegate = self
  }
  
  var voiceLastTappedIndex: Int = -1
  
  func finishedCurrentChallenge() {
    if visibleChallenges[visibleChallenges.count - 1].state != .guessedIncorrectly {
      let challengeTime = challengeMeasurement.stopAndFetchResult()
      visibleChallenges[visibleChallenges.count - 1].state = .finished(challengeTime)
    }
  }
  
  func prepareNextChallenge() {
    nextChallenge = ChallengeProvider.generatePick(pool: challengeEntries, index: visibleChallenges.count)
  }
  
  func handleFinish() {
    var guessHistory: [String: [TimeInterval]] = Defaults.history(for: .picking)
    
    for (index, challenge) in visibleChallenges.enumerated() {
      // History is recorded based on the foreign word ID, because that's what is being learned
      let id = challengeEntries[index].foreignID
      
      if let value = challenge.state?.storeValue {
        if guessHistory[id] == nil {
          guessHistory[id] = [value]
        } else {
          guessHistory[id]?.append(value)
        }
      } else {
        fatalError("Should never end without a state for every challenge")
      }
    }
    
    // In order to prevent showing items learned for items that have been learned in the past
    // but have made their way into the challenge because we didn't have enough non-learned
    // items to fulfill the minimum requirement of AppConstants.challengeInitialSampleSize,
    // we let the first `for` complete and do another one for newly learned items
    
    log("Guess history:")
    let numberFormatter = NumberFormatter()
    numberFormatter.maximumFractionDigits = 1
    _ = guessHistory.map { print("\($0.key) \($0.value.compactMap { numberFormatter.string(for: $0) }.joined(separator: " "))") }
    
    let knownItemsBeforeChallenge = Set(Defaults.knownIds(for: .picking))
    Defaults.set(guessHistory, forKey: .guessHistory)
    let knownItemsNow = Set(Defaults.knownIds(for: .picking))
    
    let newlyLearnedItemIDs = knownItemsNow.subtracting(knownItemsBeforeChallenge)
    
    if newlyLearnedItemIDs.isEmpty {
      fatalError("wait just a minute pal")
    }
    
    itemsLearned = newlyLearnedItemIDs.map { LearnedItem(character: Lexicon.shared.foreignDictionary[$0]?.written ?? "",
                                                         averageTime: guessHistory[$0]?.challengeAverage ?? Random.double(inRange: 1..<10)) }
  }
  
  // MARK: - SpeechDelegate conformance
  
  func speechEnded() {
    if case .voice = currentChallenge.inputType {
      challengeMeasurement.start()
    } else if case .voice = currentChallenge.outputType,
              currentChallenge.correctAnswerIndex == voiceLastTappedIndex
    {
      challengeMeasurement.start()
    }
  }
}
