//
// The LanguagePractice project.
// Created by optionaldev on 23/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

import Dispatch

import class Foundation.DispatchQueue
import class Foundation.NumberFormatter

import protocol Foundation.ObservableObject

import struct Foundation.Date
import struct Foundation.Published
import struct Foundation.TimeInterval

protocol Challengeable: class {
    
    associatedtype Challenge: ChallengeProtocol
    
    var challengeEntries: [AnyEntry] { get }
    
    /// Holds all the challenge that have been completed and the challenge that is currently
    /// being done.
    var visibleChallenges: [Challenge] { get set }
    
    /// Used to display words that were considered "learned", based on different metrics.
    ///
    /// This is populated at the end of the quiz.
    var wordsLearned: [String] { get }
    
    /// Challenge that the user is currently seeing (unless the content was scrolled)
    var currentChallenge: Challenge { get }
    
    /// Challenge that was prepared for when the user finished the current one. When the
    /// value is nil, there are no more challenges and the results screen should be prepared.
    var nextChallenge: Challenge? { get set }
    
    /// Defines the point at which the challenge measurement time starts.
    ///
    /// When a challenge starts is different based on the type of challenge the user is given.
    ///
    /// For challenges where information is instantly visible (e.g: text challenges, image
    /// challenges), the value is set as soon as all the challenge elements are visible
    /// (taking animation into consideration)
    ///
    /// For challenges where information is not instantly visible (e.g: voice challenges)
    /// the value is set after the sound is heard. For input, this means after the screen is
    /// presented and the sound has been heard. For output, this means after the correct
    /// answer has been heart the firs time
    var challengeStartTime: Date { get }
    
    init(entries: [AnyEntry])
    
    func inputTapped()
    
    func goToNext()
    
    func finishedCurrentChallenge()
    
    func prepareNextChallenge()
    
    func handleFinish()
}

extension Challengeable {
    
    var currentChallenge: Challenge {
        return visibleChallenges.last!
    }
    
    func inputTapped() {
        if case .voice(let rep) = currentChallenge.inputRepresentation {
            Speech.shared.speak(string: rep.text, language: rep.language)
        }
    }
    
