//
// The LanguagePractice (macOS) project.
// Created by optionaldev on 07/11/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import protocol SwiftUI.ObservableObject

import struct SwiftUI.Published

final class LexiconViewModel: ObservableObject {
  
  @Published var searchString = ""
}
