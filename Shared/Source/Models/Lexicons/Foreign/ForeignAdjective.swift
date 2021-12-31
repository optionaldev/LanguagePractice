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
  
  func conjugate(tense: AdjectiveTense, negative: Bool, conjugation: ConjugationType) -> String {
    switch tense {
      case .present, .future:
        return conjugatePresent(negative: negative, conjugation: conjugation)
      case .past:
        return conjugatePast(negative: negative, conjugation: conjugation)
    }
  }
  
  // MARK: - Private
  
  private var readKana: Int?
  
  private var irregularKana: Int?
  
  private func conjugatePresent(negative: Bool, conjugation: ConjugationType) -> String {
    var result = written
    switch category {
      case .i:
        if negative {
          result.removeLast()
          result.append("くない")
        }
        switch conjugation {
          case .regular, .informalEnding:
            break
          case .formalEnding:
            result.append(AppConstants.formalEnding)
        }
      case .na:
        if negative {
          result.append("じゃない")
        }
        switch conjugation {
          case .regular:
            if !negative {
              result.append("な")
            }
          case .formalEnding:
            result.append(AppConstants.formalEnding)
          case .informalEnding:
            result.append(AppConstants.informalEnding)
        }
    }
    return result
  }
  
  private func conjugatePast(negative: Bool, conjugation: ConjugationType) -> String {
    var result = written
    switch category {
      case .i:
        result.removeLast()
        if negative {
          result.append("くなかった")
        } else {
          result.append("くない")
        }
        switch conjugation {
          case .regular:
            break
          case .formalEnding:
            result.append(AppConstants.formalEnding)
          case .informalEnding:
            result.append(AppConstants.informalEnding)
        }
      case .na:
        if negative {
          result.append("じゃなかった")
        }
        switch conjugation {
          case .regular:
            if negative {
              break
            } else {
              fatalError("Not a possible combo")
            }
          case .formalEnding:
            if negative {
              result.append(AppConstants.formalEnding)
            } else {
              result.append("でした")
            }
          case .informalEnding:
            if negative {
              result.append(AppConstants.informalEnding)
            } else {
              result.append("だった")
            }
        }
    }
    return result
  }
}
