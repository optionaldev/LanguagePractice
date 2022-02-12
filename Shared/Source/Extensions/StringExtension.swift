//
// The LanguagePractice project.
// Created by optionaldev on 12/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

extension String {
  
  // TODO: Will not work if we decide to implementing guessing using romaji
  func detectLanguage() -> Language {
    return self.first?.isASCII == true ? .english : .foreign
  }
  
  /**
   Removes and underscore followed by digits, which is
   the method used to separate words with the same
   letters but different meaning, such that we keep
   id unique despite these conflicts.
   */
  func removingUniqueness() -> String {
    return self.replacingOccurrences(of: "_[0-9]{1,}", with: "", options: CompareOptions.regularExpression, range: self.range(of: self))
  }
  
  /** Remove last character from a string. */
  func removingLast() -> String {
    var result = self
    result.remove(at: index(before: endIndex))
    return result
  }
  
  /** Capitalize first letter of the string. */
  func firstLetterUppercased() -> String {
    if let firstCharacter = first {
      return "\(String(firstCharacter).uppercased())\(self[index(after: startIndex)...]))"
    }
    return ""
  }
  
  #if JAPANESE
  func toHiragana() -> String {
    guard let hiragana = applyingTransform(.latinToHiragana, reverse: false) else {
      log("Found string that couldn't be converted to hiragana = \"\(self)\"")
      return self
    }
    
    return hiragana
  }
  
  func toKatakana() -> String {
    guard let katakana = applyingTransform(.latinToKatakana, reverse: false) else {
      log("Found string that couldn't be converted to hiragana = \"\(self)\"")
      return self
    }
    
    return katakana
  }
  
  var containsKanji: Bool {
    return first(where: { !$0.isHiragana }) != nil
  }
  
  var containsHiragana: Bool {
    return first(where: { $0.isHiragana }) != nil
  }
  #endif
}
