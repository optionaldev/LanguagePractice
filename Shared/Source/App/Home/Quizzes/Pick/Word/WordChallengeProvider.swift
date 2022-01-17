//
// The LanguagePractice project.
// Created by optionaldev on 17/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

final class WordChallengeProvider {
  
  init(lexicon: Lexicon = .shared, speech: Speech = .shared) {
    self.lexicon = lexicon
    self.speech = speech
  }
  
  func generate(fromPool pool: [WordEntry], index: Int) -> PickChallenge {
    let entry = pool[index]
    
    guard let word = lexicon.foreignDictionary[entry.id] as? ForeignWord else {
      fatalError("Couldn't find word with id: \"\(entry.id)\"")
    }
    
    // TODO: Improve
    let voiceEnabled = speech.voicePossible(forEntry: entry)
    
    var inputTypePossibilities: [Possibility] = [.text]
    var outputTypePossibilities: [Possibility] = [.text]
    
    if voiceEnabled {
      inputTypePossibilities.append(.voice)
      outputTypePossibilities.append(.voice)
    }
    
    if Persistence.imagePath(id: word.id) != nil && entry.category == .english {
      inputTypePossibilities.append(.image)
    }
    
    let otherWords: [ForeignWord] = pool
      .compactMap { lexicon.foreignDictionary[$0.id] as? ForeignWord }
      .filter { $0.id != word.id }
    
    let otherWordsWithImages = otherWords.filter { Persistence.imagePath(id: $0.id) != nil }
    
    let irrespectiveOfImagesOtherWords = processedWords(otherWords)
    
    if otherWordsWithImages.count >= Defaults.outputCount - 1 && entry.category == .foreign {
      outputTypePossibilities.append(.image)
    }
    
    let inputType = inputTypePossibilities.randomElement()!
    let outputType = inputTypePossibilities.randomElement()!
    
    let input: InputRepresentation
    var output: [OutputRepresentation]
    var correctOutput: OutputRepresentation
    
    switch inputType {
      case .image:
        input = .image(word.id)
        
        // Can not be english category as output
        // Can not be image category as output
        switch outputType {
          case .image:
            fatalError("Should be possible to have image to image, since both images represent english")
          case .voice:
            output = irrespectiveOfImagesOtherWords.map { .voice($0.spoken) }
            correctOutput = .voice(word.spoken)
          case .text:
            output = irrespectiveOfImagesOtherWords.map { generateTextualRepresentation(forWord: $0) }
            correctOutput = .image(word.written)
        }
      case .voice:
        input = .voice(word.spoken)
        (output, correctOutput) = generateOutput(word: word, nonImageSource: irrespectiveOfImagesOtherWords, imageSource: otherWordsWithImages, outputType: outputType, category: entry.category)
      case .text:
        input = .text(word.written)
        (output, correctOutput) = generateOutput(word: word, nonImageSource: irrespectiveOfImagesOtherWords, imageSource: otherWordsWithImages, outputType: outputType, category: entry.category)
    }
    
    output.append(correctOutput)
    
    guard let correctAnswerIndex = output.firstIndex(where: { $0.description == correctOutput.description }) else {
      fatalError("Couldn't find correct answer in list of answers.")
    }
    
    return PickChallenge(inputRep: input, outputRep: output, correctAnswerIndex: correctAnswerIndex)
  }
  
  // MARK: - Private
  
  private let lexicon: Lexicon
  private let speech: Speech
  
  private func processedWords(_ words: [ForeignWord]) -> [ForeignWord] {
    return words
      .shuffled()
      .prefix(Defaults.outputCount - 1)
      .map { $0 }
  }
  
  private func generateTextualRepresentation(forWord word: ForeignWord) -> OutputRepresentation {
    if word.hasFurigana {
      let charactersArray = word.written.map { String($0) }
      let representation = FuriganaRep(text: charactersArray,
                                       groups: word.kanaComponents)
      if word.groupFurigana {
        return .textWithIrregularFurigana(representation)
      } else {
        return .textWithRegularFurigana(representation)
      }
    } else {
      return .text(word.written)
    }
  }
  
  private func generateOutput(word: ForeignWord, nonImageSource: [ForeignWord], imageSource: [ForeignWord], outputType: Possibility, category: WordEntry.Category) -> ([OutputRepresentation], OutputRepresentation) {
    switch outputType {
      case .image:
        switch category {
          case .english:
            fatalError("Can't have images as foreign output")
          case .foreign:
            return (processedWords(imageSource).map { OutputRepresentation.image($0.id) }, OutputRepresentation.image(word.id))
        }
      case .text:
        return (nonImageSource.map { .text($0.written) }, .text(word.written))
      case .voice:
        return (nonImageSource.map { .voice($0.spoken) }, .voice(word.spoken))
    }
  }
}
