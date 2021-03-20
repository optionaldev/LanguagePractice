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
                // It seems like, unless the window is slightly larger than the area occupied by
                // the scroll view, when scrolling to the last item, it doesn't scroll the whole
                // way on MacOS. Might affect the idea of a resizable window in the future
                .frame(width: Defaults.macOS.bool(forKey: .sideMenuShowLabels) ? 850 : 750,
                       height: 310)
            #endif
        }
    }
}