    func goToNext() {
        finishedCurrentChallenge()
        
        if let nextChallenge = nextChallenge {
            visibleChallenges.append(nextChallenge)
        } else {
            handleFinish()
        }
        
        // At this point, we've already appended the `nextChallenge` to the `history` array
        nextChallenge = nil
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.prepareNextChallenge()
        }
    }
}
//
//final class Implementation: Challengeable {
//    
//    @Published var visibleChallenges: [TypingChallenge] = []
//    @Published private(set) var wordsLearned: [String] = []
//    @Published private(set) var currentText: String = "" {
//        didSet {
//            log("currentText = \(currentText)")
//            if currentText != "" {
//                verifyText()
//            }
//        }
//    }
//    
//    /// Reflects whether the answers are displayed when remaining is equal to the 'forfeitRetriesCount' in Constants
//    @Published var challengeState: TypingQuizState = .regular
//    
//    init(entries: [AnyEntry]) {
//        challengeEntries = entries
//        
//        guard let lexicon = Defaults.lexicon else {
//            fatalError("Tried to create challenge without lexicon existing")
//        }
//        self.lexicon = lexicon
//    }
//    
//    private(set) var challengeEntries: [AnyEntry]
//    private(set) var challengeStartTime = Date()
//    private(set) var lexicon: Lexicon
//    private(set) var nextChallenge: TypingChallenge? = nil
//    
//    private func verifyText() {
//        // To make it easy to practice in simulator (maybe macOS too)
//        // make § key (above Tab key) a quick forfeit
//        if currentText.contains("§") {
//            forfeitCurrentWord()
//            return
//        }
//
//        // In order to avoid having situations like:
//        //  - accidental double space between words
//        //  - accidental space before the first word
//        //  - japanese space vs english space (they are different characters)
//        //  - user typing dont instead of don't
//        // and other things like this, we ignore any special characters
//        // TODO: Handle allowing 1,2,3 as a guess answer for ー, 二, 三 etc
//        let processedGuess = currentText.filter { $0.isLetter }.lowercased()
//        let processedAnswers = currentChallenge.output.map { $0.filter { $0.isLetter }.lowercased() }
//        
//        if processedAnswers.contains(processedGuess) {
//            // Trying to immediately set 'currentText' to empty string results in a glitch
//            // where the previous text is still visible after making the change
//            // This only happens on Release builds even though it doesn't seem related to optimization level
//            // This also only happens when trying to change multiple @Published elements, probably causing
//            // the view to be in an undefined state
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                self.currentText = ""
//            }
//            
//            switch challengeState {
//            case .regular:
//                handleRegularSuccess()
//            case .forfeited(let remainingGuessesNeeded):
//                handleReset(remaining: remainingGuessesNeeded - 1)
//            }
//        }
//    }
//    
//    func forfeitCurrentWord() {
//        currentText = ""
//        challengeState = .forfeited(AppConstants.forfeitRetriesCount)
//    }
//    
//    // MARK: - Private
//    
//    func handleRegularSuccess() {
//        if let nextChallenge = nextChallenge {
//            if let index = currentChallenge.output.firstIndex(of: currentText) {
//                visibleChallenges[visibleChallenges.count - 1].state = .finished(challengeStartTime.distance(to: Date()), index)
//            }
//            visibleChallenges.append(nextChallenge)
//            prepareNextChallenge()
//        } else {
//            // TODO: handle reset or show statistics
//            log("Challenge completed")
//        }
//    }
//
//    func handleReset(remaining remainingGuessesNeeded: Int) {
//        if remainingGuessesNeeded == 1 {
//            challengeState = .regular
//        } else {
//            challengeState = .forfeited(remainingGuessesNeeded)
//        }
//    }
//    
//    func prepareNextChallenge() {
//        guard visibleChallenges.count < challengeEntries.count else {
//            log("Nothing to prepare", type: .info)
//            return
//        }
//
//        let nextEntry = challengeEntries[visibleChallenges.count]
//        guard let nextForeignWord = lexicon.foreignDictionary[nextEntry.foreignID] else {
//            log("No foreign word with ID = \"\(nextEntry.foreignID)\" found in dictionary", type: .unexpected)
//            return
//        }
//        log("\n\n", type: .info)
//
//        let output: [String]
//        switch nextEntry.outputLanguage {
//        case .english:
//            output = [nextEntry.english].compactMap { $0 }
//        case .foreign:
//            output = [nextForeignWord.id.removingDigits(), nextForeignWord.kana, nextForeignWord.characters].compactMap { $0 }
//        }
//        
//        let voiceDisabled = Defaults.bool(forKey: .voiceEnabled) == false
//        
//        let noImageFound: Bool
//        if let englishID = nextEntry.english {
//            noImageFound = Persistence.imagePath(id: englishID) == nil
//        } else {
//            noImageFound = true
//        }
//
//        var inputTypePossibilities = ChallengeType.allCases
//        
//        let inputType: ChallengeType
//        if nextEntry.inputLanguage == .foreign && nextEntry.outputLanguage == .foreign {
//            inputType = .simplified
//        } else {
//            if voiceDisabled {
//                inputTypePossibilities.removing(.voice(.english))
//                inputTypePossibilities.removing(.voice(.foreign))
//            }
//            
//            // In case there's no images found, we can't create image based challenges
//            // For entries that don't have "from" as english, it doens't make sense to create an image based challenge
//            // We would just end up trying to guess if an image representing a concept matches an english word,
//            // which defeats the purpose of trying to learn a foreign word
//            if noImageFound || nextEntry.inputLanguage != .english {
//                inputTypePossibilities.removing(.image)
//            }
//            
//            if nextEntry.english != nil {
//                inputTypePossibilities.removing(.simplified)
//            }
//            
//            // Remove possibilities for output's language
//            inputTypePossibilities.removing(.voice(nextEntry.outputLanguage))
//            inputTypePossibilities.removing(.text(nextEntry.outputLanguage))
//             
//            guard let randomInputType = inputTypePossibilities.randomElement() else {
//                fatalError("Array is empty after filters are applied")
//            }
//            inputType = randomInputType
//        }
//        
//        let input: String
//        let inputRepresentation: Rep
//        switch inputType {
//        case .text(let language):
//            switch language {
//            case .english:
//                input = nextEntry.input
//                
//                inputRepresentation = Rep.simpleText(.init(text: nextEntry.input.removingDigits(),
//                                                           language: .english))
//                    //Rep.textWithTranslation(.init(text: nextEntry.input.removingDigits(),
//                      //                                              language: .english,
//                        //                                            translation: nextForeignWord.characters))
//                
//            case .foreign:
//                let entry = lexicon.foreignDictionary[nextEntry.input]
//                input = entry?.id ?? ""
//                
//                if nextForeignWord.hasKana {
//                    inputRepresentation = .textWithFurigana(.init(text: nextForeignWord.characters.map { String($0) },
//                                                                  furigana: nextForeignWord.kanaComponenets,
//                                                                  english: nextEntry.output.removingDigits()))
//                } else {
//                    inputRepresentation = .simpleText(.init(text: nextForeignWord.characters,
//                                                            language: .foreign))
//                }
//            }
//        case .voice(let language):
//            switch language {
//            case .english:
//                input = nextEntry.input
//                inputRepresentation = .voice(.init(text: nextEntry.input.removingDigits(),
//                                                   language: .english))
//            case .foreign:
//                let entry = lexicon.foreignDictionary[nextEntry.input]
//                input = entry?.id ?? ""
//                inputRepresentation = .voice(.init(text: nextForeignWord.characters,
//                                                   language: .foreign))
//            }
//        case .image:
//            input = nextEntry.input
//            inputRepresentation = .image(.init(imageID: input))
//        case .simplified:
//            let entry = lexicon.foreignDictionary[nextEntry.input]
//            input = entry?.id ?? ""
//            inputRepresentation = .textWithTranslation(.init(text: nextForeignWord.characters,
//                                                             language: .foreign,
//                                                             translation: nextEntry.output.removingDigits()))
//        }
//        
//        log("inputType = \(inputType) input = \"\(input)\"")
//        log("inputRep = \(inputRepresentation)")
//        log("output = \(output)")
//        
//        nextChallenge = TypingChallenge(inputType: inputType,
//                                        input: input,
//                                        inputRepresentation: inputRepresentation,
//                                        output: output)
//    }
//}
