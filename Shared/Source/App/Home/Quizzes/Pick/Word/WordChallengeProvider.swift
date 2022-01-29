//
// The LanguagePractice project.
// Created by optionaldev on 17/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

final class WordChallengeProvider: ChallengeProvidable {
  
  init(lexicon: Lexicon = .shared, speech: Speech = .shared) {
    self.lexicon = lexicon
    self.speech = speech
  }
  
  // MARK: - ChallengeProvidable conformance
  
  func generateTyping(fromPool pool: [Distinguishable], index: Int) -> TypingChallenge {
    fatalError()
  }
  
  func generatePick(fromPool pool: [Distinguishable], index: Int) -> PickChallenge {
    let pool = pool.compactMap { $0 as? WordEntry }
    let entry = pool[index]
    
    guard let foreignWord = lexicon.foreignDictionary[entry.id] as? ForeignWord else {
      fatalError("Couldn't find word with id: \"\(entry.id)\"")
    }
    
    let englishWord = randomEnglishWord(forForeignWordId: foreignWord.id)
    
    // TODO: Improve
    let voiceEnabled = speech.voicePossible(forEntry: entry)
    
    var inputTypePossibilities: [Possibility] = [.text]
    var outputTypePossibilities: [Possibility] = [.text]
    
    if voiceEnabled {
      inputTypePossibilities.append(.voice)
      outputTypePossibilities.append(.voice)
    }
    
    let otherItems: [Item] = pool
      .compactMap { item in
        switch entry.category {
          case .foreign:
            let englishIds: [String] = (lexicon.foreignDictionary[item.id] as? ForeignWord)?.english ?? []
            let oneEnglishId = englishIds.randomElement()!
            return lexicon.englishDictionary[oneEnglishId]
          case .english:
            return lexicon.foreignDictionary[item.id]
        }
      }
      .filter { $0.id != foreignWord.id }
    
    // We need unique values since there's multiple entries with same id,
    // but what differentiates them is the combination of id and category
    var uniqueItems: [Item] = []
    for (_, item) in otherItems.enumerated() {
      if uniqueItems.contains(where: { $0.id == item.id }) == false {
        uniqueItems.append(item)
      }
    }
    
    let idsWithImages = uniqueItems
      .compactMap { $0 as? ForeignWord }
      .flatMap { $0.englishImages }
    
    let irrespectiveOfImagesOtherWords = uniqueItems.output
    
    switch entry.category {
      case .english:
        if foreignWord.englishImages.isNonEmpty {
          inputTypePossibilities.append(.image)
        }
      case .foreign:
        if idsWithImages.count >= Defaults.outputCount - 1 {
          outputTypePossibilities.append(.image)
        }
    }
    
    let inputType = inputTypePossibilities.randomElement()!
    let outputType = inputTypePossibilities.randomElement()!
    
    let input: InputRepresentation
    var output: [OutputRepresentation]
    var correctOutput: OutputRepresentation
    
    switch inputType {
      case .image:
        input = .image(foreignWord.englishImages.shuffled()[0])
      case .voice:
        switch entry.category {
          case .english:
            input = .voice(englishWord.spoken)
          case .foreign:
            input = .voice(foreignWord.spoken)
        }
      case .text:
        switch entry.category {
          case .english:
            input = .text(englishWord.written)
          case .foreign:
            input = .text(foreignWord.written)
        }
    }
    
    switch outputType {
      case .image:
        output = idsWithImages.output.map { OutputRepresentation.image($0) }
        correctOutput = .image(foreignWord.englishImages.shuffled()[0])
      case .text:
        output = irrespectiveOfImagesOtherWords.map { .text($0.written) }
        switch entry.category {
          case .english:
            correctOutput = .text(foreignWord.written)
          case .foreign:
            correctOutput = .text(englishWord.written)
        }
      case .voice:
        output = irrespectiveOfImagesOtherWords.map { .voice($0.spoken) }
        switch entry.category {
          case .english:
            correctOutput = .voice(foreignWord.spoken)
          case .foreign:
            correctOutput = .voice(englishWord.spoken)
        }
    }
    /*
     :text
     
     case .foreign:
     let englishTranslation = (word as? ForeignWord)?.english.randomElement() ?? ""
     return (nonImageSource.map { .text($0.written) }, .text(englishTranslation))
     case .english:
     return (nonImageSource.map { .text($0.written) }, .text(word.written))
     }
     
     case .voice:
     
     switch category {
     case .foreign:
     return (nonImageSource.map { .voice($0.spoken) }, .voice(randomEnglishWord(forForeignWordId: word.id).spoken))
     case .english:
     return (nonImageSource.map { .voice($0.spoken) }, .voice(word.spoken))
     }
    
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
        switch entry.category {
          case .english:
            input = .voice(randomEnglishWord(forForeignWordId: word.id))
          case .foreign:
            input = .voice(word.spoken)
        }
        
        (output, correctOutput) = generateOutput(word: word, nonImageSource: irrespectiveOfImagesOtherWords, imageSource: otherItemsWithImages, outputType: outputType, category: entry.category)
      case .text:
        switch entry.category {
          case .english:
            input = .text(word.english.randomElement()!)
          case .foreign:
            input = .text(word.written)
        }
        
        (output, correctOutput) = generateOutput(word: word, nonImageSource: irrespectiveOfImagesOtherWords, imageSource: otherItemsWithImages, outputType: outputType, category: entry.category)
    }
     */
    
    output.append(correctOutput)
    
    guard let correctAnswerIndex = output.firstIndex(where: { $0.description == correctOutput.description }) else {
      fatalError("Couldn't find correct answer in list of answers.")
    }
    
    log("----------------------")
    log("category = \(entry.category)")
    log("inputType = \(inputType)")
    log("outputType = \(outputType)")
    log("input = \(input)")
    log("output = \(output.map { $0.description })")
    log("correct answer index = \(correctAnswerIndex)")
    
    return PickChallenge(inputRep: input, outputRep: output, correctAnswerIndex: correctAnswerIndex)
  }
  
