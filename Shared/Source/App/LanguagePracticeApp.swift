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
    printStatus()
    
    Defaults.performInitialSetup()
//    UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
//    UserDefaults.standard.synchronize()
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
  private func printStatus() {
    #if DEBUG
    
    let knownItems = Defaults.knownIds(for: .picking)
    if knownItems.count < 40 {
      log("Items learned so far: \(knownItems.sorted())")
      log("Items left to learn: \(Lexicon.shared.foreign.nouns.map { $0.id }.filter { !knownItems.contains($0) }.sorted() )")
    }
    
    #endif
  }
}
