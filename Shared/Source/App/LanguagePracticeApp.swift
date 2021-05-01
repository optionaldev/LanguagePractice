//
// The LanguagePractice project.
// Created by optionaldev on 06/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import protocol SwiftUI.App
import protocol SwiftUI.Scene

import struct   SwiftUI.WindowGroup

import Foundation

@main
struct LanguagePracticeApp: App {

    init() {
        Logger.performInitialSetup()
//        _ = Speech.shared
        printStatus()
        
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
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
        
        if let lexicon = Defaults.lexicon {
            let knownWords = Defaults.knownWords
            if knownWords.count < 40 {
                log("Words learned so far: \(knownWords.sorted())")
                log("Words left to learn: \(lexicon.foreign.nouns.map { $0.id }.filter { !knownWords.contains($0) }.sorted() )")
            }
        }
        #endif
    }
}
