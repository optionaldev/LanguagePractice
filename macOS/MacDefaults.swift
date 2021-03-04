//
// The LanguagePractice (macOS) project.
// Created by optionaldev on 14/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

import Foundation

extension Defaults {
    
    final class macOS {
        
        static func bool(forKey key: MacDefaultsKey) -> Bool {
            return defaults.bool(forKey: key)
        }
        
        static func set(_ bool: Bool, forKey key: MacDefaultsKey) {
            defaults.set(bool, forKey: key)
        }
        
        // MARK: - Private
        
        static private let defaults = UserDefaults()
    }
}
