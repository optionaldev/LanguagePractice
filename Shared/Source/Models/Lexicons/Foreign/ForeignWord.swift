//
// The LanguagePractice project.
// Created by optionaldev on 13/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

protocol ForeignWord: ForeignItem {
  
  /// A list of IDs representing English words that the foreign word can be translated into.
  var english: [String] { get }
  
  #if JAPANESE
  /**
   A string containing one or more hiragana characters/groups, separated by spaces.
   Each character/group is associated to one kanji.
   If the word does not contain any kanji characters, the value of this will be _nil_.
   
   Possible scenarios to consider are:
     * single character "か"
     * single sequence "とう"
     * multiple characters "た　か"
     * multiple sequences "ほう　ほう"
     * a combination of the two "か　つう"
   
   - Note:
   There are special scenarios. Check _composedFurigana_.
   */
  var furigana: String? { get }
  
  /**
   There are scenarios in which multiple kanjis have just one group representing all of them.
   For example, the word tabako (kanji: 煙草) is represented by 3 hiragana characters たばこ, but
   they aren't split between two groups such that each kanji has one group.
   
   * __true__ means all kanjis together have one hiragana representation.
   * __false__ means each kanji has a separate hiragana representation.
   */
  var groupFurigana: Bool { get }
  #endif
}

#if JAPANESE
extension ForeignWord {
  
  var hasFurigana: Bool {
    return furigana != nil
  }
  
  /**
   Some Japanese words are composed of both kanji and hiragana (e.g: お母さん meaning mother).
   This value represents the written form where all kanjis are converted to their respective hiragana (e.g: お母さん becomes おかあさん).
   
   Even though the word 'kana' in the purest sense means just the hiragana / katakana representation of
   a word, in our case, kana is __nil__ if the __characters__ property is already in kana form.
   */
  var kana: String? {
    guard var furiganaStrings = furigana?.split(separator: " ").map({ String($0) }) else {
      return nil
    }
    
    if written.filter({ !$0.isHiragana }).count == furiganaStrings.count {
      return written.map { String($0) }
        .map { $0.first?.isHiragana == true ? $0 : furiganaStrings.removeFirst() }
        .joined()
    } else if groupFurigana {
      return furiganaStrings[0]
    } else {
      log("kana generation special or unhandled case characters = \"\(written)\" \"\(furiganaStrings)\"")
      if furiganaStrings.count == 1 {
        // Special case where it is rather unknown which kanji has what reading
        return furiganaStrings.first
      } else if furiganaStrings.count > 1 {
        log("Number of furigana is inconsistent with number of kanjis for = \"\(written)\"", type: .unexpected)
      }
      return nil
    }
  }
  
  // Some words in Japanese have a combination of kanji and hiragana
  // For our UI, in order to display the kana of the kanji directly above the kanji, we
  // construct a string where the translation is approximately above the kanji character
  // and the hiragana is replaced by empty spaces
  var kanaComponenets: [String] {
    guard var furiganaStrings = furigana?.split(separator: " ").map({ String($0) }) else {
      return []
    }
    
    if written.filter({ !$0.isHiragana }).count == furiganaStrings.count {
      return written.map { String($0) }
        .compactMap { $0.first?.isHiragana == true ? " " : furiganaStrings.removeFirst() }
      
    } else {
      log("kana generation special or unhandled case characters = \"\(written)\" \"\(furiganaStrings)\"")
      if furiganaStrings.count == 1,
         let first = furiganaStrings.first {
        // Special case where it is rather unknown which kanji has what reading
        return [first]
      } else if furiganaStrings.count > 1 {
        log("Number of furigana is inconsistent with number of kanjis", type: .unexpected)
      }
      return []
    }
  }
}
#endif
