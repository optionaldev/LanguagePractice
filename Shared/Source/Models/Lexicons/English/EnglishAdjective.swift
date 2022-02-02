//
// The LanguagePractice project.
// Created by optionaldev on 02/02/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 


struct EnglishAdjective: EnglishWord {
  
  let id: String
  let clarification: String?
  let reference: String?
  
  var imageExists: Bool {
    return _imageExists == 1
  }
  
  enum CodingKeys: String, CodingKey {
    case id
    case _imageExists  = "ie"
    case clarification = "cl"
    case reference     = "rf"
  }
  
  // MARK: - Private
  
  private let _imageExists: UInt8?
}
