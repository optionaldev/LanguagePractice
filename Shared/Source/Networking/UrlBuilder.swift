//
// The LanguagePractice project.
// Created by optionaldev on 17/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import struct Foundation.URL
import struct Foundation.URLComponents

extension Language {
    
    var url: URL? {
        return UrlBuilder.jsonUrl(forName: rawValue)
    }
}

final class UrlBuilder {
    
    static func imageUrl(forID imageID: String) -> URL? {
        var components = baseGithubUrlComponents
        
        components.path.append("images/" + imageID + ".jpg")
        
        return components.url
    }
    
    // MARK: - Private
    
    private static let baseGithubUrlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "raw.githubusercontent.com"
        components.path = "/optionaldev/LanguagePracticeTestData/main/"
        
        return components
    }()
    
    fileprivate static func jsonUrl(forName name: String) -> URL? {
        var components = baseGithubUrlComponents
        
        components.path.append("jsons/" + name + ".json")
        
        return components.url
    }
}
