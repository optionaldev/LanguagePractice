//
// The LanguagePractice project.
// Created by optionaldev on 28/03/2022.
// Copyright © 2022 optionaldev. All rights reserved.
// 

enum QuizResult: Equatable {
  
  case learnedNothing
  case learnedSomething(_ items: [LearnedItem])
}
