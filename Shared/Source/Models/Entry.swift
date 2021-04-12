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

enum KanaEntry: EntryProtocol {
    
    case foreign(id: String)
    case romanToForeign(_ id: String)
    case foreignToRoman(_ id: String)
    
    init(from: Language, _ input: String, to: Language?, _ output: String?) {
        if to != nil {
            if from == .english {
                self = .romanToForeign(input)
            } else {
                self = .foreignToRoman(input)
            }
        } else {
            self = .foreign(id: input)
        }
    }
    
    // MARK: - Equatable conformance
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        if case .foreign(let lhsID) = lhs,
           case .foreign(let rhsID) = rhs {
            return lhsID == rhsID
        } else if case .romanToForeign(let lhsID) = lhs,
                  case .romanToForeign(let rhsID) = rhs {
            return lhsID == rhsID
        } else if case .foreignToRoman(let lhsID) = lhs,
                  case .foreignToRoman(let rhsID) = rhs {
            return lhsID == rhsID
        }
        return false
    }
    
    // MARK: - Identifiable conformance
    
    var id: String {
        switch self {
        case .foreign(let id):
            return "foreign\(id)"
        case .romanToForeign(let id):
            return "romanToForeign\(id)"
        case .foreignToRoman(let id):
            return "romanToForeign\(id)"
        }
    }
    
    // MARK: - EntryProtocol conformance
    
    var input: String {
        switch self {
        case .foreign(let id):
            return id.toHiragana()
        case .romanToForeign(let id):
            return id.removingDigits()
        case .foreignToRoman(let id):
            return id.toHiragana()
        }
    }
    
    var output: String {
        switch self {
        case .foreign(let id):
            return id.toHiragana()
        case .romanToForeign(let id):
            return id.toHiragana()
        case .foreignToRoman(let id):
            return id.removingDigits()
        }
    }
    
    var inputLanguage: Language {
        return .foreign
    }
    
    var outputLanguage: Language {
        return .foreign
    }
    
    var inputPossibilities: [ChallengeType] {
        switch self {
        case .foreign:
            return [.text(.foreign), .voice(.foreign)]
        case .romanToForeign:
            return [.text(.english)]
        case .foreignToRoman:
            return [.text(.foreign), .voice(.foreign)]
        }
    }
    
    var outputPossibilities: [ChallengeType] {
        switch self {
        case .foreign:
            return [.text(.foreign), .voice(.foreign)]
        case .romanToForeign:
            return [.text(.foreign), .voice(.foreign)]
        case .foreignToRoman:
            return [.text(.english)]
        }
    }
    
    var foreignID: String {
        switch self {
        case .foreign(let id):
            return id
        case .romanToForeign(let id):
            return id
        case .foreignToRoman(let id):
            return id
        }
    }
    
    func sameType(as other: Self) -> Bool {
        if case .foreign = self,
           case .foreign = other {
            return true
        } else if case .romanToForeign = self,
                  case .romanToForeign = other {
            return true
        } else if case .foreignToRoman = self,
                  case .foreignToRoman = other {
            return true
        }
        return false
    }
}
