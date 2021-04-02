//
// The LanguagePractice project.
// Created by optionaldev on 06/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import protocol SwiftUI.App
import protocol SwiftUI.Scene

import struct   SwiftUI.WindowGroup

@main
struct LanguagePracticeApp: App {

    init() {
        Logger.performInitialSetup()
//        _ = Speech.shared
        printStatus()
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
            if Defaults.wordsLearned.count < 40 {
                log("Words learned so far: \(Defaults.wordsLearned.sorted())")
                log("Words left to learn: \(lexicon.foreign.nouns.map { $0.id }.filter { !Defaults.wordsLearned.contains($0) }.sorted() )")
            }
        }
        #endif
    }
}
