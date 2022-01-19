//
// The LanguagePractice (iOS) project.
// Created by optionaldev on 03/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
//

enum ConjugateableType {
  
  case adjective
  case verb
}

final class ConjugatableAdjectiveEntryProvider: ConjugatableEntryProvider, EntryProvidable {
  
  func generate() -> [Distinguishable] {
    return generate(source: lexicon.foreign.adjectives)
  }
}

final class ConjugatableVerbsEntryProvider: ConjugatableEntryProvider, EntryProvidable {
  
  func generate() -> [Distinguishable] {
    return generate(source: lexicon.foreign.verbs)
  }
}

class ConjugatableEntryProvider {
  
  init(lexicon: Lexicon = .shared) {
    self.lexicon = lexicon
  }
  
  func generate(source: [ForeignWord]) -> [Distinguishable] {
    return source
      .prefix(AppConstants.challengeInitialSampleSize)
      .flatMap { generateEntries(forWord: $0) }
      .shuffled()
  }
  
  // MARK: - Private
  
  let lexicon: Lexicon
  
  private func generateEntries(forWord word: ForeignWord) -> [Distinguishable] {
    return ConjugatableEntryCategory.all
      .map { ConjugatableEntry(id: word.id, category: $0) }
      .compactMap { $0 as? Distinguishable }
  }
}
