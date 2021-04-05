//
// The LanguagePractice project.
// Created by optionaldev on 10/02/2021.
// Copyright © 2021 optionaldev. All rights reserved.
// 

#if JAPANESE
struct HiraganaRow {
    
    let a: ForeignCharacter?
    let i: ForeignCharacter?
    let u: ForeignCharacter?
    let e: ForeignCharacter?
    let o: ForeignCharacter?
    
    init(a: String?, i: String?, u: String?, e: String?, o: String?) {
        self.a = ForeignCharacter.init(a) ?? nil
        self.i = ForeignCharacter.init(i) ?? nil
        self.u = ForeignCharacter.init(u) ?? nil
        self.e = ForeignCharacter.init(e) ?? nil
        self.o = ForeignCharacter.init(o) ?? nil
    }
    
    var all: [ForeignCharacter] {
        return [a, i, u, e, o].compactMap { $0 }
    }
}
#endif
