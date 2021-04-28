//
// The LanguagePractice project.
// Created by optionaldev on 13/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct ForeignLexicon: Codable {
    
    let hiragana: [ForeignCharacter]
    let katakana: [ForeignCharacter]
    let nouns: [ForeignNoun]
}
