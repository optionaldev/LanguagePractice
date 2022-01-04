//
// The LanguagePractice (iOS) project.
// Created by optionaldev on 03/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

final class ConjugatableChallengeProvider {
  
  init(lexicon: Lexicon = .shared, speech: Speech = .shared) {
    self.lexicon = lexicon
    self.speech = speech
  }
  
  func generate(fromPool pool: [ConjugatableEntry], index: Int) -> ConjugatablePickChallenge {
    let entry = pool[index]
    
    guard let conjugatable = lexicon.foreignDictionary[entry.id] as? ForeignConjugatable else {
      fatalError("Couldn't find conjugatable with id: \"\(entry.id)\"")
    }
    
    let source: [ForeignWord]
    if conjugatable is ForeignAdjective {
      source = lexicon.foreign.adjectives
    } else {
      source = lexicon.foreign.verbs
    }
    
    let otherConjugatables = source
      .compactMap { $0 as? ForeignConjugatable }
      .filter { $0.id != conjugatable.id }
      .shuffled()
      .prefix(5)
      .map { $0 }
    
    // TODO: Improve
    let voiceEnabled = speech.voicePossible(forEntry: entry)
    
    let inputType: Possibility = voiceEnabled ? [.voice, .text].randomElement()! : .text
    
    let input: Representation
    let outputType: Possibility = voiceEnabled ? [.voice, .text].randomElement()! : .text
    
    let correctOutput: Representation
    var otherOutput: Representation
//    
//    switch inputType {
//      case .image:
//        fatalError("Not possible")
//      case .text:
//        switch entry.category {
//          case .askTense:
//            input = .init(category: .text, string: conjugatable)
//        }
//      case .voice:
//        <#code#>
//    }
//    
    return ConjugatablePickChallenge(inputRep: .init(category: .text, string: ""), outputRep: [], correctAnswerIndex: 0)
  }
  
  // MARK: - Private
  
  private let lexicon: Lexicon
  private let speech: Speech
}
/*
    
    let correctOutput: KanaRepresentation
    var otherOutput: [KanaRepresentation]
    
    switch inputType {
      case .text:
        switch entry.category {
          case .foreign:
            input = .init(category: .text, string: character.written)
            switch outputType {
              case .text:
                correctOutput = .init(category: .text, string: character.romaji)
                otherOutput = otherCharacters.map { .init(category: .text, string: $0.romaji) }
              case .voice:
                correctOutput = .init(category: .voice, string: character.spoken)
                otherOutput = otherCharacters.map { .init(category: .voice, string: $0.spoken) }
              case .image:
                fatalError("Can't have images in this type of challenge")
            }
          case .english:
            input = .init(category: .text, string: character.romaji)
            switch outputType {
              case .text:
                correctOutput = .init(category: .text, string: character.written)
                otherOutput = otherCharacters.map { .init(category: .text, string: $0.written) }
              case .voice:
                correctOutput = .init(category: .voice, string: character.spoken)
                otherOutput = otherCharacters.map { .init(category: .voice, string: $0.spoken) }
              case .image:
                fatalError("Can't have images in this type of challenge")
            }
        }
      case .voice:
        input = .init(category: .voice, string: character.spoken)
        switch entry.category {
          case .foreign:
            correctOutput = .init(category: .text, string: character.romaji)
            otherOutput = otherCharacters.map { .init(category: .text, string: $0.romaji) }
          case .english:
            correctOutput = .init(category: .text, string: character.written)
            otherOutput = otherCharacters.map { .init(category: .text, string: $0.written) }
        }
      case .image:
        fatalError("Can't have images in this type of challenge")
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
*/
