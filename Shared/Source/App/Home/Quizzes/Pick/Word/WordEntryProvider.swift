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
    var words = lexicon.foreign.all
      // Filter already known words
      .filter { Defaults.knownIds(for: .picking).contains($0.id) == false }
    
      // Excluse characters since we're only interested in words
      .compactMap { $0 as? ForeignWord }
    
      // We want to start by learning JLPT5 words and leave non-JLPT words at the end
      .sorted { ($0.jlpt ?? 0) > ($1.jlpt ?? 0) }
    
      // In order to prevent compactMap on too many items, we select double
      // the amount of needed items and we expect that even after filtering
      // we will have enough items
      .prefix(AppConstants.challengeInitialSampleSize * 2)
    
      // Even though Katakana is part of the dictionary, we don't
      // prioritize learning them because they're often words
      // that an English speaker can understand
      .filter { $0.written.containsKatakana == false }
      
      // Select a set amount to be used for the challenge
      .prefix(AppConstants.challengeInitialSampleSize)
      
      // Generate multiple entries for each word
      .flatMap { generateEntries(forWord: $0) }
      
      // Shuffle to prevent same entry challenge, one after the other
      .shuffled()
    
    shuffleUntilNoDuplicates(&words)
    
    print(words.compactMap { $0.id }.joined(separator: "\n"))
    
    return words
  }

  // MARK: - Private

  private let lexicon: Lexicon

  private func generateEntries(forWord word: ForeignWord) -> [WordEntry] {
    return WordEntry.Category.all
      .map { WordEntry(id: word.id, category: $0) }
  }
  
  private func shuffleUntilNoDuplicates(_ words: inout [WordEntry]) {
    var firstDuplicate: Int?
    var secondDuplicate: Int?
    
    for index in 0..<words.count {
      if index + 1 < words.count && words[index].id == words[index + 1].id {
        if firstDuplicate == nil {
          firstDuplicate = index
        } else {
          if secondDuplicate == nil {
            secondDuplicate = index
          } else {
            // Already have 2 duplicates and found a third
            // Call the manual management off and try reshuffling
            words.shuffle()
            shuffleUntilNoDuplicates(&words)
            return
          }
        }
      }
    }
    
    if let first = firstDuplicate {
      if let second = secondDuplicate {
        let firstValue = words[first]
        let secondValue = words[second]
        
        words[first] = secondValue
        words[second] = firstValue
      } else {
        let element = words.remove(at: first)
        if first > 10 {
          words.insert(element, at: 0)
        } else {
          words.append(element)
        }
      }
      
      shuffleUntilNoDuplicates(&words)
    }
  }
}
