//
// The LanguagePractice project.
// Created by optionaldev on 24/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

final class ChallengeProvider {
    
    static func generateInputComponents(entry: EntryProtocol) -> (ChallengeType, String, Rep) {
        let inputType = generateInputType(for: entry)
        let input = generateInput(for: entry, inputType: inputType)
        let inputRep = generateInputRep(for: entry, inputType: inputType, input: input)
        
        return (inputType, input, inputRep)
    }
    
    static func generatePick(for entry: EntryProtocol, allEntries: [EntryProtocol]) -> PickChallenge {
        
        let (inputType, input, inputRep) = generateInputComponents(entry: entry)
        
        let outputType = generateOutputType(for: entry, inputType: inputType)
        var output = generateOutput(for: entry, outputType: outputType, allEntries: allEntries)
        
        let answerOutput: String
        // Handle the case where output is already kana in nextEntry for simplified case
        if entry.outputLanguage == .english {
            answerOutput = entry.output
        } else if entry.inputLanguage == .foreign && entry.outputLanguage == .foreign {
            answerOutput = entry.input
        } else {
            answerOutput = lexicon.foreignDictionary[entry.output]?.id ?? ""
        }
        output.append(answerOutput)
        output.shuffle()
        
        let outputRep = generateOutputRep(for: entry, outputType: outputType, output: output)
        let correctAnswerIndex = output.firstIndex(of: answerOutput)!
        
        return PickChallenge(inputType: inputType,
                             input: input,
                             outputType: outputType,
                             output: output,
                             correctAnswerIndex: correctAnswerIndex,
                             inputRepresentations: inputRep,
                             outputRepresentations: outputRep)
    }
    
    private static func item(for entry: EntryProtocol) -> ForeignItem {
        guard let nextForeignItem = lexicon.foreignDictionary[entry.foreignID] else {
            log("No foreign word with ID = \"\(entry.foreignID)\" found in dictionary", type: .unexpected)
            fatalError("")
        }
        return nextForeignItem
    }
    
    static func generateTyping(for entry: EntryProtocol, allEntries: [EntryProtocol]) -> TypingChallenge {
        let (inputType, input, inputRep) = generateInputComponents(entry: entry)
        
        let output: [String]
        switch entry.outputLanguage {
        case .english:
            output = [entry.english].compactMap { $0 }
        case .foreign:
            let nextForeignItem = item(for: entry)
            if let word = nextForeignItem as? ForeignWord {
                output = [word.id.removingDigits(), word.kana, word.characters].compactMap { $0 }
            } else {
                output = [nextForeignItem.id.removingDigits()]
            }
        }
        
        return TypingChallenge(inputType: inputType,
                               input: input,
                               inputRepresentation: inputRep,
                               output: output)
    }
    
    static var lexicon = Defaults.lexicon!
    
    private static func generateInputType(for entry: EntryProtocol) -> ChallengeType {
        var inputTypePossibilities = entry.inputPossibilities
        
        if entry is WordEntry && entry.inputLanguage == entry.outputLanguage {
            return .simplified
        } else {
            inputTypePossibilities.removing(.simplified)
        }
        
        // In case there's no images found, we can't create image based challenges
        // For entries that don't have "from" as english, it doens't make sense to create an image based challenge
        // We would just end up trying to guess if an image representing a concept matching an english word,
        // which defeats the purpose of trying to learn a foreign word
        if entry.noImage || entry.inputLanguage != .english {
            inputTypePossibilities.removing(.image)
        }
        
        // `entry.to` represents the output type, but here we're trying to generate the input type
        // and aside from simplified challenge, input & output are never the same language
        inputTypePossibilities.removing(.voice(entry.outputLanguage))
        inputTypePossibilities.removing(.text(entry.outputLanguage))
        
        if entry.english != nil {
            inputTypePossibilities.removing(.simplified)
        }
        
        guard let randomInputType = inputTypePossibilities.randomElement() else {
            fatalError("Array should never be empty after applying filters")
        }
        
        return randomInputType
    }
    
    private static func generateInput(for entry: EntryProtocol, inputType: ChallengeType) -> String {
        if inputType == .text(.foreign) || inputType == .voice(.foreign) || inputType == .simplified {
            guard let inputWord = lexicon.foreignDictionary[entry.foreignID] else {
                fatalError("Tried to fetch entry with ID \"\(entry.foreignID)\" from foreign dictionary")
            }
            
            return inputWord.id
        } else {
            // For images and english input types, we simply use the input
            return entry.input
        }
    }
    
    private static func generateInputRep(for entry: EntryProtocol, inputType: ChallengeType, input: String) -> Rep {
        let nextForeignItem = item(for: entry)
        
        switch inputType {
        case .text(let language):
            switch language {
            case .english:
                return .simpleText(.init(text: entry.input.removingDigits(),
                                         language: .english))
                
            case .foreign:
                if let word = nextForeignItem as? ForeignWord {
                    if word.hasKana {
                        return .textWithFurigana(.init(text: word.characters.map { String($0) },
                                                       furigana: word.kanaComponenets,
                                                       english: entry.output.removingDigits()))
                    } else {
                        return .simpleText(.init(text: nextForeignItem.characters,
                                                 language: .foreign))
                    }
                } else {
                    /// ???
                    return .simpleText(.init(text: "", language: .english))
                }
            }
        case .voice(let language):
            switch language {
            case .english:
                return .voice(.init(text: entry.input.removingDigits(),
                                    language: .english))
            case .foreign:
                return .voice(.init(text: nextForeignItem.characters,
                                    language: .foreign))
            }
        case .image:
            return .image(.init(imageID: input))
        case .simplified:
            return .textWithTranslation(.init(text: nextForeignItem.characters,
                                              language: .foreign,
                                              translation: entry.output.removingDigits()))
        }
    }
    
