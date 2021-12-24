//
// The LanguagePractice project.
// Created by optionaldev on 10/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

private struct Constants {
  
  static let formalEnding = "ます"
}

struct ForeignVerb: ForeignWord {
  
  let id: String
  let written: String
  let english: [String]
  let category: Category
  
  enum Category: String, Codable {
    
    case regular
    
    #if JAPANESE
    case iruEru
    #endif
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
    case category = "ca"
    
#if JAPANESE
    case furigana = "fg"
    case irregularKana = "ik"
    case readKana = "rk"
#endif
  }
  
  func conjugate(tense: VerbTense, formal: Bool) -> String {
    switch tense {
      case .present:
        return conjugatePresent(formal: formal)
      case .past:
        return conjugatePast(formal: formal)
      case .future:
        return conjugateFuture(formal: formal)
      case .want:
        return conjugateWant(formal: formal)
      case .can:
        return conjugateCan(formal: formal)
      case .presentContinuous:
        return conjugatePresentContinuous(formal: formal)
    }
  }
  
  // MARK: - Private
  
  private var readKana: Int?
  
  private var irregularKana: Int?
  
  private func conjugatePresent(formal: Bool) -> String {
    if formal {
      switch category {
        case .regular:
          var result = written
          let lastCharacter = result.removeLast()
          
          let postfix: String
          
          switch lastCharacter {
            case "う":
              postfix = "い"
            case "く":
              postfix = "き"
            case "す":
              postfix = "し"
            case "つ":
              postfix = "ち"
            case "ぬ":
              postfix = "に"
            case "ふ":
              postfix = "ひ"
            case "む":
              postfix = "み"
            case "る":
              postfix = "り"
            default:
              fatalError("What case is this?")
          }
          result.append(postfix)
          result.append(Constants.formalEnding)
          return result
          
        case .iruEru:
          return written.removingLast().appending(Constants.formalEnding)
      }
    } else {
      return written
    }
  }
  
  private func conjugatePast(formal: Bool) -> String {
    
    // TODO
    return ""
  }
  
  private func conjugateFuture(formal: Bool) -> String {
    
    // TODO
    return ""
  }
  
  private func conjugateWant(formal: Bool) -> String {
    
    // TODO
    return ""
  }
  
  
  private func conjugateCan(formal: Bool) -> String {
    
    // TODO
    return ""
  }
  
  private func conjugatePresentContinuous(formal: Bool) -> String {
    
    // TODO
    return ""
  }
}
