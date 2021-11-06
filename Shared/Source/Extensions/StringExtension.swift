//
// The LanguagePractice project.
// Created by optionaldev on 12/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

extension String {
  
  func removingUniqueness() -> String {
    return self.replacingOccurrences(of: "_[0-9]{1,}", with: "", options: CompareOptions.regularExpression, range: self.range(of: self))
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
  #endif
}
