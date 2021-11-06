//
// The LanguagePractice project.
// Created by optionaldev on 10/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

protocol KanaEntryProtocol: EntryProtocol {
  
  init(roman: String, kanaChallengeType: KanaChallengeType)
}

protocol EntryProtocol {
  
  var inputLanguage: Language { get }
  var outputLanguage: Language { get }
  
  var input: String { get }
  var output: String { get }
  
  var inputPossibilities: [ChallengeType] { get}
  var outputPossibilities: [ChallengeType] { get }
  
  /// We're always learned some word or characters and this is how we identify it
  var foreignID: String { get }
  
  var noImage: Bool { get }
  
  var english: String? { get }
  
  var typeIndex: Int { get }
}

func == (lhs: EntryProtocol, rhs: EntryProtocol) -> Bool {
  return lhs.input == rhs.input &&
    lhs.inputLanguage == rhs.inputLanguage &&
    lhs.output == rhs.output &&
    rhs.outputLanguage == rhs.outputLanguage
}

func != (lhs: EntryProtocol, rhs: EntryProtocol) -> Bool {
  return !(lhs == rhs)
}

extension EntryProtocol {
  
  var noImage: Bool {
    if let english = english {
      return Persistence.imagePath(id: english) == nil
    }
    return false
  }
  
  var english: String? {
    if inputLanguage == .english {
      return input
    } else if outputLanguage == .english {
      return output
    }
    return nil
  }
}

enum KanaChallengeType {
  
  case foreign
  case romanToForeign
  case foreignToRoman
}

struct HiraganaEntry: KanaEntryProtocol {
  
  init(roman: String, kanaChallengeType: KanaChallengeType) {
    self.id = roman
    self.kanaChallengeType = kanaChallengeType
  }
  
  let id: String
  private let kanaChallengeType: KanaChallengeType
  
  var inputLanguage: Language {
    return .foreign
  }
  
  var outputLanguage: Language {
    return .foreign
  }
  
  var input: String {
    switch kanaChallengeType {
      case .foreign:
        return id.toHiragana()
      case .romanToForeign:
        return id.removingUniqueness()
      case .foreignToRoman:
        return id.toHiragana()
    }
  }
  
  var output: String {
    switch kanaChallengeType {
      case .foreign:
        return id.toHiragana()
      case .romanToForeign:
        return id.toHiragana()
      case .foreignToRoman:
        return id.removingUniqueness()
    }
  }
  
  var inputPossibilities: [ChallengeType] {
    switch kanaChallengeType {
      case .foreign:
        return [.text(.foreign), .voice(.foreign)]
      case .romanToForeign:
        return [.text(.english)]
      case .foreignToRoman:
        return [.text(.foreign), .voice(.foreign)]
    }
  }
  
  var outputPossibilities: [ChallengeType] {
    switch kanaChallengeType {
      case .foreign:
        return [.text(.foreign), .voice(.foreign)]
      case .romanToForeign:
        return [.text(.foreign), .voice(.foreign)]
      case .foreignToRoman:
        return [.text(.english)]
    }
  }
  
  var foreignID: String {
    return id
  }
  
  var typeIndex: Int {
    switch kanaChallengeType {
      case .foreign:
        return 0
      case .foreignToRoman:
        return 1
      case .romanToForeign:
        return 2
    }
  }
}

struct WordEntry: EntryProtocol {
  
  init(inputLanguage: Language, input: String, outputLanguage: Language, output: String) {
    self.inputLanguage = inputLanguage
    self.input = input
    
    self.outputLanguage = outputLanguage
    self.output = output
  }
  
  let inputLanguage: Language
  
  let outputLanguage: Language
  
  let input: String
  
  let output: String
  
  var inputPossibilities: [ChallengeType] {
    if inputLanguage == outputLanguage {
      return [.simplified]
    }
    return ChallengeType.availableChallenges
  }
  
  var outputPossibilities: [ChallengeType] {
    if inputLanguage == outputLanguage {
      return [.simplified]
    }
    return ChallengeType.availableChallenges
  }
  
  var foreignID: String {
    inputLanguage == .foreign ? input : output
  }
  
  var typeIndex: Int {
    if inputLanguage == outputLanguage {
      return 1000
    } else if inputLanguage == .foreign {
      return 1001
    } else {
      return 1002
    }
  }
}

struct KatakanaEntry: KanaEntryProtocol {
  
  init(roman: String, kanaChallengeType: KanaChallengeType) {
    self.id = roman.removingUniqueness()
    self.kanaChallengeType = kanaChallengeType
  }
  
  let id: String
  private let kanaChallengeType: KanaChallengeType
  
  var inputLanguage: Language {
    return .foreign
  }
  
  var outputLanguage: Language {
    return .foreign
  }
  
  var input: String {
    switch kanaChallengeType {
      case .foreign:
        return id.toKatakana()
      case .romanToForeign:
        return id.removingUniqueness()
      case .foreignToRoman:
        return id.toKatakana()
    }
  }
  
  var output: String {
    switch kanaChallengeType {
      case .foreign:
        return id.toKatakana()
      case .romanToForeign:
        return id.toKatakana()
      case .foreignToRoman:
        return id.removingUniqueness()
    }
  }
  
  var inputPossibilities: [ChallengeType] {
    switch kanaChallengeType {
      case .foreign:
        return [.text(.foreign), .voice(.foreign)]
      case .romanToForeign:
        return [.text(.english)]
      case .foreignToRoman:
        return [.text(.foreign), .voice(.foreign)]
    }
  }
  
  var outputPossibilities: [ChallengeType] {
    switch kanaChallengeType {
      case .foreign:
        return [.text(.foreign), .voice(.foreign)]
      case .romanToForeign:
        return [.text(.foreign), .voice(.foreign)]
      case .foreignToRoman:
        return [.text(.english)]
    }
  }
  
  var foreignID: String {
    return id
  }
  
  var typeIndex: Int {
    switch kanaChallengeType {
      case .foreign:
        return 100
      case .foreignToRoman:
        return 101
      case .romanToForeign:
        return 102
    }
  }
}
