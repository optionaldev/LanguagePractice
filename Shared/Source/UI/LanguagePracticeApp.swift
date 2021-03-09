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
    }
    
    var body: some Scene {
        WindowGroup {
            #if os(iOS)
            PhoneTabView()
            #else
            SideMenuView()
                .frame(minWidth: 200, idealWidth: 300, maxWidth: 400, minHeight: 200, idealHeight: 300, maxHeight: 400, alignment: .bottom)
            #endif
        }
    }
}
