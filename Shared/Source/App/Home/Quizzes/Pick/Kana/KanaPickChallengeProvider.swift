//
// The LanguagePractice project.
// Created by optionaldev on 16/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

enum Possibility {
  
  case image
  case text
  case voice
}

final class KanaPickChallengeProvider {
  
  init(lexicon: Lexicon = .shared) {
    self.lexicon = lexicon
  }
  
  func generate(fromPool pool: [KanaEntry], index: Int) -> KanaPickChallenge {
    let entry = pool[index]
    
    guard let character = lexicon.foreignDictionary[entry.id] as? ForeignCharacter else {
      fatalError("Couldn't find character with id \"\(entry.id)\"")
    }
    
    let otherCharacters = lexicon.foreign.hiragana
            .filter { $0.id != character.id }
            .shuffled()
            .prefix(5)
            .map { $0 }
    
    let inputType = entry.category.input(voiceEnabled: Defaults.voiceEnabled)
    let input: KanaRepresentation
    let outputType = entry.category.output(forInput: inputType, voiceEnabled: Defaults.voiceEnabled)
    
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
        switch entry.category.validOutput {
          case .foreign:
            correctOutput = .init(category: .text, string: character.written)
            otherOutput = otherCharacters.map { .init(category: .text, string: $0.written) }
          case .english:
            correctOutput = .init(category: .text, string: character.romaji)
            otherOutput = otherCharacters.map { .init(category: .text, string: $0.romaji) }
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
