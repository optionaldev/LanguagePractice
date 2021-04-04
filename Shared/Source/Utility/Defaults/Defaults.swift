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
    
    static var guessHistory:[String: [TimeInterval]] {
        return Defaults.dictionary(forKey: .guessHistory)
    }
    
    static var knownWords: [String] {
        return guessHistory.filter {
            // We take the last 3 values and if they're all below our success threshold
            // the word is considered to be known
            $0.value.suffix(3).filter {
                // Check if all 3 of our values are within success range
                AppConstants.successRange ~= $0
            }.count == 3
        }.map { $0.key }
    }
}
