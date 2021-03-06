//
//  Emojis.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 06/11/2015.
//  Copyright © 2015 Apple. All rights reserved.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class Emoji: NSObject, NSCoding {
    var emojiScore: [String: Int]
    var emojiTag: [String: [String]]
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("emojis")

    struct PropertyKey {
        static let emojiScoreKey = "emojiScore"
        static let emojiTagKey = "emojiTag"
    }

    override init() {
        self.emojiScore = ["😂": 3, "😍": 3, "😭": 3, "😊": 3, "❤": 3, "💕": 3, "✨": 2, "😘": 3, "👏": 3, "🔥": 2, "👍": 3, "👌": 3, "😎": 3, "😒": 2, "🙈": 3, "😏": 2]
        self.emojiTag = [String: [String]]()

        let path: String? = Bundle.main.path(forResource: "EmojiList", ofType: "plist")
        if path != nil {
            if let dictionary = NSDictionary(contentsOfFile: path!) {
                print("DICTIONARY from memory")
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

    func encode(with aCoder: NSCoder) {
        aCoder.encode(emojiScore, forKey: PropertyKey.emojiScoreKey)
        aCoder.encode(emojiTag, forKey: PropertyKey.emojiTagKey)
    }

    required convenience init?(coder aDecoder: NSCoder) {
        let emojiScore = aDecoder.decodeObject(forKey: PropertyKey.emojiScoreKey) as! [String: Int]
        let emojiTag = aDecoder.decodeObject(forKey: PropertyKey.emojiTagKey) as! [String: [String]]

        self.init(emojiScore: emojiScore, emojiTag: emojiTag)
    }

    func getMostUsedEmojis() -> [String] {
        var result: [String: Int] = [String: Int]()
        for (emoji, _) in self.emojiTag {
            if emojiScore[emoji] == nil {
                continue
            }
            if emojiScore[emoji] > 1 {
                if result[emoji] == nil {
                    result[emoji] = emojiScore[emoji]!
                }
            }
        }
        let sortedKeys = Array(result.keys).sorted( by: {
            return result[$0]! > result[$1]!
        })
        return sortedKeys
    }

    func tagSearch(_ sentence: String) -> [String] {
        if sentence.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty {
            return self.getMostUsedEmojis()
        }

        var emojiToMatchData: [String: [Float]] = [String: [Float]]() //IMPORTANT: key=emoji, value=[Number of occurrences of emoji, percentage of matches out of tags, Quality of match (percentage of characters)]

        let wordsArray = sentence.lowercased().components(separatedBy: " ")
        for keyword in wordsArray {
            if keyword.isEmpty {
                continue
            }
            for (emoji, tagsArray) in emojiTag {
                var matched = false
                for tag in tagsArray {
                    if tag.hasPrefix(keyword) {
                        // Added emojiToMatchData[emoji] condition to count minor matches if another tag has already matched: ex "heart gr" should give the green heart
                        // TODO:  improve this condition, especially in case the emoji has few tags
                        if keyword.characters.count < 3 && emojiToMatchData.keys.count > 20 && emojiScore[emoji] < 2 && emojiToMatchData[emoji] == nil && keyword.characters.count != tag.characters.count {
                            continue
                        }

                        if emojiToMatchData[emoji] == nil {
                            emojiToMatchData[emoji] = [0, 0, 0]
                        }

                        if !matched {
                            matched = true
                            //Nb of matches
                            emojiToMatchData[emoji]![0] += 1
                        }
                        //Percentage of matches
                        emojiToMatchData[emoji]![1] += 1.0/Float(tagsArray.count)
                        //Quality of match
                        emojiToMatchData[emoji]![2] = max(emojiToMatchData[emoji]![2], Float(keyword.characters.count)/Float(tag.characters.count))
                        //Necessary for sort function
                        if emojiScore[emoji] == nil {
                            emojiScore[emoji] = 0
                        }
                    }
                }
            }
        }

        let emojiArray = Array(emojiToMatchData.keys)
        let sortedKeys = emojiArray.sorted( by: {
            let obj1Matches: Int = Int(emojiToMatchData[$0]![0])
            let obj2Matches: Int = Int(emojiToMatchData[$1]![0])
            let obj1Score: Int = self.emojiScore[$0]! // emojiToMatchData[$0]![1] as Int
            let obj2Score: Int = self.emojiScore[$1]! // emojiToMatchData[$1]![1] as Int
            let obj1Percentage: Float = emojiToMatchData[$0]![1]
            let obj2Percentage: Float = emojiToMatchData[$1]![1]
            let obj1Quality: Float = emojiToMatchData[$0]![2]
            let obj2Quality: Float = emojiToMatchData[$1]![2]
            if obj1Matches == obj2Matches {
                // TODO: maybe switch the sort order of these two dimensions
                if obj1Score == obj2Score {
                    return obj1Percentage * obj1Quality > obj2Percentage * obj2Quality
                }
                return obj1Score > obj2Score
            }
            return obj1Matches > obj2Matches
        })
        return sortedKeys
    }

    func incrementScore(_ emoji: String) -> Int {
        print("incrementing " + emoji)
        if self.emojiScore[emoji] != nil {
            self.emojiScore[emoji] = (self.emojiScore[emoji] as Int!) + 1
            return (self.emojiScore[emoji] as Int!)
        }
        self.emojiScore[emoji] = 1
        return 1
    }
}
