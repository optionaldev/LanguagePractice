//
// The LanguagePractice project.
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
            SideMenuView()
                .frame(minWidth: 200, idealWidth: 300, maxWidth: 400, minHeight: 200, idealHeight: 300, maxHeight: 400, alignment: .bottom)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            #endif
        }
    }
    
    // MARK: - Private
    
    private let persistenceController = PersistenceController.shared
}
