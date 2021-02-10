//
// The LanguagePractice project.
// Created by optionaldev on 10/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

#if JAPANESE
struct HiraganaRow {
    
    let a: JapaneseCharacter
    let i: JapaneseCharacter
    let u: JapaneseCharacter
    let e: JapaneseCharacter
    let o: JapaneseCharacter
    
    init(a: String, i: String, u: String, e: String, o: String) {
        self.a = .init(a)
        self.i = .init(i)
        self.u = .init(u)
        self.e = .init(e)
        self.o = .init(o)
    }
}
#endif
