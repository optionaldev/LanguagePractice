//
// The LanguagePractice project.
// Created by optionaldev on 06/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import Foundation
#if DEBUG && os(iOS)
import UIKit
#endif

private struct Constants {
    static let imageFolder     = "imageFolder"
    static let imageExtension  = "jpg"
}

final class Persistence {
    
    // Useful for checking image existence
    static func imagePath(id: String) -> String? {
        return imageUrl(forWord: id)?.path
    }
    
    static func imageData(forID id: String) -> Data? {
        guard let imageFolderUrl = imageFolderUrl else {
            return nil
        }
        
        guard FileManager.default.fileExists(atPath: imageFolderUrl.path) else {
            return nil
        }
        
        let imagePermanentUrl = imageFolderUrl.appendingPathComponent(id).appendingPathExtension(Constants.imageExtension)
        
        if FileManager.default.fileExists(atPath: imagePermanentUrl.path) {
            return imageData(forPath: imagePermanentUrl.path)
        }
        return nil
    }
    
    static func write(word: String, imageData: Data) {
        guard let imageFolderUrl = imageFolderUrl else {
            return
        }
        
        if !FileManager.default.fileExists(atPath: imageFolderUrl.absoluteString) {
            do {
                try FileManager.default.createDirectory(at: imageFolderUrl, withIntermediateDirectories: true, attributes: nil)
            } catch {
                log(error)
                return
            }
        }
        
        let imagePermanentUrl = imageFolderUrl.appendingPathComponent(word).appendingPathExtension(Constants.imageExtension)
        
        do {
            if FileManager.default.fileExists(atPath: imagePermanentUrl.path) {
                try FileManager.default.removeItem(at: imagePermanentUrl)
                log("deleted image = \(word)", type: .info)
            }
            #if os(iOS)
            if UIImage(data: imageData) != nil {
                log("copy image = \(word)", type: .info)
                try imageData.write(to: imagePermanentUrl)
            } else {
                log("Corrupted image with ID: \"\(word)\"", type: .unexpected)
            }
            #else
            try imageData.write(to: imagePermanentUrl)
            #endif
        } catch {
            log(error)
        }
    }
    
    // MARK: - Private
    
    private static func imageData(forPath path: String) -> Data? {
        #if DEBUG && os(iOS)
        if let imageData = FileManager.default.contents(atPath: path) {
            if UIImage(data: imageData) != nil {
                return imageData
            } else {
                log("image corrupt \(path)")
            }
        }
        return nil
        #else
        return FileManager.default.contents(atPath: path)
        #endif
    }
    
    static let imageFolderUrl: URL? = {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        
        return url?.appendingPathComponent(Constants.imageFolder)
    }()
    
    private static func imageUrl(forWord word: String) -> URL? {
        if let imageFolderUrl = imageFolderUrl {
            let imagePermanentUrl = imageFolderUrl.appendingPathComponent(word).appendingPathExtension(Constants.imageExtension)
            
            if FileManager.default.fileExists(atPath: imagePermanentUrl.path) {
                return imagePermanentUrl
            }
        }
        return nil
    }
}
