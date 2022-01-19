//
// The LanguagePractice project.
// Created by optionaldev on 13/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

protocol Item: Codable, Distinguishable {
  
  /// Unique identifier across all items from one lexicon.
  var id: String { get }
  
  /// The actual letters, extracted from the ID by removing the part that makes it unique.
  var roman: String { get }
  
  /// The spelling of the word, not the phonetical way, but the way it's provided to the speech feature.
  var spoken: String { get }
  
  /// The most common way for this item to be written.
  var written: String { get }
}

extension Item {
  
  var roman: String {
    return id.removingUniqueness()
  }
  
  var spoken: String {
    return roman
  }
  
  var written: String {
    return roman
  }
}
