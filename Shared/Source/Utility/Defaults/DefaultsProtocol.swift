//
// The LanguagePractice project.
// Created by optionaldev on 05/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import class  Foundation.JSONDecoder
import class  Foundation.JSONEncoder
import class  Foundation.UserDefaults
import struct Foundation.Data

protocol DefaultsProtocol {
    
    static func resetValue(forKey key: Storable)
}

extension DefaultsProtocol {
    
    static func resetValue(forKey key: Storable) {
        defaults.set(nil, forKey: key.storeValue)
    }
    
    static fileprivate var defaults: UserDefaults {
        return UserDefaults.standard
    }
}

// MARK: - Bool

protocol DefaultsBoolProtocol: DefaultsProtocol {
    
    associatedtype BoolKeyType: BoolStorable
    
    static func bool(forKey key: BoolKeyType) -> Bool
    static func set(_ bool: Bool, forKey key: BoolKeyType)
}

extension DefaultsBoolProtocol {
    
    static func bool(forKey key: BoolKeyType) -> Bool {
        return defaults.bool(forKey: key.storeValue)
    }
    
    static func set(_ bool: Bool, forKey key: BoolKeyType) {
        defaults.set(bool, forKey: key.storeValue)
    }
}

// MARK: - Coding

protocol DefaultsCodingProtocol: DefaultsProtocol {

    associatedtype DecodeKeyType: CodingStorable

    static func decodable<T: Decodable>(forKey key: DecodeKeyType) -> T?
    static func set<T: Encodable>(_ decodable: T, forKey key: DecodeKeyType)
}

extension DefaultsCodingProtocol {
    
    static func decodable<T: Decodable>(forKey key: DecodeKeyType) -> T?  {
        guard let data = UserDefaults.standard.data(forKey: key.storeValue) else {
            return nil
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            log(error)
            return nil
        }
    }
    
    static func set<T: Encodable>(_ encodable: T, forKey key: DecodeKeyType) {
        do {
            let data = try JSONEncoder().encode(encodable)
            defaults.set(data, forKey: key.storeValue)
        } catch {
            log(error)
        }
    }
}
