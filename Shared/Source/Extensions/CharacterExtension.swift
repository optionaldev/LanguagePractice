//
// The LanguagePractice project.
// Created by optionaldev on 12/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

extension Character {
    
    var isHiragana: Bool {
        return [/* a */ "あ", "い", "う", "え", "お",
                /* k */ "か", "き", "く", "け", "こ",
                /* g */ "が", "ぎ", "ぐ", "げ", "ご",
                /* s */ "さ", "し", "す", "せ", "そ",
                /* z */ "ざ", "じ", "ず", "ぜ", "ぞ",
                /* t */ "た", "ち", "つ", "て", "と",
                /* d */ "だ", "ぢ", "づ", "で", "ど",
                /* n */ "な", "に", "ぬ", "ね", "の",
                /* h */ "は", "ひ", "ふ", "へ", "ほ",
                /* b */ "ば", "び", "ぶ", "べ", "ぼ",
                /* p */ "ぱ", "ぴ", "ぷ", "ぺ", "ぽ",
                /* m */ "ま", "み", "む", "め", "も",
                /* r */ "ら", "り", "る", "れ", "ろ",
                /* y */ "や", "ゆ", "よ",
                /* w */ "わ", "を",
                        "ん",
                
                        // Extended hiragana specific characters (smaller versions of や　ゆ　よ)
                        "ゃ", "ゅ", "ょ",
                
                        // Double consonant marker (small tsu)
                        "っ"]
            .contains(self)
    }
}
