//
// The LanguagePractice (macOS) project.
// Created by optionaldev on 07/11/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import class Foundation.NSAttributedString
import class Foundation.NSMutableAttributedString

#if os(iOS)
import class UIKit.UIColor
#else
import class AppKit.NSColor
#endif

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
  
  init(lexicon: Lexicon = .shared) {
    // Sort items in alphabetic order and bypass ASCII ardering a-z before A-Z
    let sortFunction = { (first: LexiconDisplayedItem, second: LexiconDisplayedItem) -> Bool in
      return first.id.lowercased() < second.id.lowercased()
    }
    
    let processItems = { (items: [Item]) -> [LexiconDisplayedItem] in
      return items.map { LexiconDisplayedItem(id: $0.id, text: NSAttributedString(string: $0.id)) }.sorted(by: sortFunction)
    }
    
    initialEnglishItems = processItems(lexicon.english.nouns)
    initialForeignItems = processItems(lexicon.foreign.nouns)
    displayedItems = initialEnglishItems
  }
  
  func realItem(for item: LexiconDisplayedItem) -> Item {
    switch selection {
      case .english:
        return Lexicon.shared.englishDictionary[item.id]!
      case .foreign:
        return Lexicon.shared.foreignDictionary[item.id]!
    }
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
      
      // displayedItems now contains only items that have something to highlight
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
  
  // Highlights all matches within a string
  // If users searches "a", there will be 3 different sections highlighted in the word *banana*
  private func highlightUpdated(item: LexiconDisplayedItem) -> LexiconDisplayedItem {
    let rawText = item.id.removingUniqueness()
    let displayedText = NSMutableAttributedString(string: rawText)
    var currentIndex = rawText.startIndex
    
    while currentIndex < rawText.endIndex,
          let range = rawText.range(of: searchString, range: currentIndex..<rawText.endIndex),
          !range.isEmpty
    {
      displayedText.setAttributes(attributes, range: NSRange(range, in: rawText))
      currentIndex = range.upperBound
    }
    
    return LexiconDisplayedItem(id: item.id, text: displayedText)
  }
  
  private var attributes: [NSAttributedString.Key: Any] = {
    #if os(iOS)
    return [.backgroundColor: UIColor.yellow.cgColor]
    #else
    return [.backgroundColor: NSColor.yellow.cgColor]
    #endif
  }()
}
