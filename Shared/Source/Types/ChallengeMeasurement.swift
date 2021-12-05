//
// The LanguagePractice (iOS) project.
// Created by optionaldev on 04/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import struct Foundation.Date
import struct Foundation.TimeInterval


final class ChallengeMeasurement {
  
  func start() {
    if startTime == nil {
      log("challenge measurement START >>>>>>>>")
      startTime = Date()
    }
  }
  
  func stopAndFetchResult() -> TimeInterval {
    if let time = startTime {
      let measurement = time.distance(to: Date())
      startTime = nil
      log("challenge measurement STOP ||||||| measurement = \(measurement)")
      return measurement
    }
    startTime = nil
    log("Should always called fetch after starting", type: .unexpected)
    return .zero
  }
  
  // MARK: - Private
  
  /**
   Defines the point at which the challenge measurement time starts. When a challenge
   starts is different based on the type of challenge the user is given.
   
   For challenges where information is instantly visible (e.g: text challenges, image
   challenges), the value is set as soon as all the challenge elements are visible
   (taking animation into consideration)
   
   For challenges where information is not instantly visible (e.g: voice challenges)
   the value is set after the sound is heard. For input, this means after the screen
   is presented and the sound has been heard. For output, this means after the
   correct answer has been heard for the first time.
   */
  private var startTime: Date? = nil
}
