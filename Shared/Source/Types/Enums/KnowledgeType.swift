//
// The LanguagePractice project.
// Created by optionaldev on 01/12/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

/**
 Mainly used for categorizing storage in user defaults,
 because even if the date might look the same, it
 could mean different things.
 
 If someone is a very fast picker, but a very slow
 typer, it could mean that he needs to work more on
 typing challenges, it could mean motor impairment,
 inexperience with keyboard.
 */
enum KnowledgeType {
  
  case picking
  case typing
  case speaking
}
