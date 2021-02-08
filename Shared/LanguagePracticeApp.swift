//
// The  project.
// Created by optionaldev on 06/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import SwiftUI

@main
struct LanguagePracticeApp: App {

    var body: some Scene {
        WindowGroup {
            #if os(iOS)
            PhoneTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            #else
            Text("MacOS TBD")
                .frame(width: 300, height: 200)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            #endif
        }
    }
    
    // MARK: - Private
    
    private let persistenceController = PersistenceController.shared
}
