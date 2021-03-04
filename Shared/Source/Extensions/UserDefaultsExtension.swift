//
// The LanguagePractice project.
// Created by optionaldev on 03/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import class Foundation.JSONDecoder
import class Foundation.JSONEncoder
import class Foundation.UserDefaults

import struct Foundation.Data


extension UserDefaults {
    
    // MARK: Getters
    
    func bool(forKey key: Storable) -> Bool {
        return bool(forKey: key.storeValue)
    }
    
    func decodable<T: Decodable>(forKey key: DefaultsDecodableKey) -> T? {
        guard let data = data(forKey: key) else {
            return nil
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            log(error)
            return nil
        }
    }
    
    // MARK: Setters
    
    func set(_ bool: Bool, forKey key: Storable) {
        set(bool, forKey: key.storeValue)
    }
    
    func set<T: Encodable>(_ encodable: T, forKey key: Storable) {
        do {
            let data = try JSONEncoder().encode(encodable)
            set(data, forKey: key)
        } catch {
            log(error)
        }
    }
    
    // MARK: - Private
    
    // MARK: Getters
    
    private func data(forKey key: Storable) -> Data? {
        return data(forKey: key.storeValue)
    }
    
    // MARK: Setters
    
    private func set(_ data: Data, forKey key: Storable) {
        set(data, forKey: key.storeValue)
    }
}
