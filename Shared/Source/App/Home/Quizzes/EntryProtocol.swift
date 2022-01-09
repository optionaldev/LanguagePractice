//
// The LanguagePractice project.
// Created by optionaldev on 09/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

protocol Entryable {
  
  associatedtype Category: CategoryProtocol
  
  var id: String { get }
  var category: Category { get }
}

protocol CategoryProtocol: CaseIterable {
  
  var voiceValid: Bool { get }
}
