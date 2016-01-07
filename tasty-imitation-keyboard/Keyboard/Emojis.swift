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
//                print("DICTIONARY from memory")
//                print(dictionary)
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
    
    func getMostUsedEmojis() -> [String] {
        var result: [String: Int] = [String: Int]()
        for (emoji, tagArray) in self.emojiTag {
            if emojiScore[emoji] == nil {
                continue
            }
            if emojiScore[emoji] > 1 {
                if result[emoji] == nil {
                    result[emoji] = emojiScore[emoji]!
                }
            }
        }
        let sortedKeys = Array(result.keys).sort( {
            return result[$0]! > result[$1]!
        })
        return sortedKeys
    }

    func tagSearch(sentence: String) -> [String] {
        var emojiToMatchData: [String: [Int]] = [String: [Int]]() //key=emoji, value=[Number of occurrences, score]

        if sentence.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).isEmpty {
            return self.getMostUsedEmojis()
        }

        let wordsArray = sentence.componentsSeparatedByString(" ");
        for keyword in wordsArray {
            if keyword.isEmpty {
                continue
            }
            for (emoji, tagsArray) in self.emojiTag {
                for tag in tagsArray {
                    if tag.hasPrefix(keyword) {
                        if emojiToMatchData[emoji] != nil {
                            emojiToMatchData[emoji]![0]++
                            // TODO: check to remove, emojiScore key must have been initialized in creattion of result key
                            if emojiScore[emoji] != nil {
                                emojiToMatchData[emoji]![1] += emojiScore[emoji]!
                            } else {
                                emojiScore[emoji] = 0
                            }
                        } else {
                            emojiToMatchData[emoji] = [Int]()
                            emojiToMatchData[emoji]!.append(1)
                            if emojiScore[emoji] != nil {
                                emojiToMatchData[emoji]!.append(emojiScore[emoji]!)
                            }
                            else {
                                emojiScore[emoji] = 0
                                emojiToMatchData[emoji]!.append(0)
                            }
                        }
                    }
                }
            }
        }

        let emojiArray = Array(emojiToMatchData.keys)
        let sortedKeys = emojiArray.sort( {
            let obj1Number = emojiToMatchData[$0]![0] as Int
            let obj2Number = emojiToMatchData[$1]![0] as Int
            let obj1Score = emojiToMatchData[$0]![1] as Int
            let obj2Score = emojiToMatchData[$1]![1] as Int
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