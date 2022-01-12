//
// The LanguagePractice project.
// Created by optionaldev on 14/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

final class KanaEntryProvider {
  
  init(lexicon: Lexicon = Lexicon.shared) {
    self.lexicon = lexicon
  }
  
  func generate() -> [KanaEntry] {
    return lexicon.foreign.hiragana
      .prefix(AppConstants.challengeInitialSampleSize)
      .flatMap { generateEntries(forCharacter: $0) }
      .shuffled()
  }
  
  // MARK: - Private
  
  private let lexicon: Lexicon
  
  private func generateEntries(forCharacter character: ForeignCharacter) -> [KanaEntry] {
    return KanaEntry.Category.all
      .map { KanaEntry(id: character.id, category: $0) }
  }
}
