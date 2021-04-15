//
// The LanguagePractice project.
// Created by optionaldev on 11/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

enum KanaEntryType {
    
    case hiragana
    case katakana
}

struct EntryProvider {
    
    static func generate(_ type: KanaEntryType) -> [AnyEntry] {
        
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
        
        let kanaClass: KanaEntryProtocol.Type = type == .hiragana ? HiraganaEntry.self : KatakanaEntry.self
        
        let kanaInstances = challengeEntries.flatMap { [kanaClass.init(roman: $0.roman, kanaChallengeType: .foreign),
                                                        kanaClass.init(roman: $0.roman, kanaChallengeType: .romanToForeign),
                                                        kanaClass.init(roman: $0.roman, kanaChallengeType: .foreignToRoman)] }
        
        return kanaInstances.map { AnyEntry(entry: $0) }
    }
}
