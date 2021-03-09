//
// The LanguagePractice project.
// Created by optionaldev on 09/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

import struct Foundation.TimeInterval

enum PickChallengeState: Hashable, Codable {
    
    case regular
    case guessedIncorrectly
    case finished(_ time: TimeInterval)
    
    var storeValue: TimeInterval {
        switch self {
        case .regular:
            return -1
        case .guessedIncorrectly:
            return -2
        case .finished(let interval):
            return interval
        }
    }
    
    // MARK: - Codable conformance
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        let value = try container.decode(TimeInterval.self)
        
        if value == -2 {
            self = .guessedIncorrectly
        } else if value == -1 {
            self = .regular
        } else {
            self = .finished(value)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var encoder = encoder.singleValueContainer()
        try encoder.encode(storeValue)
    }
}
