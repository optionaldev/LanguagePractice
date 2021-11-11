//
// The LanguagePractice (macOS) project.
// Created by optionaldev on 07/11/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import protocol SwiftUI.ObservableObject

import struct SwiftUI.Published

final class LexiconViewModel: ObservableObject {
  
  @Published var searchString = "" {
    didSet {
      updateDisplayedItems()
    }
  }
  
  @Published private(set) var displayedItems: [Item]
  
  init() {
    initialItems = Lexicon.shared.english.nouns.sorted(by: { (first, second) -> Bool in
      return first.id.lowercased() < second.id.lowercased()
    })
    displayedItems = initialItems
  }
  
  // MARK: - Private
  
  private let initialItems: [Item]
  
  private func updateDisplayedItems() {
    displayedItems = initialItems.filter { $0.id.contains(searchString) }
  }
}
