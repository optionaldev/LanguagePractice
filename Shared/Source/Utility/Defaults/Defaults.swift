//
// The LanguagePractice project.
// Created by optionaldev on 14/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

import struct Foundation.TimeInterval

final class Defaults: DefaultsArrayProtocol,
                      DefaultsBoolProtocol,
                      DefaultsCodingProtocol,
                      DefaultsDictionaryProtocol,
                      DefaultsStringProtocol {
    
    typealias ArrayKeyType      = DefaultsArrayKey
    typealias BoolKeyType       = DefaultsBoolKey
    typealias DecodeKeyType     = DefaultsCodingKey
    typealias DictionaryKeyType = DefaultsDictionaryKey
    typealias StringKeyType     = DefaultsStringKey
    
    static var lexicon: Lexicon? {
        let english: EnglishLexicon? = Defaults.decodable(forKey: .englishLexicon)
        let foreign: ForeignLexicon? = Defaults.decodable(forKey: .foreignLexicon)
        
        if let englishLexicon = english, let foreignLexicon = foreign {
            return Lexicon(english: englishLexicon, foreign: foreignLexicon)
        }
        
        return nil
    }
    
    static var guessHistory: [String: [TimeInterval]] {
        return Defaults.dictionary(forKey: .guessHistory)
    }
    
    static var knownForeignItemIDs: [String] {
        return guessHistory.known()
    }
    
    static var voiceEnabled: Bool {
        return Defaults.bool(forKey: .voiceEnabled)
    }
}

private extension Dictionary where Key == String, Value == [TimeInterval] {
    
    func known() -> [String] {
        self.filter {
            // We take the last 3 values and if they're all below our success threshold
            // the word is considered to be known
            $0.value.suffix(3).filter {
                // Check if all 3 of our values are within success range
                AppConstants.successRange ~= $0
            }.count == 3
        }.map { $0.key }
    }
}
