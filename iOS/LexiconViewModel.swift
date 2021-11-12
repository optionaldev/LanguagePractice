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
  
  @Published var selection: Language = .english {
    didSet {
      switchLanguage()
    }
  }
  
  init() {
    let funct = { (first: Item, second: Item) -> Bool in
      return first.id.lowercased() < second.id.lowercased()
    }
    
    initialEnglishItems = Lexicon.shared.english.nouns.sorted(by: funct)
    initialForeignItems = Lexicon.shared.foreign.nouns.sorted(by: funct)
    displayedItems = initialEnglishItems
  }
  
  // MARK: - Private
  
  private let initialEnglishItems: [Item]
  private let initialForeignItems: [Item]
  
  private func updateDisplayedItems() {
    displayedItems = currentLanguageItems.filter { $0.id.contains(searchString) }
  }
  
  private var currentLanguageItems: [Item] {
    switch selection {
      case .english:
        return initialEnglishItems
      case .foreign:
        return initialForeignItems
    }
  }
  
  private func switchLanguage() {
    displayedItems = currentLanguageItems
  }
}
