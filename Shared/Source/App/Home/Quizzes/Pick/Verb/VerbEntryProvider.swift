//
// The LanguagePractice project.
// Created by optionaldev on 24/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

final class VerbEntryProvider {
  
  init(lexicon: Lexicon = .shared) {
    self.lexicon = lexicon
  }
  
  func generate(formal: Bool, tenses: [VerbTense]) -> [VerbEntry] {
    return lexicon.foreign.all
      .prefix(AppConstants.challengeInitialSampleSize)
      .compactMap { $0 as? ForeignWord }
      .flatMap { generateEntries(forWord: $0, formal: formal, tenses: tenses) }
      .shuffled()
  }
  
  // MARK: - Private
  
  private let lexicon: Lexicon
  
  private func generateEntries(forWord word: ForeignWord, formal: Bool, tenses: [VerbTense]) -> [VerbEntry] {
    return VerbTense.allCases
      .filter { tenses.contains($0) }
      .map { VerbEntry(id: word.id, formal: formal, category: $0) }
  }
}
