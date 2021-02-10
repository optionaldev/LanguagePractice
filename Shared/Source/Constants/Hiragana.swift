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
        .init(a: "あ", i: "い", u: "う", e: "え", o: "お"),
        .init(a: "か", i: "き", u: "く", e: "け", o: "こ"),
        .init(a: "さ", i: "し", u: "す", e: "せ", o: "そ"),
        .init(a: "た", i: "ち", u: "つ", e: "て", o: "と"),
        .init(a: "な", i: "に", u: "ぬ", e: "ね", o: "の"),
        .init(a: "は", i: "ひ", u: "ふ", e: "へ", o: "ほ"),
        .init(a: "ま", i: "み", u: "む", e: "め", o: "も"),
        .init(a: "ら", i: "り", u: "る", e: "れ", o: "ろ"),
        .init(a: "や", i: "　", u: "ゆ", e: "　", o: "よ"),
        .init(a: "わ", i: "　", u: "　", e: "　", o: "を"),
        .init(a: "ん", i: "　", u: "　", e: "　", o: "　"),
    ]
}
#endif
