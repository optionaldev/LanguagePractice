//
// The LanguagePractice project.
// Created by optionaldev on 02/03/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import class Combine.AnyCancellable
import class Foundation.Bundle
import class Foundation.JSONDecoder

import protocol Foundation.ObservableObject

import struct Foundation.Data
import struct Foundation.Published
import struct Foundation.URL


final class HomeViewModel: ObservableObject {
  
  func requestAnyMissingItems() {
//    if lexiconExists {
//      startDownloadingImages()
//      checkForDuplicateEntries()
//    } else {
      if let englishPath = path(forLanguage: .english) {
        do {
          var data = try Data(contentsOf: URL(fileURLWithPath: englishPath), options: .mappedIfSafe)
          let englishLexicon = try JSONDecoder().decode(EnglishLexicon.self, from: data)
          
          if let foreignPath = path(forLanguage: .foreign) {
            data = try Data(contentsOf: URL(fileURLWithPath: foreignPath), options: .mappedIfSafe)
            let foreignLexicon = try JSONDecoder().decode(ForeignLexicon.self, from: data)
            
            Defaults.set(englishLexicon, forKey: .englishLexicon)
            Defaults.set(foreignLexicon, forKey: .foreignLexicon)
          } 
        } catch {
          log(error)
        }
      } else {
        LexiconsRequest().start {
          self.checkForDuplicateEntries()
          self.lexiconExists = true
          self.startDownloadingImages()
        }
      }
//    }
  }
  
  // TODO: Quizzes such as the word pick quiz should initially be disabled
  // Once we get the lexicon, the button becomes enabled
  @Published var lexiconExists = Defaults.lexicon != nil
  
  // MARK: - Private
  
  private var imagesToDownload: [String] = []
  private var imageCancellable: AnyCancellable?
  
  private func path(forLanguage language: Language) -> String? {
    return Bundle.main.path(forResource: language.rawValue, ofType: "json")
  }
  
  private func startDownloadingImages() {
    log("start downloading images", type: .info)
    
    if let url = Persistence.imageFolderUrl {
      log("Download location: \"\(url.path)\"", type: .info)
    }
    
    imagesToDownload = Lexicon.shared.english.nouns
      .filter { $0.imageExists }
      .filter { Persistence.imagePath(id: $0.id) == nil }
      .map { $0.id }
    
    checkForImagesToDownload()
  }
  
  // TODO: Investigate how we can improve how fast the user gets to see images
  // 1.0) Add some images with the app launch, enough for the first few challenges
  // 1.1) User might never have internet, so 1.0 might still not be enough
  // 2.0) Download based on how the current challenge words have been shuffled
  // 3.0) Prepare shuffle first and then start image download
  private func checkForImagesToDownload() {
    if let imageID = imagesToDownload.last {
      downloadImage(id: imageID)
    } else {
      log("Finished downloading all images", type: .info)
    }
  }
  
  private func downloadImage(id: String) {
    guard let url = UrlBuilder.imageUrl(forID: id) else {
      log("Unable to get URL for id = \"\(id)\"", type: .unexpected)
      return
    }
    
    imageCancellable = Network.fetchImageData(from: url).sink(receiveCompletion: { error in
      log(error)
    }, receiveValue: { (data: Data) in
      Persistence.write(word: id, imageData: data)
      self.imagesToDownload.removeLast()
      self.checkForImagesToDownload()
    })
  }
  
  private func checkForDuplicateEntries() {
    checkForDuplicateEntries(Lexicon.shared.english.nouns)
    checkForDuplicateEntries(Lexicon.shared.foreign.nouns)
  }
  
  private func checkForDuplicateEntries(_ items: [Item]) {
    #if DEBUG
    var dictionary: [String: Int] = [:]
    
    for item in items {
      if dictionary[item.id] == nil {
        dictionary[item.id] = 1
      } else {
        log("Found duplicate for \(item.id)", type: .unexpected)
      }
    }
    #endif
  }
}
