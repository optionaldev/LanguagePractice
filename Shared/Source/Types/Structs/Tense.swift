//
// The LanguagePractice project.
// Created by optionaldev on 26/01/2022.
// Copyright © 2022 optionaldev. All rights reserved.
//

/**
 All possible tenses that something can be conjugated in.
 
 The filtering for which type of word can be conjugated
 into which tense is decided at a later point in time.
 */
enum Tense: String, CaseIterable {
  
  case present
  case past
  case future
  case want
  case can
  case presentContinuous
}
