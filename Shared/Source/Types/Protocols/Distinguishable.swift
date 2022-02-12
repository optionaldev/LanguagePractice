//
// The LanguagePractice (iOS) project.
// Created by optionaldev on 03/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

/**
 A replacement for the Identifiable protocol, you run
 into the associated type problem if you try to
 create properties that simply conform to Identifiable
 + we're only ever interested in id being a String
 */
protocol Distinguishable {
  
  var id: String { get }
}
