//
// The LanguagePractice project.
// Created by optionaldev on 10/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

private struct Constants {
  
  static let formalEnding = "ます"
}

enum ForeignVerbCategory: String, Codable {
  
  case regular
  
#if JAPANESE
  case iruEru
#endif
}

struct ForeignVerb: ForeignWord {
  
  let id: String
  let written: String
  let english: [String]
  let category: ForeignVerbCategory
  
#if JAPANESE
  let furigana: String?
  
  var groupFurigana: Bool {
    return irregularKana == 1
  }
  
  var shouldReadKana: Bool {
    return readKana == 1
  }
#endif
  
  enum CodingKeys: String, CodingKey {
    case id
    case written = "ch"
    case english = "en"
    case category = "ca"
    
#if JAPANESE
    case furigana = "fg"
    case irregularKana = "ik"
    case readKana = "rk"
#endif
  }
  
  func conjugate(tense: VerbTense, formal: Bool, negative: Bool) -> String {
    switch tense {
      case .present:
        return conjugatePresent(formal: formal, negative: negative)
      case .past:
        return conjugatePast(formal: formal, negative: negative)
      case .future:
        return conjugateFuture(formal: formal, negative: negative)
      case .want:
        return conjugateWant(formal: formal, negative: negative)
      case .can:
        return conjugateCan(formal: formal, negative: negative)
      case .presentContinuous:
        return conjugatePresentContinuous(formal: formal, negative: negative)
    }
  }
  
  // MARK: - Private
  
  private var readKana: Int?
  
  private var irregularKana: Int?
  
  private func baseForm(vowel: Vowel) -> String {
    switch category {
      case .regular:
        guard let lastSyllable = written.last else {
          fatalError("Not possible for a word to not have a last syllable")
        }
        guard let char = Lexicon.shared.foreign.hiragana.filter({ $0.written == String(lastSyllable) }).first else {
          fatalError("Not possible")
        }
        let row = char.position[0]
        let column = vowel.column
        
        guard let result = Lexicon.shared.foreign.hiragana.filter({ $0.position == [row, column] }).first else {
          fatalError("Didn't find character with row \(row) column \(column)")
        }
        return result.written
      case .iruEru:
        return written.removingLast()
    }
  }
  
  private func conjugatePresent(formal: Bool, negative: Bool) -> String {
    if formal {
      switch category {
        case .regular:
          var result = written
          let postfix = baseForm(vowel: .i)
          result.append(postfix)
          result.append(Constants.formalEnding)
          return result
        case .iruEru:
          return written.removingLast().appending(Constants.formalEnding)
      }
    } else {
      if negative {
        let base: String
        switch category {
          case .regular:
            base = baseForm(vowel: .a)
          case .iruEru:
            base = written.removingLast()
        }
        return base.appending("ない")
      } else {
        return written
      }
    }
  }
  
  private func conjugatePast(formal: Bool, negative: Bool) -> String {
    
    // TODO
    return ""
  }
  
  private func conjugateFuture(formal: Bool, negative: Bool) -> String {
    return conjugatePresent(formal: formal, negative: negative)
  }
  
  private func conjugateWant(formal: Bool, negative: Bool) -> String {
    
    // TODO
    return ""
  }
  
  
  private func conjugateCan(formal: Bool, negative: Bool) -> String {
    
    // TODO
    return ""
  }
  
  private func conjugatePresentContinuous(formal: Bool, negative: Bool) -> String {
    
    // TODO
    return ""
  }
}
