//
// The LanguagePractice project.
// Created by optionaldev on 04/05/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import Foundation
import SwiftUI

private struct Constants {
    
    static let divisor = 10000.0
}

final class Random {
    
    /// Random double in specified range.
    ///
    /// Only works for positive numbers.
    ///
    /// Returns a double >= to the lowerBound and < than the upperBound.
    static func double(inRange range: Range<Double>) -> Double {
        let upperBound = UInt32((range.upperBound - range.lowerBound) * Constants.divisor)
        let division = Double(arc4random_uniform(upperBound)) / Constants.divisor
        return division + range.lowerBound
    }
}
