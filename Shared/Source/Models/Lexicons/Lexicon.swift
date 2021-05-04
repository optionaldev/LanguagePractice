//
// The LanguagePractice project.
// Created by optionaldev on 13/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

final class Lexicon: Codable {
    
    static let shared = Defaults.lexicon ?? Lexicon(english: .init(nouns: []), foreign: .init(hiragana: [], katakana: [], nouns: []))
    
    let english: EnglishLexicon
    let foreign: ForeignLexicon
    
    lazy var englishDictionary: [String: EnglishWord] = {
        english.nouns.reduce(into: [String: EnglishWord]()) { $0[$1.id] = $1 }
    }()
    
    lazy var foreignDictionary: [String: ForeignItem] = {
        foreign.all.reduce(into: [String: ForeignItem]()) { $0[$1.id] = $1 }
    }()
    
    init(english: EnglishLexicon, foreign: ForeignLexicon) {
        self.english = english
        self.foreign = foreign
    }
}
