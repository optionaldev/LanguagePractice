//
// The LanguagePractice project.
// Created by optionaldev on 21/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
//

import Foundation

final class KanaResultsInterpreter: ResultsInterpretable {
  
  init(lexicon: Lexicon) {
    self.lexicon = lexicon
  }
  
  private let lexicon: Lexicon
  
  func assess(entries: [Distinguishable], challenges: [PickChallenge], states: [PickState]) -> QuizResult {
    
    guard entries.count == challenges.count && entries.count == states.count else {
      log("All these arrays should have equal amount of elements at the end of the challenges", type: .unexpected)
      return .learnedNothing
    }
    
    var history = Defaults.history(for: .picking)
    
    func addInterval(_ interval: TimeInterval, forId id: String) {
      // TODO: Add some advanced tracking like which character is the user more likely to confuse
      if history[id] == nil {
        history[id] = [interval]
      } else {
        history[id]?.append(interval)
      }
    }
    
    for (index, element) in states.enumerated() {
      let id = entries[index].id
      switch element {
        case .correct(let interval):
          addInterval(interval, forId: id)
        case .incorrect(let attempts):
          addInterval(-1, forId: id)
      }
    }
    
    Defaults.set(history, forKey: .guessHistory)
    
    let knownIds = Defaults.knownIds(for: .picking)
    
    let result = entries
      .map { $0.id }
      .uniqueElements
      .filter { knownIds.contains($0) }
      .compactMap { lexicon.foreignDictionary[$0] }
      .map { LearnedItem(character: $0.written, averageTime: history[$0.id]?.challengeAverage ?? 0) }
    
    if result.count == 0 {
      return .learnedNothing
    }
    return .learnedSomething(result)
  }
}
