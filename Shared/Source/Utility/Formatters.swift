//
// The LanguagePractice project.
// Created by optionaldev on 04/05/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import class Foundation.NumberFormatter
import class Foundation.NSNumber

import struct Foundation.TimeInterval

final class Formatters {
  
  private static let numberFormatter = NumberFormatter()
  
  static func string(forInterval interval: TimeInterval, maxDigits: Int = 1) -> String {
    numberFormatter.maximumFractionDigits = maxDigits
    return numberFormatter.string(from: NSNumber(value: interval)) ?? "0.0"
  }
}
