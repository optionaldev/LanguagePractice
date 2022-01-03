//
// The LanguagePractice (iOS) project.
// Created by optionaldev on 03/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

final class ConjugatableChallengeProvider {
  
  
  init(lexicon: Lexicon = .shared) {
    self.lexicon = lexicon
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
    
    return ConjugatablePickChallenge(inputRep: .init(category: .text, string: ""), outputRep: [], correctAnswerIndex: 0)
  }
  
  // MARK: - Private
  
  private let lexicon: Lexicon
}
/*
    let otherCharacters = lexicon.foreign.hiragana
      .filter { $0.id != character.id }
      .shuffled()
      .prefix(5)
      .map { $0 }
    
    let voiceEnabled = entry.category.voiceValid && Defaults.voiceEnabled
    
    let inputType: Possibility  //= entry.category.input(voiceEnabled: Defaults.voiceEnabled)
    switch entry.category {
      case .foreign:
        inputType = voiceEnabled ? [.voice, .text].randomElement()! : .text
      case .english:
        inputType = .text
    }
    
    
    let input: KanaRepresentation
    let outputType: Possibility  //entry.category.output(forInput: inputType, voiceEnabled: Defaults.voiceEnabled)
    
    switch inputType {
      case .image:
        fatalError("Not possible")
      case .text:
        switch entry.category {
          case .english:
            outputType = .text
          case .foreign:
            outputType = voiceEnabled ? [.voice, .text].randomElement()! : .text
        }
      case .voice:
        outputType = .text
    }
    
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
