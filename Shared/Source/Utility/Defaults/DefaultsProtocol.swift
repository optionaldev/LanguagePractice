//
// The LanguagePractice project.
// Created by optionaldev on 05/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import class  Foundation.JSONDecoder
import class  Foundation.JSONEncoder
import class  Foundation.UserDefaults

import struct Foundation.Data
import struct Foundation.TimeInterval


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
    
    associatedtype BoolKeyType: Storable
    
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

    associatedtype DecodeKeyType: Storable

    static func decodable<T: Decodable>(forKey key: DecodeKeyType) -> T?
    static func set<T: Encodable>(_ decodable: T, forKey key: DecodeKeyType)
}

extension DefaultsCodingProtocol {
    
    // The main issue with this approach is that you need to always specify what the return type is
    // Is there a better way to do this?
    static func decodable<T: Decodable>(forKey key: DecodeKeyType) -> T?  {
        guard let data = defaults.data(forKey: key.storeValue) else {
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

// MARK: - Arrays

protocol DefaultsArrayProtocol: DefaultsProtocol {

    associatedtype ArrayKeyType: Storable

    static func array<T: Saveable>(forKey key: ArrayKeyType) -> [T]
    static func set<T: Saveable>(_ array: [T], forKey key: ArrayKeyType)
}


extension DefaultsArrayProtocol {
    
    static func array<T: Saveable>(forKey key: ArrayKeyType) -> [T] {
        guard let rawResult = defaults.array(forKey: key.storeValue) else {
            return []
        }
        guard let result = rawResult as? [T] else {
            return []
        }
        return result
    }
    
    static func set<T: Saveable>(_ array: [T], forKey key: ArrayKeyType) {
        defaults.set(array, forKey: key.storeValue)
    }
}

// MARK: - Dictionaries

protocol DefaultsDictionaryProtocol: DefaultsProtocol {

    associatedtype DictionaryKeyType: Storable

    static func dictionary<U: Saveable, V: Saveable>(forKey key: DictionaryKeyType) -> [U: V]
    static func set<U: Saveable, V: Saveable>(_ dictionary: [U: V], forKey key: DictionaryKeyType)
}

extension DefaultsDictionaryProtocol {
    
    static func dictionary<U: Saveable, V: Saveable>(forKey key: DictionaryKeyType) -> [U:V] {
        guard let rawResult = defaults.dictionary(forKey: key.storeValue) else {
            return [:]
        }
        guard let result = rawResult as? [U:V] else {
            return [:]
        }
        return result
    }
    
    static func set<U: Saveable, V: Saveable>(_ array: [U: V], forKey key: DictionaryKeyType) {
        defaults.set(array, forKey: key.storeValue)
    }
}

// MARK: - Strings

protocol DefaultsStringProtocol: DefaultsProtocol {

    associatedtype StringKeyType: Storable

    static func string(forKey key: StringKeyType) -> String?
    static func set(_ string: String?, forKey key: StringKeyType)
}

extension DefaultsStringProtocol {
    
    static func string(forKey key: StringKeyType) -> String? {
        guard let string = defaults.string(forKey: key.storeValue) else {
            return nil
        }
        return string
    }
    
    static func set(_ string: String?, forKey key: StringKeyType) {
        defaults.set(string, forKey: key.storeValue)
    }
}
