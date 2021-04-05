//
// The LanguagePractice project.
// Created by optionaldev on 10/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

#if JAPANESE
struct Hiragana {
    
    // Define list of character that look the same, such as さ and ち for repetition practice
//    let similarLookingCharacters:
    
    static let rows: [HiraganaRow] = [
        .init(a:  "a", i:  "i",  u:   "u", e:  "e", o:  "o"),
        .init(a: "ka", i: "ki",  u:  "ku", e: "ke", o: "ko"),
        .init(a: "sa", i: "shi", u:  "su", e: "se", o: "so"),
        .init(a: "ta", i: "chi", u: "tsu", e: "te", o: "to"),
        .init(a: "na", i: "ni",  u:  "nu", e: "ne", o: "no"),
        .init(a: "ha", i: "hi",  u:  "fu", e: "he", o: "ho"),
        .init(a: "ma", i: "mi",  u:  "mu", e: "me", o: "mo"),
        .init(a: "ra", i: "ri",  u:  "ru", e: "re", o: "ro"),
        .init(a: "ya", i:  nil,  u:  "yu", e:  nil, o: "yo"),
        .init(a: "wa", i:  nil,  u:   nil, e:  nil, o: "wo"),
        .init(a: "n",  i:  nil,  u:   nil, e:  nil, o:  nil),
    ]
    
    static var all: [ForeignCharacter] {
        return rows.flatMap { $0.all }
    }
}
#endif
