//
// The LanguagePractice project.
// Created by optionaldev on 16/04/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

import struct Foundation.UUID

struct FontViewModel: Distinguishable {
  
  let id = UUID().uuidString
  let name: String
}
