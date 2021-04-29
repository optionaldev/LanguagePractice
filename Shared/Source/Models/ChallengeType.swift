//
// The LanguagePractice project.
// Created by optionaldev on 09/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

private struct Constants {
    
    // Technically, image isn't always available, but we can only check that on a per challenge basis
    static let alwaysAvailableChallengeTypes : [ChallengeType] = [.simplified,
                                                                  .image,
                                                                  .text(.english),
                                                                  .text(.foreign)]
}

enum ChallengeType: Hashable, Codable {
    
    case text(Language)
    case voice(Language)
    case image
    
    #if JAPANESE
    case simplified
    #endif
    
    // TODO: Add another case to this enum where user writes the translation of one of the words' characters
    
    var storeValue: Int {
        switch self {
        case .image:
            return 0
        case .simplified:
            return 1
        case .text(let practice):
            switch practice {
            case .english:
                return 2
            case .foreign:
                return 3
            }
        case .voice(let practice):
            switch practice {
            case .english:
                return 4
            case .foreign:
                return 5
            }
        }
    }
    
    static var availableChallenges: [ChallengeType] {
        var result = Constants.alwaysAvailableChallengeTypes
        if Defaults.voiceEnabled {
            if Language.english.voices.count != 0 {
                result.append(.voice(.english))
            }
            if Language.foreign.voices.count != 0 {
                result.append(.voice(.foreign))
            }
        }
        return result
    }
    
    // MARK: - Codable conformance
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        let int = try container.decode(Int.self)
        for cas in ChallengeType.availableChallenges {
            if cas.storeValue == int {
                self = cas
                return
            }
        }
        self = .image
    }
    
    func encode(to encoder: Encoder) throws {
        var encoder = encoder.singleValueContainer()
        try encoder.encode(storeValue)
    }
}
