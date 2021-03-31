//
// The LanguagePractice project.
// Created by optionaldev on 29/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import struct Foundation.TimeInterval


// Dummy protocol so that we can create methods for storing / retrieve
// values that are valid in UserDefaults context without archiving
protocol Saveable {}

extension String: Saveable {}
extension TimeInterval: Saveable {}
extension Array where Element: Saveable {}
extension Array: Saveable where Element: Saveable {}
