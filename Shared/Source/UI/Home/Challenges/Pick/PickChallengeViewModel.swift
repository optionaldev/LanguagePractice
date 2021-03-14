//
// The LanguagePractice project.
// Created by optionaldev on 08/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import Foundation

final class PickChallengeViewModel: ObservableObject {
    
    @Published var history: [PickChallenge] = []
    
    // Reflects whether the answers are displayed when remaining is equal to the 'forfeitRetriesCount' in Constants
    @Published var challengeState: PickChallengeState = .regular
    
    var currentWord: PickChallenge {
        return history.last!
    }
    
    init() {
        guard let lexicon = Defaults.lexicon else {
            fatalError("Shouldn't allow creation of view model without lexicon existing")
        }
        self.lexicon = lexicon
        
        let foreignNouns = lexicon.foreign.nouns
        let challengeNouns = foreignNouns.shuffled().prefix(10)
        
        func extract(_ foreignNoun: ForeignNoun) -> [Entry] {
            var result = foreignNoun.english.flatMap { [Entry(from: .english,
                                                              to: .foreign,
                                                              input: $0,
                                                              output: foreignNoun.id),
                                                        Entry(from: .foreign,
                                                              to: .english,
                                                              input: foreignNoun.id,
                                                              output: $0) ] }

            if foreignNoun.kana != nil {
                // For input, we could show multiple english translations, but for output only 1,
                // so for now, display only the first and keep DB with first english translation
                // being the most accurate one
                guard let translation = foreignNoun.english.first else {
                    log("No english translation found for foreign word with ID \"\(foreignNoun.id)\"", type: .unexpected)
                    return result
                }
                
                result.append(Entry(from: .foreign,
                                    to: .foreign,
                                    input: foreignNoun.id,
                                    output: translation))
            }
            return result
        }
        
        challengeEntries = challengeNouns.flatMap { extract($0) }.shuffled()
        
        log("challengeEntries:")
        _ = challengeEntries.map { print("\($0.from) \"\($0.input)\" \($0.to) \"\($0.output)\"") }
        
        
        prepareNextChallenge()
        
        guard nextChallenge != nil else {
            log("no next challenge", type: .unexpected)
            return
        }
        informView()
        
        prepareNextChallenge()
    }
    
    // MARK: - Private
    
    private let challengeEntries: [Entry]
    private var lexicon: Lexicon
    private var nextChallenge: PickChallenge?
    
    private func prepareNextChallenge() {
        guard history.count < challengeEntries.count else {
            log("Nothing to prepare", type: .info)
            return
        }
        
        let nextEntry = challengeEntries[history.count]
        
        guard let nextForeignWord = lexicon.foreignDictionary[nextEntry.foreign] else {
            log("No foreign word with ID = \"\(nextEntry.foreign)\" found in dictionary", type: .unexpected)
            return
        }
        
        let inputType  = generateInputType(for: nextEntry)
        let input      = generateInput(for: nextEntry, inputType: inputType)
        let inputRep   = generateInputRep(for: nextEntry, inputType: inputType, input: input, word: nextForeignWord)
        
        let outputType = generateOutputType(for: nextEntry, inputType: inputType)
        var output     = generateOutput(for: nextEntry, outputType: outputType)
        let outputRep = generateOutputRep(outputType: outputType, output: output, word: nextForeignWord)
        
        let answerOutput: String
        // Handle the case where output is already kana in nextEntry for simplified case
        if nextEntry.to == .english {
            answerOutput = nextEntry.output
        } else if nextEntry.from == .foreign && nextEntry.to == .foreign {
            answerOutput = nextEntry.input
        } else {
            answerOutput = lexicon.foreignDictionary[nextEntry.output]?.id ?? ""
        }
        output.append(answerOutput)
        output.shuffle()
        
        let correctAnswerIndex = output.firstIndex(of: answerOutput)!
        
        if output.count < 6 {
            log("Something went wrong", type: .unexpected)
        }
        
        nextChallenge = PickChallenge(inputType: inputType,
                                      input: input,
                                      outputType: outputType,
                                      output: output,
                                      correctAnswerIndex: correctAnswerIndex,
                                      inputRepresentations: inputRep,
                                      outputRepresentations: outputRep)
    }
    
    private func informView() {
        if let nextChallenge = nextChallenge {
            history.append(nextChallenge)
        } else {
            // TODO: Handle challenge fininshed
        }
    }
    
    // MARK: Input
    
    private func generateInputType(for entry: Entry) -> ChallengeType {
        var inputTypePossibilities = ChallengeType.allCases
        
        if entry.from == .foreign && entry.to == .foreign {
            return .simplified
        } else {
            // TODO: Handle images and voice
            inputTypePossibilities.removing(.voice(.english))
            inputTypePossibilities.removing(.voice(.foreign))
            inputTypePossibilities.removing(.image)
            
            if entry.english != nil {
                inputTypePossibilities.removing(.simplified)
            }
            
            guard let randomInputType = inputTypePossibilities.randomElement() else {
                fatalError("Array should never be empty after applying filters")
            }
            return randomInputType
        }
    }
    
