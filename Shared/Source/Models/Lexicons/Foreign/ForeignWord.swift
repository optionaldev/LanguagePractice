//
// The LanguagePractice project.
// Created by optionaldev on 13/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

protocol ForeignWord: ForeignItem {
    
    // A list of IDs representing english words that the foreign word can be translated into
    var english: [String] { get }
    
    #if JAPANESE
    // A string containing characters or sequence of characters separated by spaces
    // Possible scenarios to consider are:
    // - single character "か"
    // - single sequence "とう"
    // - multiple characters "た　か"
    // - multiple sequences "ほう　ほう"
    // - a combination of the two "か　つう"
    
    // It is optional because some words have their characters in hiragana / katakana
    var furigana: String? { get }
    #endif
}

#if JAPANESE
extension ForeignWord {
    
    var hasKana: Bool {
        return furigana != nil
    }
    
    // Some words in Japanese have a combination of kanji and hiragana
    // This converts the kanji into hiragana while keeping the original hiragana at their correct position
    var kana: String? {
        guard var furiganaStrings = furigana?.split(separator: " ").map({ String($0) }) else {
            return nil
        }
        
        if characters.filter({ !$0.isHiragana }).count == furiganaStrings.count {
            return characters.map { String($0) }
                             .map { $0.first?.isHiragana == true ? $0 : furiganaStrings.removeFirst() }
                             .joined()
        } else {
            log("kana generation special or unhandled case characters = \"\(characters)\" \"\(furiganaStrings)\"")
            if furiganaStrings.count == 1 {
                // Special case where it is rather unknown which kanji has what reading
                return furiganaStrings.first
            } else if furiganaStrings.count > 1 {
                log("Number of furigana is inconsistent with number of kanjis", type: .unexpected)
            }
            return nil
        }
    }
    
    // Some words in Japanese have a combination of kanji and hiragana
    // For our UI, in order to display the translation of the kanji directly above the kanji
    // we construct a string where the translation is approximately above the kanji character
    // and the hiragana is replaced by empty spaces
    var kanaComponenets: [String] {
        guard var furiganaStrings = furigana?.split(separator: " ").map({ String($0) }) else {
            return []
        }
        
        if characters.filter({ !$0.isHiragana }).count == furiganaStrings.count {
            return characters.map { String($0) }
                             .compactMap { $0.first?.isHiragana == true ? " " : furiganaStrings.removeFirst() }
                             
        } else {
            log("kana generation special or unhandled case characters = \"\(characters)\" \"\(furiganaStrings)\"")
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
