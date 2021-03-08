//
// The LanguagePractice project.
// Created by optionaldev on 08/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import typealias Swift.Codable

protocol ChallengeProtocol: Codable {
    
    var inputType: ChallengeType { get }
    var input: String { get }
}
