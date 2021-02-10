//
// The LanguagePractice project.
// Created by optionaldev on 09/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

enum ChallengeType: Hashable, Codable {
    
    case text(Language)
    case voice(Language)
    case image
    
    #if JAPANESE
    case simplified
    #endif
    
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
    
    static var allCases: [ChallengeType] {
        return [.image,
                .simplified,
                .text(.english),
                .text(.foreign),
                .voice(.english),
                .voice(.foreign)]
    }
    
    // MARK: - Codable conformance
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        let int = try container.decode(Int.self)
        for cas in ChallengeType.allCases {
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
