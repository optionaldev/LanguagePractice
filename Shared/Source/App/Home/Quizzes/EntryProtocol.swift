//
// The LanguagePractice project.
// Created by optionaldev on 09/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

protocol Entryable: Distinguishable {

  associatedtype Category: CategoryProtocol

  var id: String { get }
  var category: Category { get }
}

protocol CategoryProtocol {

  var voiceValid: Bool { get }

  static var all: [Self] { get }
}
