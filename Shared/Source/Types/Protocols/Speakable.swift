//
// The LanguagePractice (iOS) project.
// Created by optionaldev on 03/02/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

/**
 Certain elements have the property of speakable,
 which means you can pass it to the Speech class
 and it will be handled
 */
protocol Speakable {
  
  var spoken: String { get }
}
