//
// The LanguagePractice project.
// Created by optionaldev on 11/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

extension Array where Element: Equatable {
    
    mutating func removing(_ element: Element) {
        self = filter { $0 != element }
    }
}
