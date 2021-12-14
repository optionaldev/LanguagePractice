//
// The LanguagePractice project.
// Created by optionaldev on 14/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

enum HiraganaEntry {
  
  /**
   This case covers: な (text)  -> na (text)
                     な (voice) -> na (text)
                     な (voice) -> な (text)
   */
  case input(_ id: String)
  
  
  /**
   This case covers: na (text) -> な (text)
                     na (text) -> な (voice)
                     な (text) -> な (voice)
   */
  case output(_ id: String)
}
