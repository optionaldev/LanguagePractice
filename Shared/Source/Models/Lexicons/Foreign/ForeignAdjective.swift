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

struct ForeignAdjective: ForeignWord, ForeignConjugatable {
  
  let id: String
  let written: String
  let english: [String]
  
#if JAPANESE
  let furigana: String?
  
  var groupFurigana: Bool {
    return irregularKana == 1
  }
  
  var shouldReadKana: Bool {
    return readKana == 1
  }
  
  var category: ForeignAdjectiveCategory {
    if iAdjective == 1 {
      return .i
    }
    return .na
  }
#endif
  
  enum CodingKeys: String, CodingKey {
    case id
    case written  = "ch"
    case english  = "en"
    
#if JAPANESE
    case furigana      = "fg"
    case irregularKana = "ik"
    case readKana      = "rk"
    case iAdjective    = "i"
#endif
  }
  
  // MARK: - Private
  
  private var irregularKana: Int?
  private var readKana: Int?
  private var iAdjective: Int?
  
  private func conjugatePresent(negative: Bool, type conjugationType: ConjugationType) -> String {
    var result = written
    switch category {
      case .i:
        if negative {
          result.removeLast()
          result.append("くない")
        }
        switch conjugationType {
          case .modifier, .informalEnding:
            // modifier and informal ending don't add and suffixes
            break
          case .formalEnding:
            result.append(AppConstants.desuEnding)
        }
      case .na:
        if negative {
          result.append("じゃない")
        }
        switch conjugationType {
          case .modifier:
            if !negative {
              result.append("な")
            }
          case .formalEnding:
            result.append(AppConstants.desuEnding)
          case .informalEnding:
            if !negative {
              result.append(AppConstants.informalEnding)
            }
        }
    }
    return result
  }
  
  private func conjugatePast(negative: Bool, type conjugationType: ConjugationType) -> String {
    var result = written
    switch category {
      case .i:
        result.removeLast()
        if negative {
          result.append("くなかった")
        } else {
          result.append("かった")
        }
        switch conjugationType {
          case .modifier:
            break
          case .formalEnding:
            result.append(AppConstants.desuEnding)
          case .informalEnding:
            result.append(AppConstants.informalEnding)
        }
      case .na:
        if negative {
          result.append("じゃなかった")
          
          switch conjugationType {
            case .modifier:
              break
            case .formalEnding:
              result.append(AppConstants.desuEnding)
            case .informalEnding:
              result.append(AppConstants.informalEnding)
          }
        } else {
          switch conjugationType {
            case .modifier, .informalEnding:
              result.append("だった")
            case .formalEnding:
              result.append("でした")
          }
        }
    }
    return result
  }
  
  // MARK: - ForeignConjugatable conformance
  
  func conjugate(tense: Tense, negative: Bool, type conjugationType: ConjugationType) -> Conjugation {
    let conjugatedString: String
    switch tense {
      case .present, .future:
        conjugatedString = conjugatePresent(negative: negative, type: conjugationType)
      case .past:
        conjugatedString = conjugatePast(negative: negative, type: conjugationType)
      case .can, .want, .presentContinuous:
        fatalError("TODO: Implement")
    }
    return Conjugation(id: conjugatedString,
                       variation: ConjugationVariation(tense: tense,
                                                       negative: negative,
                                                       type: conjugationType))
  }
  
  static var possibleTenses: [Tense] {
    #if JAPANESE
    return [.past, .present, .future]
    #endif
  }
}
