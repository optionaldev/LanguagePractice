//
// The LanguagePractice project.
// Created by optionaldev on 11/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

enum EntryType {
    
    case hiragana
    case katakana
    case words
}

struct EntryProvider {
    
    static func generate(_ entryType: EntryType) -> [EntryProtocol] {
        let knownEntries: [String]
        var challengeEntries: [String]
        
        switch entryType {
        case .hiragana:
            knownEntries = Defaults.knownHiragana.map { $0.roman }
            challengeEntries = Hiragana.all.map { $0.roman }
        case .katakana:
            knownEntries = Defaults.knownKatakana.map { $0.roman }
            challengeEntries = Katakana.all.map { $0.roman }
        case .words:
            knownEntries = Defaults.knownWords
            challengeEntries = Defaults.lexicon!.foreign.nouns.map { $0.id }
        }
        
        challengeEntries = Array(challengeEntries
            .filter { !knownEntries.contains($0) }
            .shuffled()
            .prefix(AppConstants.challengeInitialSampleSize))
        
        // Handle case when there are less than 10 words left to learn
        if challengeEntries.count < AppConstants.challengeInitialSampleSize {
            let extraHiragana = challengeEntries.filter { knownEntries.contains($0) }
                .prefix(AppConstants.challengeInitialSampleSize - challengeEntries.count)
            
            challengeEntries.append(contentsOf: extraHiragana)
        }
        
        guard challengeEntries.count == AppConstants.challengeInitialSampleSize else {
            fatalError("Invalid number of elements")
        }
        
        switch entryType {
        case .hiragana:
            return challengeEntries.flatMap {[
                HiraganaEntry(roman: $0, kanaChallengeType: .foreign),
                HiraganaEntry(roman: $0, kanaChallengeType: .romanToForeign),
                HiraganaEntry(roman: $0, kanaChallengeType: .foreignToRoman)
            ]}
        case .katakana:
            return challengeEntries.flatMap {[
                KatakanaEntry(roman: $0, kanaChallengeType: .foreign),
                KatakanaEntry(roman: $0, kanaChallengeType: .romanToForeign),
                KatakanaEntry(roman: $0, kanaChallengeType: .foreignToRoman)
            ]}
        case .words:
            guard var lexicon = Defaults.lexicon else {
                fatalError()
            }
            return challengeEntries.flatMap {[
                WordEntry(inputLanguage: .english,
                          input: $0,
                          outputLanguage: .foreign,
                          output: lexicon.foreignDictionary[$0]?.id ?? ""),
                WordEntry(inputLanguage: .foreign,
                          input: lexicon.foreignDictionary[$0]?.id ?? "",
                          outputLanguage: .english,
                          output: $0)
            ]}
        }
    }
}
