//
// The LanguagePractice project.
// Created by optionaldev on 16/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import class Foundation.DispatchQueue
import class Foundation.JSONDecoder
import class Foundation.URLSession

import protocol Swift.Decodable

import struct Combine.AnyPublisher
import struct Foundation.Data
import struct Foundation.URL
import struct Foundation.URLError


final class Network {

    static func fetchJson<T: Decodable>(from url: URL) -> AnyPublisher<T, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func fetchImageData(from url: URL) -> AnyPublisher<Data, URLError> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .eraseToAnyPublisher()
    }
}
