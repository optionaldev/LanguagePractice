//
// The LanguagePractice project.
// Created by optionaldev on 13/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

struct EnglishNoun: EnglishWord {

    let id: String
    let clarification: String?
    let reference: String?

    var imageExists: Bool {
        return _imageExists == 1
    }

    private let _imageExists: UInt8?

    enum CodingKeys: String, CodingKey {
        case id
        case _imageExists  = "ie"
        case clarification = "cl"
        case reference     = "rf"
    }
}
