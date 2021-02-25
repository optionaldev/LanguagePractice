//
// The LanguagePractice project.
// Created by optionaldev on 25/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import Combine

final class LexiconsRequest {
    
    func start(_ completion: @escaping (Lexicon) -> Void) {
        self.completion = completion
        
        fetchEnglishWords()
        fetchForeignWords()
    }
    
    // MARK: - Private
    
    private var completion: ((Lexicon) -> Void)?
    
    private var englishCancellable: AnyCancellable?
    private var foreignCancellable: AnyCancellable?
    
    private var englishLexicon: EnglishLexicon?
    private var foreignLexicon: ForeignLexicon?
    
    private func fetchEnglishWords() {
        log("Fetching English words")
        guard let url = Language.english.url else {
            log("Failed to build URL")
            return
        }
        
        self.englishCancellable = Network.fetchJson(from: url).sink(receiveCompletion: { error in
            log(error)
        }, receiveValue: { (lexicon: EnglishLexicon) in
            self.englishLexicon = lexicon
            self.performCallbackIfComplete()
        })
    }
    
    private func fetchForeignWords() {
        log("Fetching foreign words")
        guard let url = Language.foreign.url else {
            log("Failed to build URL")
            return
        }
        
        self.foreignCancellable = Network.fetchJson(from: url).sink(receiveCompletion: { error in
            log(error)
        }, receiveValue: { (lexicon: ForeignLexicon)  in
            self.foreignLexicon = lexicon
            self.performCallbackIfComplete()
        })
    }
    
    private func performCallbackIfComplete() {
        if let english = englishLexicon,
           let foreign = foreignLexicon
        {
            let lexicon = Lexicon(english: english, foreign: foreign)
            completion?(lexicon)
        }
    }
}


