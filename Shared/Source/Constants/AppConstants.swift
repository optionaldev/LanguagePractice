//
// The LanguagePractice project.
// Created by optionaldev on 10/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

import struct Foundation.TimeInterval


let iOS: Bool = {
  #if os(iOS)
  return true
  #else
  return false
  #endif
}()

struct AppConstants {
  
  /// Every challenge starts with these many characters / words
  ///
  /// This is not the same as challenge length.
  ///
  /// Challenge length depends on how many entries are generated for each foreign word.
  /// A foreign word that has only 1 translation can generate up to 3 entries:
  ///
  ///     English -> foreign
  ///     foreign -> English
  ///     foreign -> foreign (also known as simplified)
  ///
  /// A foreign word that has 4 translations can generate up to 9 entries
  static let challengeInitialSampleSize = 10
  
  /// Primarily used in order to differentiate between the guessing word and the answers
  static let defaultOpacity = 0.3
  
  /// If an answer has a time interval between these two values, it is a successful answer
  static let successRange = 0.0...10.0
  
  /// Default number of times the user has to complete the typing challenge to go to the next word
  static let forfeitRetriesCount = 3
}