    // MARK: Output
    
    private static func generateOutputType(for entry: EntryProtocol, inputType: ChallengeType) -> ChallengeType {
        var outputTypePossibilities: [ChallengeType]
        
        switch inputType {
        case .text(let language):
            switch language {
            case .english:
                outputTypePossibilities = [.text(.foreign), .voice(.foreign)]
            case .foreign:
                outputTypePossibilities = [.text(.english), .image]
            }
        case .voice(let language):
            switch language {
            case .english:
                outputTypePossibilities = [.text(.foreign), .voice(.foreign)]
            case .foreign:
                outputTypePossibilities = [.text(.english), .image /*TODO: draw kanji ?*/]
            }
        case .image:
            outputTypePossibilities = [.text(.foreign), .voice(.foreign)]
        case .simplified:
            outputTypePossibilities = [.text(.foreign)]
        }
        
        if entry.english != nil || entry is KanaEntryProtocol {
            outputTypePossibilities.removing(.simplified)
        }
        
        if entry.noImage {
            outputTypePossibilities.removing(.image)
        } else {
            // TODO: handle not enough images downloaded so far
        }
        
        var outputType: ChallengeType
        if inputType == .simplified {
            outputType = .simplified
        } else {
            guard let randomOutputType = outputTypePossibilities.randomElement() else {
                fatalError("Array is empty after filters are applied")
            }
            outputType = randomOutputType
        }
        
        return outputType
    }
    
    private static func generateOutput(for entry: EntryProtocol, outputType: ChallengeType, allEntries: [EntryProtocol]) -> [String] {
        
        let nextItem = item(for: entry)
        
        var otherSameTypeChallengeEntries = allEntries.filter { $0.typeIndex == entry.typeIndex && $0.foreignID != entry.foreignID }
        if let word = nextItem as? ForeignWord {
            let other = otherSameTypeChallengeEntries.filter { $0.english == nil ||
                                                              !word.english.contains($0.english!) }
            otherSameTypeChallengeEntries = other
        }
        
        var output: [String]
        switch outputType {
        case .image:
            // Get a list of all input, which in our scenario can only represent english IDs
//            let otherChallengeEntryIDs = otherSameTypeChallengeEntries.map { $0.output }
            // TODO: Handle when current challenge doesn't countain 5 images
            let otherChallengeEntryIDs = lexicon.english.nouns.map { $0.id }
            
            // Get a list of all images available for current english IDs
            output = otherChallengeEntryIDs.filter { Persistence.imagePath(id: $0) != nil }
            
            output.removing(entry.english!)
            
            // TODO: Handle picking images from other entries
            log("Before filtering, found \(output.count) entries with images")
            
            if output.count < 6 {
                fatalError("Not enough images")
            }
            
        case .simplified:
            output = otherSameTypeChallengeEntries.map { $0.input }
            
        case .text(let language):
            switch language {
            case .english:
                output = Array(otherSameTypeChallengeEntries.map { $0.output })
            case .foreign:
                let outputIDs = Array(otherSameTypeChallengeEntries.map { $0.output })
                output = outputIDs.compactMap { lexicon.foreignDictionary[$0]?.id }
            }
            
        case .voice(let language):
            switch language {
            case .english:
                output = Array(otherSameTypeChallengeEntries.map { $0.output })
            case .foreign:
                let outputIDs = Array(otherSameTypeChallengeEntries.map { $0.output })
                output = outputIDs.compactMap { lexicon.foreignDictionary[$0]?.id }
            }
        }
        
        output = Array(output.removingDuplicates().prefix(5))
        
        guard output.count == 5 else {
            fatalError("`output` should have exactly 5 entries")
        }
        
        return output
    }
    
    private static func generateOutputRep(for entry: EntryProtocol, outputType: ChallengeType, output: [String]) -> [Rep] {
        let result: [Rep]
        
        switch outputType {
        case .image:
            result = output.map { Rep.image(.init(imageID: $0)) }
        case .simplified:
            
            result = output.compactMap { lexicon.foreignDictionary[$0] }
                .compactMap { $0 as? ForeignWord }
                .map { Rep.textWithTranslation(.init(text: $0.kana ?? "kana-miss",
                                                     language: .foreign,
                                                     translation: $0.english.randomElement()!.removingDigits()))}
        case .text(let language):
            switch language {
            case .english:
                result = output.map { Rep.textWithTranslation(.init(text: $0.removingDigits(),
                                                                    language: .english,
                                                                    translation: item(for: entry).characters)) }
            case .foreign:
                result = output.compactMap { lexicon.foreignDictionary[$0] }
                    .compactMap { $0 as? ForeignWord }
                    .map { Rep.textWithFurigana(.init(text: $0.characters.map { String($0) },
                                                      furigana: $0.kanaComponenets,
                                                      english: $0.english.first!)) }
            }
        case .voice(let language):
            switch language {
            case .english:
                result = output.map { Rep.voice(.init(text: $0.removingDigits(), language: .english)) }
            case .foreign:
                result = output.compactMap { lexicon.foreignDictionary[$0] }
                    .map { Rep.voice(.init(text: $0.characters, language: .foreign)) }
            }
        }
        
        guard result.count == 6 else {
            fatalError("There should be exactly 6 output representations.")
        }
        
        return result
    }
}
