//
// The LanguagePractice project.
// Created by optionaldev on 21/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

final class WordEntryProvider: EntryProvidable {

  init(lexicon: Lexicon = .shared) {
    self.lexicon = lexicon
  }

  func generate() -> [Distinguishable] {
    return lexicon.foreign.all
      .filter { Defaults.knownIds(for: .picking).contains($0.id) == false }
      .prefix(AppConstants.challengeInitialSampleSize)
      .compactMap { $0 as? ForeignWord }
      .flatMap { generateEntries(forWord: $0) }
      .shuffled()
  }

  // MARK: - Private

  private let lexicon: Lexicon

  private func generateEntries(forWord word: ForeignWord) -> [WordEntry] {
    return WordEntry.Category.all
      .map { WordEntry(id: word.id, category: $0) }
  }
}
