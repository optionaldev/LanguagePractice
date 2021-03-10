//
// The LanguagePractice project.
// Created by optionaldev on 14/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

final class Defaults: DefaultsCodingProtocol {

    typealias DecodeKeyType = DefaultsCodingKey
    
    static var lexicon: Lexicon? {
        let english: EnglishLexicon? = Defaults.decodable(forKey: .englishLexicon)
        let foreign: ForeignLexicon? = Defaults.decodable(forKey: .foreignLexicon)
        
        if let englishLexicon = english, let foreignLexicon = foreign {
            return Lexicon(english: englishLexicon, foreign: foreignLexicon)
        }
        
        return nil
    }
}
