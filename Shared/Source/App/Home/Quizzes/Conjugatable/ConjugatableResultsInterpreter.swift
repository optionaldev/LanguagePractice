//
// The LanguagePractice project.
// Created by optionaldev on 20/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
//

import class Foundation.NumberFormatter

import struct Foundation.TimeInterval


final class ConjugatableResultsInterpreter: ResultsInterpretable {
  
  func assessResults(entries: [Distinguishable], states: [TimeStorable]) -> [LearnedItem] {
    var guessHistory: [String: [TimeInterval]] = Defaults.history(for: .picking)
    
    for (index, entry) in entries.enumerated() {
      // History is recorded based on the foreign word ID, because that's what is being learned
      let id = entry.id
      
      let value = states[index].storeValue
      if guessHistory[id] == nil {
        guessHistory[id] = [value]
      } else {
        guessHistory[id]?.append(value)
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
    
    return newlyLearnedItemIDs.map { LearnedItem(character: Lexicon.shared.foreignDictionary[$0]?.written ?? "",
                                                 averageTime: guessHistory[$0]?.challengeAverage ?? Random.double(inRange: 1..<10)) }
  }
}
