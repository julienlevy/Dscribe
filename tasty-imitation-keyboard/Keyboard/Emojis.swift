//
//  Emojis.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 06/11/2015.
//  Copyright © 2015 Apple. All rights reserved.
//

import Foundation

class Emoji: NSObject, NSCoding {
    var emojiScore: [String: Int]
    var emojiTag: [String: [String]]
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("emojis")
    
    struct PropertyKey {
        static let emojiScoreKey = "emojiScore"
        static let emojiTagKey = "emojiTag"
    }
    
    override init() {
        self.emojiScore = ["😂": 3, "😍": 3, "😭": 3, "😊": 3, "❤": 3, "💕": 3, "✨": 2, "😘": 3, "👏": 3, "🔥": 2, "👍": 3, "👌": 3, "😎": 3, "😒": 2, "🙈": 3, "😏": 2]
        self.emojiTag = [String: [String]]()

        let path: String? = NSBundle.mainBundle().pathForResource("EmojiList", ofType: "plist")
        if path != nil {
            if let dictionary: NSDictionary? = NSDictionary(contentsOfFile: path!) {
                print("DICTIONARY from memory")
                print(dictionary)
                self.emojiTag = dictionary as! [String: [String]]
            }
        }

        super.init()
    }
    
    init?(emojiScore: [String: Int], emojiTag: [String: [String]]) {
        self.emojiScore = emojiScore
        self.emojiTag = emojiTag
        
        super.init()
        if emojiScore.isEmpty || emojiTag.isEmpty {
            return nil
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(emojiScore, forKey: PropertyKey.emojiScoreKey)
        aCoder.encodeObject(emojiTag, forKey: PropertyKey.emojiTagKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let emojiScore = aDecoder.decodeObjectForKey(PropertyKey.emojiScoreKey) as! [String: Int]
        let emojiTag = aDecoder.decodeObjectForKey(PropertyKey.emojiTagKey) as! [String: [String]]
        
        self.init(emojiScore: emojiScore, emojiTag: emojiTag)
    }
    

    func tagSearch(sentence: String) -> [String] {
        var result: [String: [Int]] = [String: [Int]](); //key=emoji, value=[Number of occurrences, score]

        if sentence.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty {
            for (emoji, tagArray) in self.emojiTag {
                if emojiScore[emoji] == nil {
                    continue
                }
                if emojiScore[emoji] > 1 {
                    if result[emoji] == nil {
                        result[emoji] = [Int]()
                        result[emoji]!.append(1)
                        result[emoji]!.append(emojiScore[emoji]!)
                    }
                }
            }
        }
        else {
            let tagsArray = sentence.componentsSeparatedByString(" ");
            for word in tagsArray {
                if word.isEmpty {
                    continue
                }
                for (key, tagArray) in emojiTag {
                    for tag in tagArray {
                        if tag.hasPrefix(word) {
                            if result[key] != nil {
                                if result[key]?.count > 1 {
                                    result[key]![0]++
                                    if emojiScore[key] != nil {
                                        result[key]![1] = result[key]![1] + emojiScore[key]!
                                    }
                                }
                            } else {
                                result[key] = [Int]()
                                result[key]!.append(1)
                                if emojiScore[key] != nil {
                                    result[key]!.append(emojiScore[key]!)
                                }
                                else {
                                    result[key]!.append(0)
                                }
                            }
                        }
                    }
                }
            }
        }

        let myArr = Array(result.keys)
        let sortedKeys = myArr.sort( {
            let obj1Number = result[$0]![0] as Int
            let obj2Number = result[$1]![0] as Int
            let obj1Score = result[$0]![1] as Int
            let obj2Score = result[$1]![1] as Int
            if obj1Number == obj2Number {
                return obj1Score > obj2Score
            }
            return obj1Number > obj2Number
        })
        return sortedKeys
    }

    func incrementScore(emoji: String) -> Int {
        print("incrementing " + emoji)
        print(self.emojiScore[emoji])
        if self.emojiScore[emoji] != nil {
            self.emojiScore[emoji] = (self.emojiScore[emoji] as Int!) + 1;
            return (self.emojiScore[emoji] as Int!);
        }
        self.emojiScore[emoji] = 1;
        return 1
    }
    
}