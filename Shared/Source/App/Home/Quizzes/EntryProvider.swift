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
    
    static func generate(_ type: EntryType) -> [KanaEntry] {
        
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
        
        log("Learning: \(challengeEntries.map { $0.hiragana }.joined(separator: ", "))")
        
        
        // Handle case when there are less than 10 words left to learn
        if challengeEntries.count < AppConstants.challengeInitialSampleSize {
            let extraHiragana = challengeEntries.filter { knownEntries.contains($0) }
                .prefix(AppConstants.challengeInitialSampleSize - challengeEntries.count)
            
            challengeEntries.append(contentsOf: extraHiragana)
            
            log("and rehearsing: \(extraHiragana.map { $0.hiragana }.joined(separator: " "))")
        }
        
        guard challengeEntries.count == AppConstants.challengeInitialSampleSize else {
            fatalError("Invalid number of elements")
        }
        
        return challengeEntries.flatMap { extract($0) }.shuffled()
    }
    
    // MARK: - Private
    
    private static func extract(_ foreignCharacter: ForeignCharacter) -> [KanaEntry] {
        return [.foreign(id: foreignCharacter.roman),
                .foreignToRoman(foreignCharacter.roman),
                .romanToForeign(foreignCharacter.roman)]
    }
}