  // MARK: - Private
  
  private let lexicon: Lexicon
  private let speech: Speech
  
  private func generateTextualRepresentation(forWord item: Item) -> OutputRepresentation {
    if let foreignWord = item as? ForeignWord,
       foreignWord.hasFurigana
    {
      let charactersArray = foreignWord.written.map { String($0) }
      let representation = FuriganaRep(text: charactersArray,
                                       groups: foreignWord.kanaComponents)
      if foreignWord.groupFurigana {
        return .textWithIrregularFurigana(representation)
      } else {
        return .textWithRegularFurigana(representation)
      }
    } else {
      return .text(item.written)
    }
  }
  
//  private func generateOutput(word: Item, nonImageSource: [Item], imageSource: [Item], outputType: Possibility, category: WordEntry.Category) -> ([OutputRepresentation], OutputRepresentation) {
//    switch outputType {
//      case .image:
//        switch category {
//          case .english:
//            fatalError("Can't have images as foreign output")
//          case .foreign:
//            return (processedWords(imageSource).map { OutputRepresentation.image($0.id) }, OutputRepresentation.image(word.id))
//        }
//      case .text:
//        switch category {
//          case .foreign:
//            let englishTranslation = (word as? ForeignWord)?.english.randomElement() ?? ""
//            return (nonImageSource.map { .text($0.written) }, .text(englishTranslation))
//          case .english:
//            return (nonImageSource.map { .text($0.written) }, .text(word.written))
//        }
//
//      case .voice:
//        switch category {
//          case .foreign:
//            return (nonImageSource.map { .voice($0.spoken) }, .voice(randomEnglishWord(forForeignWordId: word.id).spoken))
//          case .english:
//            return (nonImageSource.map { .voice($0.spoken) }, .voice(word.spoken))
//        }
//    }
//  }
  
  func randomEnglishWord(forForeignWordId foreignId: String) -> EnglishItem {
    guard let foreignWord = lexicon.foreignDictionary[foreignId] as? ForeignWord else {
      fatalError()
    }
    guard let randomEnglishId = foreignWord.english.randomElement() else {
      fatalError()
    }
    guard let englishItem = lexicon.englishDictionary[randomEnglishId] else {
      fatalError()
    }
    return englishItem
  }
}
