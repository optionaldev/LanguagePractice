//
// The LanguagePractice project.
// Created by optionaldev on 21/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
//

import Foundation

final class KanaResultsInterpreter: ResultsInterpretable {
  
  func assess(entries: [Distinguishable], challenges: [PickChallenge], states: [PickState]) -> [LearnedItem] {
    
    guard entries.count == challenges.count && entries.count == states.count else {
      log("All these arrays should have equal amount of elements at the end of the challenges", type: .unexpected)
      return []
    }
    
    var history = Defaults.history(for: .picking)
    
    for (index, element) in states.enumerated() {
      let id = entries[index].id
      switch element {
        case .correct(let interval):
          if history[id] == nil {
            history[id] = [interval]
          } else {
            history[id]?.append(interval)
          }
        case .incorrect(let attempts):
          // TODO: Add some advanced tracking like which character is the user more likely to confuse
          if history[id] == nil {
            history[id] = [-1]
          } else {
            history[id]?.append(-1)
          }
      }
    }
    
    Defaults.set(history, forKey: .guessHistory)
    
    let knownIds = Defaults.knownIds(for: .picking)
    
    return entries
      .map { $0.id }
      .uniqueElements
      .filter { knownIds.contains($0) }
      .map { LearnedItem(character: $0, averageTime: history[$0]?.challengeAverage ?? 0) }
  }
}
