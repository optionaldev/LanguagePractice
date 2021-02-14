//
// The LanguagePractice (macOS) project.
// Created by optionaldev on 14/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
//

import Foundation

final class MacDefaults {
    
    func bool(forKey key: MacDefaultsKey) -> Bool {
        return defaults.bool(forKey: key.storeValue)
    }
    
    func set(_ bool: Bool, forKey key: MacDefaultsKey) {
        defaults.set(bool, forKey: key.storeValue)
    }
    
    // MARK: - Private
    
    private let defaults = UserDefaults()
}
