//
// The LanguagePractice project.
// Created by optionaldev on 11/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

enum EntryType {
    
    case hiragana
    case katakana
}

struct EntryProvider {
    
    // TODO: Find a way to make it generic
    static func generateHiragana() -> [HiraganaEntry] {
        return generate(.hiragana).flatMap { extractHiragana(from: $0) }.shuffled()
    }
    
    static func generateKatakana() -> [KatakanaEntry] {
        return generate(.hiragana).flatMap { extractKatakana(from: $0) }.shuffled()
    }
    
    // MARK: - Private
    
    private static func extractHiragana(from foreignCharacter: ForeignCharacter) -> [HiraganaEntry] {
        let id = foreignCharacter.roman
        return [HiraganaEntry(id: id, kanaChallengeType: .foreign),
                HiraganaEntry(id: id, kanaChallengeType: .foreignToRoman),
                HiraganaEntry(id: id, kanaChallengeType: .romanToForeign)]
    }
    
    private static func extractKatakana(from foreignCharacter: ForeignCharacter) -> [KatakanaEntry] {
        let id = foreignCharacter.roman
        return [KatakanaEntry(id: id, kanaChallengeType: .foreign),
                KatakanaEntry(id: id, kanaChallengeType: .foreignToRoman),
                KatakanaEntry(id: id, kanaChallengeType: .romanToForeign)]
    }
    
    private static func generate(_ type: EntryType) -> [ForeignCharacter] {
        
        let knownEntries: [ForeignCharacter]
        var challengeEntries: [ForeignCharacter]
        switch type {
        case .hiragana:
            knownEntries = Defaults.knownHiragana
            challengeEntries = Hiragana.all
        case .katakana:
            knownEntries = Defaults.knownKatakana
            challengeEntries = Katakana.all
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
        
        return challengeEntries
    }
}
