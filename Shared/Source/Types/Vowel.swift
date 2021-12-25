//
// The LanguagePractice project.
// Created by optionaldev on 25/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

enum Vowel {
  
  case a
  case e
  case i
  case o
  case u
  
  #if JAPANESE
  var column: Int {
    switch self {
      case .a:
        return 0
      case .e:
        return 3
      case .i:
        return 1
      case .o:
        return 4
      case .u:
        return 2
    }
  }
  #endif
}
