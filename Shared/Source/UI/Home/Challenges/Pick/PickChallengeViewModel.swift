//
// The LanguagePractice project.
// Created by optionaldev on 08/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import Foundation

final class PickChallengeViewModel: ObservableObject {
    
    @Published var history: [PickChallenge] = []
    
    // Reflects whether the answers are displayed when remaining is equal to the 'forfeitRetriesCount' in Constants
    @Published var challengeState: PickChallengeState = .regular
    
    var currentWord: PickChallenge {
        return history.last!
    }
    
    init() {
        guard let lexicon = Defaults.lexicon else {
            fatalError("Shouldn't allow creation of view model without lexicon existing")
        }
        
        let foreignNouns = lexicon.foreign.nouns
        let challengeNouns = foreignNouns.shuffled().prefix(10)
        
        func extract(_ foreignNoun: ForeignNoun) -> [Entry] {
            var result = foreignNoun.english.flatMap { [Entry(from: .english,
                                                              to: .foreign,
                                                              input: $0,
                                                              output: foreignNoun.id),
                                                        Entry(from: .foreign,
                                                              to: .english,
                                                              input: foreignNoun.id,
                                                              output: $0) ] }

            if foreignNoun.kana != nil {
                // For input, we could show multiple english translations, but for output only 1,
                // so for now, display only the first and keep DB with first english translation
                // being the most accurate one
                guard let translation = foreignNoun.english.first else {
                    log("No english translation found for foreign word with ID \"\(foreignNoun.id)\"", type: .unexpected)
                    return result
                }
                
                result.append(Entry(from: .foreign,
                                    to: .foreign,
                                    input: foreignNoun.id,
                                    output: translation))
            }
            return result
        }
        
        challengeEntries = challengeNouns.flatMap { extract($0) }.shuffled()
        
        log("challengeEntries:")
        _ = challengeEntries.map { print("\($0.from) \"\($0.input)\" \($0.to) \"\($0.output)\"") }
        
        
        prepareNextChallenge()
        
        guard nextChallenge != nil else {
            log("no next challenge", type: .unexpected)
            return
        }
        informView()
        
        prepareNextChallenge()
    }
    
    // MARK: - Private
    
    private let challengeEntries: [Entry]
    private var nextChallenge: PickChallenge?
    
    private func prepareNextChallenge() {
        // TODO
    }
    
    private func informView() {
        // TODO
    }
}
