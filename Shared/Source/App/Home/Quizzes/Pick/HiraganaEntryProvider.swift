//
// The LanguagePractice project.
// Created by optionaldev on 14/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

final class HiraganaEntryProvider {
  
  init(lexicon: Lexicon = Lexicon.shared) {
    self.lexicon = lexicon
  }
  
  func generate() -> [HiraganaEntry] {
    return lexicon.foreign.hiragana.flatMap { generateHiragana(forCharacter: $0) }
    
  }
  
  // MARK: - Private
  
  private let lexicon: Lexicon
  
  private func generateHiragana(forCharacter character: ForeignCharacter) -> [HiraganaEntry] {
    return HiraganaEntry.Category.allCases
      .shuffled()
      .prefix(2)
      .map { HiraganaEntry(id: character.id, category: $0) }
  }
}
