//
// The LanguagePractice (iOS) project.
// Created by optionaldev on 03/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
//

enum ConjugateableType {
  
  case adjective
  case verb
}

final class ConjugatableEntryProvider {
  
  init(lexicon: Lexicon = .shared) {
    self.lexicon = lexicon
  }
  
  func generate(type: ConjugateableType) -> [ConjugatableEntry] {
    let source: [ForeignItem]
    switch type {
      case .adjective:
        source = lexicon.foreign.adjectives
      case .verb:
        source = lexicon.foreign.verbs
    }
    return source
      .prefix(AppConstants.challengeInitialSampleSize)
      .compactMap { $0 as? ForeignWord }
      .flatMap { generateEntries(forWord: $0) }
      .shuffled()
  }
  
  // MARK: - Private
  
  private let lexicon: Lexicon
  
  private func generateEntries(forWord word: ForeignWord) -> [ConjugatableEntry] {
    return ConjugatableEntryCategory.allCases
      .map { ConjugatableEntry(id: word.id, category: $0) }
  }
}
