//
// The LanguagePractice project.
// Created by optionaldev on 02/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import protocol Foundation.ObservableObject

final class HomeViewModel: ObservableObject {
    
    func requestMissingItems() {
        LexiconsRequest().start { lexicon in
            self.lexicon = lexicon
        }
    }
    
    // MARK: - Private
    
    private var lexicon: Lexicon?
}
