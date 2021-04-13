//
// The LanguagePractice project.
// Created by optionaldev on 10/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct Entry: Equatable {
    
    let from: Language
    let to: Language
 
    let input: String
    let output: String
    
    var type: (Language, Language) {
        return (from, to)
    }
    
    // No guarantee to have english text because it might be a 'simplified' type challenge
    var english: String? {
        from == .english ? input : (to == .english ? output : nil)
    }
    
    var foreign: String {
        from == .foreign ? input : output
    }
    
    var noImage: Bool {
        if let english = english {
            return Persistence.imagePath(id: english) == nil
        } else {
            return false
        }
    }
}

protocol EntryProtocol: Equatable, Identifiable {
    
    var inputLanguage: Language { get }
    var outputLanguage: Language { get }
    
    var input: String { get }
    var output: String { get }
    
    var inputPossibilities: [ChallengeType] { get}
    var outputPossibilities: [ChallengeType] { get }
    
    /// We're always learned some word or characters and this is how we identify it
    var foreignID: String { get }
    
    func sameType(as other: Self) -> Bool
    
    var noImage: Bool { get }
    
    var english: String? { get }
}

extension EntryProtocol {
    
    var noImage: Bool {
        if let english = english {
            return Persistence.imagePath(id: english) == nil
        }
        return false
    }
    
    var english: String? {
        if inputLanguage == .english {
            return input
        } else if outputLanguage == .english {
            return output
        }
        return nil
    }
}

enum KanaChallengeType {
    
    case foreign
    case romanToForeign
    case foreignToRoman
}

struct HiraganaEntry: EntryProtocol {
    
    init(id: String, kanaChallengeType: KanaChallengeType) {
        self.id = id
        self.kanaChallengeType = kanaChallengeType
    }
    
    let id: String
    private let kanaChallengeType: KanaChallengeType
    
    var inputLanguage: Language {
        return .foreign
    }
    
    var outputLanguage: Language {
        return .foreign
    }
    
    var input: String {
        switch kanaChallengeType {
        case .foreign:
            return id.toHiragana()
        case .romanToForeign:
            return id.removingDigits()
        case .foreignToRoman:
            return id.toHiragana()
        }
    }
    
    var output: String {
        switch kanaChallengeType {
        case .foreign:
            return id.toHiragana()
        case .romanToForeign:
            return id.toHiragana()
        case .foreignToRoman:
            return id.removingDigits()
        }
    }
    
    var inputPossibilities: [ChallengeType] {
        switch kanaChallengeType {
        case .foreign:
            return [.text(.foreign), .voice(.foreign)]
        case .romanToForeign:
            return [.text(.english)]
        case .foreignToRoman:
            return [.text(.foreign), .voice(.foreign)]
        }
    }
    
    var outputPossibilities: [ChallengeType] {
        switch kanaChallengeType {
        case .foreign:
            return [.text(.foreign), .voice(.foreign)]
        case .romanToForeign:
            return [.text(.foreign), .voice(.foreign)]
        case .foreignToRoman:
            return [.text(.english)]
        }
    }
    
    var foreignID: String {
        return id
    }
    
    func sameType(as other: Self) -> Bool {
        return kanaChallengeType == other.kanaChallengeType
    }
}

struct KatakanaEntry: EntryProtocol {
    
    init(id: String, kanaChallengeType: KanaChallengeType) {
        self.id = id
        self.kanaChallengeType = kanaChallengeType
    }
    
    let id: String
    private let kanaChallengeType: KanaChallengeType
    
    var inputLanguage: Language {
        return .foreign
    }
    
    var outputLanguage: Language {
        return .foreign
    }
    
    var input: String {
        switch kanaChallengeType {
        case .foreign:
            return id.toKatakana()
        case .romanToForeign:
            return id.removingDigits()
        case .foreignToRoman:
            return id.toKatakana()
        }
    }
    
    var output: String {
        switch kanaChallengeType {
        case .foreign:
            return id.toKatakana()
        case .romanToForeign:
            return id.toKatakana()
        case .foreignToRoman:
            return id.removingDigits()
        }
    }
    
    var inputPossibilities: [ChallengeType] {
        switch kanaChallengeType {
        case .foreign:
            return [.text(.foreign), .voice(.foreign)]
        case .romanToForeign:
            return [.text(.english)]
        case .foreignToRoman:
            return [.text(.foreign), .voice(.foreign)]
        }
    }
    
    var outputPossibilities: [ChallengeType] {
        switch kanaChallengeType {
        case .foreign:
            return [.text(.foreign), .voice(.foreign)]
        case .romanToForeign:
            return [.text(.foreign), .voice(.foreign)]
        case .foreignToRoman:
            return [.text(.english)]
        }
    }
    
    var foreignID: String {
        return id
    }
    
    func sameType(as other: Self) -> Bool {
        return kanaChallengeType == other.kanaChallengeType
    }
}
