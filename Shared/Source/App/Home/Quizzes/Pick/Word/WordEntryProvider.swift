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
      // Filter already known words
      .filter { Defaults.knownIds(for: .picking).contains($0.id) == false }
      
    
      // In order to prevent compactMap on too many items, we select double
      // the amount of needed items and we expect that even after filtering
      // we will have enough items
      .prefix(AppConstants.challengeInitialSampleSize * 2)
    
      // Cast into ForeignWord, should always succeed
      .compactMap { $0 as? ForeignWord }
      
      // Even though Katakana is part of the dictionary, we don't
      // prioritize learning them because they're often words
      // that an English speaker can understand
      .filter { $0.written.containsKatakana == false }
      
      // Select a set amount to be used for the challenge
      .prefix(AppConstants.challengeInitialSampleSize)
      
      // Generate multiple entries for each word
      .flatMap { generateEntries(forWord: $0) }
      
      // Shuffle to prevent same entry challenge, one after the other
      // TODO: It's still possible after a shuffle that same entry challenge is next to each other
      // so we need an algorithm for splitting
      .shuffled()
  }

  // MARK: - Private

  private let lexicon: Lexicon

  private func generateEntries(forWord word: ForeignWord) -> [WordEntry] {
    return WordEntry.Category.all
      .map { WordEntry(id: word.id, category: $0) }
  }
}
