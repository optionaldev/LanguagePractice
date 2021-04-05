//
// The LanguagePractice project.
// Created by optionaldev on 10/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct ForeignCharacter: Codable, Equatable {

    /// The character equivalent in roman letters
    let roman: String
    
    #if JAPANESE
    let hiragana: String
    let katakana: String
    #endif
    
    init?(_ roman: String?) {
        guard let roman = roman else {
            return nil
        }
        self.roman = roman
        
        #if JAPANESE
        guard let hiragana = roman.applyingTransform(.latinToHiragana, reverse: false) else {
            log("\"\(roman)\" not convertible to hiragana", type: .unexpected)
            return nil
        }
        
        self.hiragana = hiragana
        
        guard let katakana = hiragana.applyingTransform(.hiraganaToKatakana, reverse: false) else {
            log("\"\(hiragana)\" not convertible to katakana", type: .unexpected)
            return nil
        }
        
        self.katakana = katakana
        #endif
    }
}
