//
// The LanguagePractice project.
// Created by optionaldev on 08/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

enum Tab: Int, CaseIterable, Identifiable {
    
    case home
    case dictionary
    case settings
    
    func icon(selected: Bool) -> String {
        var iconName = unselectedIconName
        if selected {
            iconName += ".fill"
        }
        return iconName
    }
    
    var id: String {
        return "\(rawValue)"
    }
    
    var name: String {
        switch self {
        case .home:
            return "Home"
        case .dictionary:
            return "Dictionary"
        case .settings:
            return "Settings"
        }
    }
    
    // MARK: - Private
    
    private var unselectedIconName: String {
        // Icon names taken from Apple's app 'SF Symbols'
        switch self {
        case .home:
            return "house"
        case .dictionary:
            return "a.book.closed"
        case .settings:
            return "wrench.and.screwdriver"
        }
    }
}
