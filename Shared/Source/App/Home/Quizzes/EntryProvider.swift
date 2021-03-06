//
// The LanguagePractice project.
// Created by optionaldev on 11/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

enum EntryType {
  
  case hiragana
  case katakana
  case words
}

struct EntryProvider {
  
  static func generate(_ entryType: EntryType) -> [EntryProtocol] {
    var source: [String]
    
    switch entryType {
      case .hiragana:
        source = Lexicon.shared.foreign.hiragana.map { $0.id }
        
      case .katakana:
        source = Lexicon.shared.foreign.katakana.map { $0.id }
      case .words:
        source = Lexicon.shared.foreign.nouns.map { $0.id }
    }
    
    let knownItems = Defaults.knownForeignItemIDs
    
    // We fetch all items that are yet to be learned & shuffle to prevent repetitiveness
    source = Array(source
                    .filter { !knownItems.contains($0) }
                    .shuffled()
                    .prefix(AppConstants.challengeInitialSampleSize))
    
    // We handle the case where there are less than 10 items left to learn
    if source.count < AppConstants.challengeInitialSampleSize {
      let extraItems = source.filter { knownItems.contains($0) }
        .prefix(AppConstants.challengeInitialSampleSize - source.count)
      
      source.append(contentsOf: extraItems)
    }
    
    guard source.count == AppConstants.challengeInitialSampleSize else {
      fatalError("Invalid number of elements")
    }
    
    let result: [EntryProtocol]
    
    switch entryType {
      case .hiragana:
        result = source.flatMap {[
          HiraganaEntry(roman: $0, kanaChallengeType: .foreign),
          HiraganaEntry(roman: $0, kanaChallengeType: .romanToForeign),
          HiraganaEntry(roman: $0, kanaChallengeType: .foreignToRoman)
        ]}
      case .katakana:
        result = source.flatMap {[
          KatakanaEntry(roman: $0, kanaChallengeType: .foreign),
          KatakanaEntry(roman: $0, kanaChallengeType: .romanToForeign),
          KatakanaEntry(roman: $0, kanaChallengeType: .foreignToRoman)
        ]}
      case .words:
        result = source.flatMap { generateEntries(forForeignWordID: $0) }
    }
    
    return result.shuffled()
  }
  
  private static func generateEntries(forForeignWordID id: String) -> [WordEntry] {
    guard let foreignNoun = Lexicon.shared.foreignDictionary[id] as? ForeignWord else {
      log("Unable to fetch and cast item with id \"\(id)\".")
      return []
    }
    var result = foreignNoun.english.flatMap {
      [WordEntry(inputLanguage: .english, input: $0, outputLanguage: .foreign, output: foreignNoun.id),
       WordEntry(inputLanguage: .foreign, input: foreignNoun.id, outputLanguage: .english, output: $0)
      ]
    }
    
    if foreignNoun.kana != nil {
      // For input, we could show multiple english translations, but for output only 1,
      // so for now, display only the first and keep DB with first english translation
      // being the most accurate one
      guard let translation = foreignNoun.english.first else {
        log("No english translation found for foreign word with ID \"\(foreignNoun.id)\"", type: .unexpected)
        return result
      }
      
      result.append(WordEntry(inputLanguage: .foreign, input: foreignNoun.id, outputLanguage: .foreign, output: translation))
    }
    return result
  }
}
