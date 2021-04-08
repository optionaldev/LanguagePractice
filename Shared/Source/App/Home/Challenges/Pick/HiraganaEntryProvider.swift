//
// The LanguagePractice project.
// Created by optionaldev on 06/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct HiraganaEntryProvider {
    
    static func generate() -> [HiraganaEntry] {
        
        let knownHiragana = Defaults.knownHiragana
        
        var challengeHiragana = Hiragana.all
            .filter { !knownHiragana.contains($0) }
            .shuffled()
            .prefix(AppConstants.challengeInitialSampleSize)
        
        log("Learning: \(challengeHiragana.map { $0.hiragana }.joined(separator: ", "))")
        
        
        
        // Handle case when there are less than 10 words left to learn
        if challengeHiragana.count < AppConstants.challengeInitialSampleSize {
            let extraHiragana = challengeHiragana.filter { knownHiragana.contains($0) }
                .prefix(AppConstants.challengeInitialSampleSize - challengeHiragana.count)
            
            challengeHiragana.append(contentsOf: extraHiragana)
            
            log("and rehearsing: \(extraHiragana.map { $0.hiragana }.joined(separator: " "))")
        }
        
        guard challengeHiragana.count == AppConstants.challengeInitialSampleSize else {
            fatalError("Invalid number of elements")
        }
        
        // Method is declared here to be able to have a fully known 'challengeEntries' as a constant
        func extract(_ foreignCharacter: ForeignCharacter) -> [HiraganaEntry] {
            return [.foreign(id: foreignCharacter.roman),
                    .foreignToRoman(foreignCharacter.roman),
                    .romanToForeign(foreignCharacter.roman)]
        }
        
        return challengeHiragana.flatMap { extract($0) }.shuffled()
    }
}
