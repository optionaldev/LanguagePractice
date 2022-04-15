//
// The LanguagePractice project.
// Created by optionaldev on 10/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

enum ForeignVerbCategory: String, Codable {
  
  case regular
  
#if JAPANESE
  case iruEru
#endif
}

struct ForeignVerb: ForeignWord, ForeignConjugatable {
  
  let id: String
  let written: String
  let english: [String]
  let jlpt: Int?
  
  // TODO: Revert to being fetched from Codable
  var category: ForeignVerbCategory {
    return .iruEru
  }
  
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
    case jlpt     = "jl"
//    case category = "ca"
    
#if JAPANESE
    case furigana = "fg"
    case irregularKana = "ik"
    case readKana = "rk"
#endif
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
  
  private func conjugatePresent(negative: Bool, conjugationType: ConjugationType) -> Conjugation {
    var text: String = ""
    
    switch conjugationType {
      case .modifier:
        fatalError()
      case .formalEnding:
        
        switch category {
          case .regular:
            var result = written
            let postfix = baseForm(vowel: .i)
            result.append(postfix)
            result.append(AppConstants.masuEnding)
            text = result
          case .iruEru:
            text = written.removingLast().appending(AppConstants.masuEnding)
        }
      case .informalEnding:
        
        if negative {
          let base: String
          switch category {
            case .regular:
              base = baseForm(vowel: .a)
            case .iruEru:
              base = written.removingLast()
          }
          text = base.appending("ない")
        } else {
          text = written
        }
    }
    
    return Conjugation(id: text,
                       variation: .init(tense: .present,
                                        negative: negative,
                                        type: conjugationType))
  }
  
  private func conjugatePast(negative: Bool, conjugationType: ConjugationType) -> Conjugation {
    
    // TODO
    fatalError()
  }
  
  private func conjugateFuture(negative: Bool, conjugationType: ConjugationType) -> Conjugation {
    // Present and future are the same in Japanese
    // Differentiating between the two is based on sentence context
    return conjugatePresent(negative: negative, conjugationType: conjugationType)
  }
  
  private func conjugateWant(negative: Bool, conjugationType: ConjugationType) -> Conjugation {
    
    // TODO
    fatalError()
  }
  
  
  private func conjugateCan(negative: Bool, conjugationType: ConjugationType) -> Conjugation {
    
    // TODO
    fatalError()
  }
  
  private func conjugatePresentContinuous(negative: Bool, conjugationType: ConjugationType) -> Conjugation {
    
    // TODO
    fatalError()
  }
  
  // MARK: - ForeignConjugatable conformance
  
  
  func conjugate(tense: Tense, negative: Bool, type: ConjugationType) -> Conjugation {
    switch tense {
      case .present:
        return conjugatePresent(negative: negative, conjugationType: type)
      case .past:
        return conjugatePast(negative: negative, conjugationType: type)
      case .future:
        return conjugateFuture(negative: negative, conjugationType: type)
      case .want:
        return conjugateWant(negative: negative, conjugationType: type)
      case .can:
        return conjugateCan(negative: negative, conjugationType: type)
      case .presentContinuous:
        return conjugatePresentContinuous(negative: negative, conjugationType: type)
    }
  }
  
  static var possibleTenses: [Tense] {
    
    // TODO
    return []
  }
}
