//
// The LanguagePractice project.
// Created by optionaldev on 25/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import class Combine.AnyCancellable

final class LexiconsRequest {
    
    func start(_ completion: @escaping () -> Void) {
        self.completion = completion
        
        fetchEnglishWords()
        fetchForeignWords()
    }
    
    // MARK: - Private
    
    private var completion: (() -> Void)?
    
    private var englishCancellable: AnyCancellable?
    private var foreignCancellable: AnyCancellable?
    
    private var englishLexicon: EnglishLexicon?
    private var foreignLexicon: ForeignLexicon?
    
    private func fetchEnglishWords() {
        log("Fetching English words", type: .info)
        guard let url = Language.english.url else {
            log("Failed to build URL for \(Language.english)")
            return
        }
        
        self.englishCancellable = Network.fetchJson(from: url).sink(receiveCompletion: { error in
            // TODO: we receive an error type "finished". Handle it to avoid confusion with real errors
            log(error)
        }, receiveValue: { (lexicon: EnglishLexicon) in
            self.englishLexicon = lexicon
            self.performCallbackIfComplete()
        })
    }
    
    private func fetchForeignWords() {
        log("Fetching foreign words", type: .info)
        guard let url = Language.foreign.url else {
            log("Failed to build URL for language \(Language.foreign)")
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
        guard let englishLexicon = englishLexicon,
              let foreignLexicon = foreignLexicon else
        {
            return
        }
        Defaults.set(englishLexicon, forKey: .englishLexicon)
        Defaults.set(foreignLexicon, forKey: .foreignLexicon)
        completion?()
        completion = nil
    }
}