    private func generateInput(for entry: Entry, inputType: ChallengeType) -> String {
        if inputType == .text(.foreign) || inputType == .voice(.foreign) || inputType == .simplified {
            guard let inputWord = lexicon.foreignDictionary[entry.input] else {
                fatalError("Tried to fetch entry with ID \"\(entry.input)\" from foreign dictionary")
            }
            
            return inputWord.id
        } else {
            // For images and english input types, we simply use the input
            return entry.input
        }
    }
    
    private func generateInputRep(for entry: Entry, inputType: ChallengeType, input: String, word: ForeignWord) -> Rep {
        switch inputType {
        case .text(let language):
            switch language {
            case .english:
                return Rep.simpleText(.init(text: entry.input.removingDigits(),
                                            language: .english))
                
            case .foreign:
                if word.hasKana {
                    return .textWithFurigana(.init(text: word.characters.map { String($0) },
                                                   furigana: word.kanaComponenets,
                                                   english: entry.output.removingDigits()))
                } else {
                    return .simpleText(.init(text: word.characters,
                                             language: .foreign))
                }
            }
        case .voice(let language):
            switch language {
            case .english:
                return .voice(.init(text: entry.input.removingDigits(),
                                    language: .english))
            case .foreign:
                return .voice(.init(text: word.characters,
                                    language: .foreign))
            }
        case .image:
            return .image(.init(imageID: input))
        case .simplified:
            return .textWithTranslation(.init(text: word.characters,
                                              language: .foreign,
                                              translation: entry.output.removingDigits()))
        }
    }
    
    // MARK: Output
    
    private func generateOutputType(for entry: Entry, inputType: ChallengeType) -> ChallengeType {
        var outputTypePossibilities: [ChallengeType]
        switch inputType {
        case .text(let language):
            switch language {
            case .english:
                outputTypePossibilities = [.voice(.foreign), .text(.foreign)]
                
            case .foreign:
                outputTypePossibilities = [.image, .text(.english)]
            }
        case .voice(let language):
            switch language {
            case .english:
                outputTypePossibilities = [.voice(.foreign), .text(.foreign)]
            case .foreign:
                outputTypePossibilities = [.image, .text(.english) /*TODO: draw kanji ?*/]
            }
        case .image:
            outputTypePossibilities = [.text(.foreign), .voice(.foreign)]
        case .simplified:
            outputTypePossibilities = [.text(.foreign)]
        }
        
        if entry.english != nil {
            outputTypePossibilities.removing(.simplified)
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
    
    private func generateOutput(for entry: Entry, outputType: ChallengeType) -> [String] {
        // Get a list of challenge
        var otherSameTypeChallengeEntries = challengeEntries.filter { $0.type == entry.type &&
                                                                      $0 != entry }
        if let word = lexicon.foreignDictionary[entry.foreign] {
            let other = otherSameTypeChallengeEntries.filter { $0.english == nil ||
                                                              !word.english.contains($0.english!) }
            otherSameTypeChallengeEntries = other
        }
        
        var output: [String]
        switch outputType {
        case .image:
            // TODO: handle images
            return []
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
        
        return Array(output.removingDuplicates().prefix(5))
    }
    
    func generateOutputRep(outputType: ChallengeType, output: [String], word: ForeignWord) -> [Rep] {
        
        switch outputType {
        case .image:
            return output.map { Rep.image(.init(imageID: $0)) }
        case .simplified:
            return output.compactMap { lexicon.foreignDictionary[$0] }
                .map { Rep.textWithTranslation(.init(text: $0.kana ?? "kana-miss",
                                                     language: .foreign,
                                                     translation: $0.english.randomElement()!.removingDigits()))}
        case .text(let language):
            switch language {
            case .english:
                return output.map { Rep.textWithTranslation(.init(text: $0.removingDigits(),
                                                                  language: .english,
                                                                  translation: word.characters)) }
            case .foreign:
                return output.compactMap { lexicon.foreignDictionary[$0] }
                    .map { Rep.textWithFurigana(.init(text: $0.characters.map { String($0) },
                                                      furigana: $0.kanaComponenets,
                                                      english: $0.english.first!)) }
            }
        case .voice(let language):
            switch language {
            case .english:
                return output.map { Rep.voice(.init(text: $0.removingDigits(), language: .english)) }
            case .foreign:
                return output.compactMap { lexicon.foreignDictionary[$0] }
                    .map { Rep.voice(.init(text: $0.characters, language: .foreign)) }
            }
        }
    }
}
