//
// The LanguagePractice (macOS) project.
// Created by optionaldev on 07/11/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import class Foundation.NSAttributedString
import class Foundation.NSMutableAttributedString
import class UIKit.UIColor

import protocol SwiftUI.ObservableObject

import struct Foundation.NSRange
import struct SwiftUI.Published


struct LexiconDisplayedItem {
  
  var id: String
  var text: NSAttributedString
}

final class LexiconViewModel: ObservableObject {
  
  @Published var searchString = "" {
    didSet {
      updateDisplayedItems()
    }
  }
  
  @Published private(set) var displayedItems: [LexiconDisplayedItem]
  
  @Published var selection: Language = .english {
    didSet {
      switchLanguage()
    }
  }
  
  init() {
    let sortFunction = { (first: LexiconDisplayedItem, second: LexiconDisplayedItem) -> Bool in
      return first.id.lowercased() < second.id.lowercased()
    }
    
    initialEnglishItems = Lexicon.shared.english.nouns.map { LexiconDisplayedItem(id: $0.id, text: NSAttributedString(string: $0.id)) }.sorted(by: sortFunction)
    initialForeignItems = Lexicon.shared.foreign.nouns.map { LexiconDisplayedItem(id: $0.id, text: NSAttributedString(string: $0.id)) }.sorted(by: sortFunction)
    displayedItems = initialEnglishItems
  }
  
  // MARK: - Private
  
  private let initialEnglishItems: [LexiconDisplayedItem]
  private let initialForeignItems: [LexiconDisplayedItem]
  
  private func updateDisplayedItems() {
    if searchString.isEmpty {
      displayedItems = currentLanguageItems
    } else {
      let lowercasedSearchString = searchString.lowercased()
      displayedItems = currentLanguageItems.filter { $0.id.lowercased().contains(lowercasedSearchString) }
      
      for (index, item) in displayedItems.enumerated() {
        displayedItems[index] = highlightUpdated(item: item)
      }
    }
  }
  
  private var currentLanguageItems: [LexiconDisplayedItem] {
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
  
  private func highlightUpdated(item: LexiconDisplayedItem) -> LexiconDisplayedItem {
    log("Highliting \(item.id)")
    let rawText = item.id.removingUniqueness()
    let displayedText = NSMutableAttributedString(string: rawText)
    var currentIndex = rawText.startIndex
    
    while currentIndex < rawText.endIndex,
          let range = rawText.range(of: searchString, range: currentIndex..<rawText.endIndex),
          !range.isEmpty
    {
      log("Highlited some text range: \(range.lowerBound) - \(range.upperBound)")
      displayedText.setAttributes([NSAttributedString.Key.backgroundColor: UIColor.yellow.cgColor], range: NSRange(range, in: rawText))
      currentIndex = range.upperBound
    }
    
    return LexiconDisplayedItem(id: item.id, text: displayedText)
  }
}
