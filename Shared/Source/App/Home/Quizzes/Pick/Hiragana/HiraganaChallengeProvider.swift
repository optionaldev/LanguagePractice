//
// The LanguagePractice project.
// Created by optionaldev on 16/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

final class HiraganaChallengeProvider {
  
  init(lexicon: Lexicon = .shared) {
    self.lexicon = lexicon
  }
  
  func generate(fromPool pool: [HiraganaEntry], index: Int) -> HiraganaChallenge {
    let entry = pool[index]
    
    guard let character = lexicon.foreignDictionary[entry.id] as? ForeignCharacter else {
      fatalError("Couldn't find character with id \"\(entry.id)\"")
    }
    
    let otherCharacters = lexicon.foreign.hiragana
            .filter { $0.id != character.id }
            .shuffled()
            .prefix(5)
            .map { $0 }
    
    let inputType = Defaults.voiceEnabled ? entry.category : entry.category.voiceFallback
    let input: HiraganaRep
    let correctOutput: HiraganaRep
    var otherOutput: [HiraganaRep]
    
    switch inputType {
      case .hiraganaToRomaji:
        input = .init(category: .text, string: character.written)
        correctOutput = .init(category: .text, string: character.romaji)
        otherOutput = otherCharacters.map { HiraganaRep(category: .text, string: $0.romaji) }
        
      case .hiraganaToVoice:
        input = .init(category: .text, string: character.written)
        correctOutput = .init(category: .voice, string: character.spoken)
        otherOutput = otherCharacters.map { HiraganaRep(category: .voice, string: $0.spoken) }
        
      case .romajiToHiragana:
        input = .init(category: .text, string: character.romaji)
        correctOutput = .init(category: .text, string: character.written)
        otherOutput = otherCharacters.map { HiraganaRep(category: .text, string: $0.written) }
        
      case .romajiToVoice:
        input = .init(category: .text, string: character.romaji)
        correctOutput = .init(category: .voice, string: character.spoken)
        otherOutput = otherCharacters.map { HiraganaRep(category: .voice, string: $0.spoken) }
        
      case .voiceToRomaji:
        input = .init(category: .voice, string: character.spoken)
        correctOutput = .init(category: .text, string: character.romaji)
        otherOutput = otherCharacters.map { HiraganaRep(category: .text, string: $0.romaji) }
        
      case .voiceToHiragana:
        input = .init(category: .voice, string: character.spoken)
        correctOutput = .init(category: .text, string: character.written)
        otherOutput = otherCharacters.map { HiraganaRep(category: .text, string: $0.written) }
    }
    
    otherOutput.append(correctOutput)
    otherOutput.shuffle()
    
    guard let correctAnswerIndex = otherOutput.firstIndex(of: correctOutput) else {
      fatalError("Couldn't find correct answer in list of answers.")
    }
    
    return .init(inputRep: input, outputRep: otherOutput, correctAnswerIndex: correctAnswerIndex)
  }
  
  // MARK: - Private
  
  private let lexicon: Lexicon
}
