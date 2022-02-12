//
// The LanguagePractice project.
// Created by optionaldev on 06/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import protocol SwiftUI.App
import protocol SwiftUI.Scene

import struct   SwiftUI.WindowGroup

import class Foundation.Bundle
import class Foundation.UserDefaults


@main
struct LanguagePracticeApp: App {
  
  init() {
    Logger.performInitialSetup()
    _ = Speech.shared
    HomeViewModel().requestAnyMissingItems()
    
    printProgress()
    
    Defaults.performInitialSetup()
    
  }
  
  var body: some Scene {
    WindowGroup {
      #if os(iOS)
      PhoneTabView()
      #else
      SideMenuView()
      #endif
    }
  }
  
  // MARK: - Private
  
  private func printProgress() {
    #if DEBUG
    
    guard Lexicon.shared != nil else {
      return
    }
    
    let knownItems = Defaults.knownIds(for: .picking).sorted()
    if knownItems.count > 40 {
      log("\(knownItems.count) items learned so far.")
    } else {
      log("Items learned so far: \(knownItems)")
    }
    
    let itemsLeft = Lexicon.shared.foreign.nouns.map { $0.id }.filter { !knownItems.contains($0) }.sorted()
    if itemsLeft.count > 40 {
      log("\(itemsLeft.count) items left to learn.")
    } else {
      log("Items left to learn: \(itemsLeft)")
    }
    
    #endif
  }
  
  private func removeLexiconFromUserDefaults() {
    #if DEBUG
    
    // If Lexicon is available via user defaults, currently
    // it will never be fetched again
    // Uncomment to test if network layer is working
    //    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    //    UserDefaults.standard.synchronize()
    
    #endif
  }
}
