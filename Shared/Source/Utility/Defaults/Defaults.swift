//
// The LanguagePractice project.
// Created by optionaldev on 14/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

import struct Foundation.TimeInterval

final class Defaults: DefaultsCodingProtocol, DefaultsArrayProtocol, DefaultsDictionaryProtocol {
    
    typealias ArrayKeyType = DefaultsArrayKey
    typealias DecodeKeyType = DefaultsCodingKey
    typealias DictionaryKeyType = DefaultsDictionaryKey
    
    static var lexicon: Lexicon? {
        let english: EnglishLexicon? = Defaults.decodable(forKey: .englishLexicon)
        let foreign: ForeignLexicon? = Defaults.decodable(forKey: .foreignLexicon)
        
        if let englishLexicon = english, let foreignLexicon = foreign {
            return Lexicon(english: englishLexicon, foreign: foreignLexicon)
        }
        
        return nil
    }
    
    static var wordsLearned: [String] {
        return Defaults.array(forKey: .wordsLearned)
    }
    
    static var guessHistory:[String: [TimeInterval]] {
        return Defaults.dictionary(forKey: .guessHistory)
    }
}
