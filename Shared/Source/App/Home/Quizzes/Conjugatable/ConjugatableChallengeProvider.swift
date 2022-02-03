//
// The LanguagePractice (iOS) project.
// Created by optionaldev on 03/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

final class ConjugatableChallengeProvider: ChallengeProvidable {
  
  init(lexicon: Lexicon = .shared, speech: Speech = .shared) {
    self.lexicon = lexicon
    self.speech = speech
  }
  
  // MARK: - ChallengeProvidable conformance
  
  func generateTyping(fromPool pool: [Distinguishable], index: Int) -> TypingChallenge {
    fatalError()
  }
  
  func generatePick(fromPool pool: [Distinguishable], index: Int) -> PickChallenge {
    let pool = pool.compactMap { $0 as? ConjugatableEntry }
    let entry = pool[index]
    
    guard let conjugatable = lexicon.foreignDictionary[entry.id] as? ForeignConjugatable else {
      fatalError("Couldn't find conjugatable with id: \"\(entry.id)\"")
    }
    
    guard let word = lexicon.foreignDictionary[entry.id] as? ForeignWord else {
      fatalError("Couldn't find word with id: \"\(entry.id)\"")
    }
    
    let possibleTenses: [Tense] = [.past, .present, .future]
    
    // TODO: Improve
    let voiceEnabled = speech.voicePossible(forEntry: entry)
    
    let inputType: Possibility = voiceEnabled ? [.voice, .text].randomElement()! : .text
    
    let input: InputRepresentation
    let outputType: Possibility = voiceEnabled ? [.voice, .text].randomElement()! : .text
    
    let correctOutput: OutputRepresentation
    var output: [OutputRepresentation]
    
    let inputVariation = ConjugationVariation(tense: possibleTenses.randomElement()!, negative: .random(), type: .allCases.randomElement()!)
    
    let outputTenses = possibleTenses.without(inputVariation.tense)
    let outputVariations = allVariations(outputTenses: outputTenses).shuffled().prefix(5)
    
    let inputText: String
    switch entry.category {
      case .askCorrectForm:
        inputText = "Present form of:\n\"\(word.written)\""
      case .askTense:
        inputText = conjugatable.conjugate(variation: inputVariation).id
    }
    
    switch inputType {
      case .image:
        fatalError("Not possible")
      case .text:
        input = .text(inputText)
      case .voice:
        input = .voice(inputText)
    }
    
    let correctOutputText: String
    let otherOutputTexts: [String]
    switch entry.category {
      case .askCorrectForm:
        otherOutputTexts = outputVariations.map { conjugatable.conjugate(variation: $0).id }
        correctOutputText = conjugatable.conjugate(variation: inputVariation).id
      case .askTense:
        otherOutputTexts = outputVariations.map { $0.spoken }
        correctOutputText = inputVariation.spoken
    }
    
    switch outputType {
      case .image:
        fatalError("Not possible")
      case .text:
        output = otherOutputTexts.map { .text($0) }
        correctOutput = .text(correctOutputText)
      case .voice:
        output = otherOutputTexts.map { .voice($0) }
        correctOutput = .voice(correctOutputText)
    }
    
    output.append(correctOutput)
    output.shuffle()
    
    guard let correctAnswerIndex = output.firstIndex(where: { $0.description == correctOutput.description }) else {
      fatalError("Couldn't find correct answer in list of answers.")
    }
    
    return PickChallenge(inputRep: input, outputRep: output, correctAnswerIndex: correctAnswerIndex)
  }
  
  // MARK: - Private
  
  private let lexicon: Lexicon
  private let speech: Speech
  
  private func allVariations(outputTenses: [Tense]) -> [ConjugationVariation] {
    var result: [ConjugationVariation] = []
    for tense in outputTenses {
      for conjugationType in ConjugationType.allCases {
        result.append(ConjugationVariation(tense: tense, negative: true, type: conjugationType))
        result.append(ConjugationVariation(tense: tense, negative: false, type: conjugationType))
      }
    }
    return result
  }
}
