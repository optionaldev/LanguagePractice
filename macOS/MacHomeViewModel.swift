//
// The LanguagePractice (macOS) project.
// Created by optionaldev on 18/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import protocol SwiftUI.ObservableObject

import struct SwiftUI.Published

final class MacHomeViewModel: ObservableObject {
  
  @Published var currentQuiz: EntryType?
}
