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
    
    guard let word = lexicon.foreignDictionary[entry.id] as? ForeignWord else {
      fatalError("Couldn't find word with id: \"\(entry.id)\"")
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
    var otherOutput: [Representation]
    
    switch inputType {
      case .image:
        fatalError("Not possible")
      case .text:
        switch entry.category {
          case .askTense:
            let string = conjugatable.conjugate(tense: .present, negative: .random(), type: .regular).id
            let text = "Tense of\n\"\(string)\""
            input = .init(category: .text, string: text)
            switch outputType {
              case .image, .voice:
                fatalError("Not possible")
              case .text:
                otherOutput = Tense.allCases.without(.present).map { Representation(category: .text, string: $0.rawValue) }
                correctOutput = Representation(category: .text, string: "present")
            }
          case .askCorrectForm:
            let text = "Present form of\n\"\(word.written)\""
            input = .init(category: .text, string: text)
            switch outputType {
              case .image:
                fatalError("Not possible")
              case .text:
                otherOutput = Tense.allCases.without(.present).map { Representation(category: .text, string: conjugatable.conjugate(tense: $0, negative: .random(), type: .regular).id) }
                correctOutput = Representation(category: .text, string: conjugatable.conjugate(tense: .present, negative: false, type: .regular).id)
              case .voice:
                otherOutput = Tense.allCases.without(.present).map { Representation(category: .voice, string: conjugatable.conjugate(tense: $0, negative: .random(), type: .regular).id) }
                correctOutput = Representation(category: .voice, string: conjugatable.conjugate(tense: .present, negative: false, type: .regular).id)
            }
        }
      case .voice:
        fatalError("TODO")
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
  private let speech: Speech
}
