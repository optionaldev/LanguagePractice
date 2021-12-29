//
// The LanguagePractice project.
// Created by optionaldev on 29/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

enum ForeignAdjectiveCategory: String, Codable {
  
  #if JAPANESE
  case i
  case na
  #endif
}

struct ForeignAdjective: ForeignWord {
  
  let id: String
  let written: String
  let english: [String]
  let category: ForeignAdjectiveCategory
  
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
    case written  = "ch"
    case english  = "en"
    case category = "ca"
    
#if JAPANESE
    case furigana      = "fg"
    case irregularKana = "ik"
    case readKana      = "rk"
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
  
  private func conjugatePresent(formal: Bool, negative: Bool) -> String {
    var result: String
    switch category {
      case .i:
        if negative {
          result = written.removingLast()
        } else {
          result = written
        }
      case .na:
        result = written
        if negative {
          result.append(" じゃない")
        }
    }
    if formal {
      result.append(" です")
    }
    return result
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
