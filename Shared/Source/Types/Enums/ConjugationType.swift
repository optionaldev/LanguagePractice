//
// The LanguagePractice project.
// Created by optionaldev on 31/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

/**
 For English, there's only really one type of conjugation,
 but for Japanese, there's several, depending on where the
 conjugation will be used inside a sentence
 
 */
enum ConjugationType: CaseIterable {
  
  /**
   Modifier is used when the conjugation will come in front
   of another word.
   */
  case modifier
  
  /**
   Formal version (desu / masu)
   
   Formal ending is used when the conjugation will either end
   the sentence. It's possible that we have a longer sentence,
   with sentence connecting words. That simply means there's
   multiple ended sentences connected together.
   English is unaffected.
   */
  case formalEnding
  
  /**
   Informal version (da )
   
    It's possible that we have a longer sentence,
   with sentence connecting words. That simply means there's
   multiple ended sentences connected together.
   Formal version (desu / masu)
   English is unaffected.
   */
  case informalEnding
}
