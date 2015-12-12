//
//  emoji.swift
//  TastyImitationKeyboard
//
//  Created by clemkoa on 11/12/15.
//  Copyright © 2015 Apple. All rights reserved.
//

import Foundation

class EmojiCoding: NSObject, NSCoding {
    var emojiScore: [String: Int]
    var emojiTag: [String: [String]]
    
    init(emojiScore: [String: Int], emojiTag: [String: [String]]) {
        self.emojiTag = emojiTag
        self.emojiScore = emojiScore
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let emojiScore = decoder.decodeObjectForKey("emojiScore") as? [String: Int],
            let emojiTag = decoder.decodeObjectForKey("emojiTag") as? [String: [String]]
            else { return nil }
        
        self.init(
            emojiScore: emojiScore,
            emojiTag: emojiTag
        )
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.emojiScore, forKey: "emojiScore")
        coder.encodeObject(self.emojiTag, forKey: "emojiTag")
    }
    
    
//    print("in da viewdidload")
//    // Do any additional setup after loading the view, typically from a nib.
//    let emojiScore = ["😍":1,"😎":1,"😏":1,"😊":1,"🔣":1,"🏸":1]
//    let emojiTag = ["😍":["smiling","face","heart-shaped","hearts","eyes"],"😎":["smiling","face","sunglasses"],"😏":["smirking","face"]]
//    let emoji = EmojiCoding(emojiScore: emojiScore, emojiTag: emojiTag)
//    print(emoji)
//    let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
//    let path = documentsPath + "/test"
//    NSKeyedArchiver.archiveRootObject(emoji, toFile: path)
//    let emojiTest = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as? [EmojiCoding]
//    print(emojiTest)
}