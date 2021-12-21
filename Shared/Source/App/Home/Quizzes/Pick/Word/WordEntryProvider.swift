//
// The LanguagePractice project.
// Created by optionaldev on 21/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

final class WordEntryProvider {

  init(lexicon: Lexicon = .shared) {
    self.lexicon = lexicon
  }

  func generate() -> [WordEntry] {
    return lexicon.foreign.all
      .prefix(AppConstants.challengeInitialSampleSize)
      .compactMap { $0 as? ForeignWord }
      .flatMap { generateEntries(forWord: $0) }
      .shuffled()
  }

  // MARK: - Private

  private let lexicon: Lexicon

  private func generateEntries(forWord word: ForeignWord) -> [WordEntry] {
    return WordEntry.Category.allCases
      .map { WordEntry(id: word.id, category: $0) }
  }
}
