//
//  Emojis.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 06/11/2015.
//  Copyright © 2015 Apple. All rights reserved.
//

import Foundation

var emojiScore = ["😍":1,"😎":1,"😏":1,"😊":1,"🔣":1,"🏸":1,"😔":1,"😆":1,"😵":1,"😴":1,"😳":1,"😲":1,"😱":1,"🔱":1,"💊":1,"🛃":1,"🔲":1,"😹":1,"😸":1,"🔳":1,"🔢":1,"🔴":1,"🗂":1,"🗃":1,"🗄":1,"📂":1,"®":1,"♉":1,"♈":1,"🔶":1,"✨":1,"🌘":1,"😁":1,"🌙":1,"♌":1,"♋":1,"♊":1,"♏":1,"♎":1,"♍":1,"🌔":1,"🌕":1,"🙂":1,"😷":1,"😾":1,"🗡":1,"😼":1,"😻":1,"😺":1,"😶":1,"🙈":1,"🙉":1,"🙊":1,"‼":1,"🙏":1,"🙁":1,"🇯":1,"🌌":1,"🌋":1,"🌊":1,"🚁":1,"⛪":1,"🌎":1,"🌍":1,"😐":1,"😰":1,"🔟":1,"🔝":1,"🔞":1,"🔛":1,"🔜":1,"🔚":1,"😮":1,"⏮":1,"🎖":1,"🎗":1,"🎐":1,"🎑":1,"🎒":1,"🎓":1,"👟":1,"👞":1,"👝":1,"👜":1,"🎙":1,"👚":1,"㊗":1,"3":1,"0":1,"⏯":1,"6":1,"7":1,"4":1,"5":1,"⏪":1,"8":1,"9":1,"㊙":1,"📨":1,"😒":1,"🍣":1,"🏓":1,"⏫":1,"🎞":1,"🎟":1];

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
        self.emojiScore = ["😍":1,"😎":1,"😏":1,"😊":1,"🔣":1,"🏸":1,"😔":1,"😆":1,"😵":1,"😴":1,"😳":1,"😲":1,"😱":1,"🔱":1,"💊":1,"🛃":1,"🔲":1,"😹":1,"😸":1,"🔳":1,"🔢":1,"🔴":1,"🗂":1,"🗃":1,"🗄":1,"📂":1,"®":1,"♉":1,"♈":1,"🔶":1,"✨":1,"🌘":1,"😁":1,"🌙":1,"♌":1,"♋":1,"♊":1,"♏":1,"♎":1,"♍":1,"🌔":1,"🌕":1,"🙂":1,"😷":1,"😾":1,"🗡":1,"😼":1,"😻":1,"😺":1,"😶":1,"🙈":1,"🙉":1,"🙊":1,"‼":1,"🙏":1,"🙁":1,"🇯":1,"🌌":1,"🌋":1,"🌊":1,"🚁":1,"⛪":1,"🌎":1,"🌍":1,"😐":1,"😰":1,"🔟":1,"🔝":1,"🔞":1,"🔛":1,"🔜":1,"🔚":1,"😮":1,"⏮":1,"🎖":1,"🎗":1,"🎐":1,"🎑":1,"🎒":1,"🎓":1,"👟":1,"👞":1,"👝":1,"👜":1,"🎙":1,"👚":1,"㊗":1,"3":1,"0":1,"⏯":1,"6":1,"7":1,"4":1,"5":1,"⏪":1,"8":1,"9":1,"㊙":1,"📨":1,"😒":1,"🍣":1,"🏓":1,"⏫":1,"🎞":1,"🎟":1];
        
        self.emojiTag = ["😍":["smiling","face","heart-shaped","hearts","eyes"],"😎":["smiling","face","sunglasses"],"😏":["smirking","face"],"😊":["smiling","face","smiling","eyes"],"😋":["face","savouring","delicious","food"],"😌":["relieved","face"],"🕥":["clock","face","ten-thirty"],"🃏":["playing","card","black","joker"],"🕧":["clock","face","twelve-thirty"],"🕦":["clock","face","eleven-thirty"],"🕡":["clock","face","six-thirty"],"🕠":["clock","face","five-thirty"],"🕣":["clock","face","eight-thirty"],"🕢":["clock","face","seven-thirty"],"🦄":["unicorn","face"],"🚩":["triangular","flag","on","post"],"🔘":["radio","button"],"🎿":["ski","ski","boot"],"🎾":["tennis","racquet","ball"],"🎽":["running","shirt","sash"],"🎼":["musical","score"],"🎻":["violin"],"🎺":["trumpet"],"🕤":["clock","face","nine-thirty"],"🌊":["water","wave"],"🔑":["key"],"🌌":["milky","way"],"🌋":["volcano"],"🌎":["earth","globe","americas"],"🌍":["earth","globe","europe-africa"],"🔖":["bookmark"],"🌏":["earth","globe","asia-australia"],"🌉":["bridge","at","night"],"🌈":["rainbow"],"🎵":["musical","note"],"🎴":["flower","playing","cards"],"🎳":["bowling"],"🎲":["game","die"],"🎱":["billiards"],"🎰":["slot","machine"],"🌁":["foggy"],"🌀":["cyclone"],"🌃":["night","stars"],"🌂":["closed","umbrella"],"🌅":["sunrise"],"🌄":["sunrise","over","mountains"],"🌇":["sunset","over","buildings"],"🌆":["cityscape","at","dusk"],"🚺":["womens"],"🏣":["japanese","post","office"],"🏉":["rugby","football"],"😄":["smiling","face","open","mouth","smiling","eyes"],"😅":["smiling","face","open","mouth","cold","sweat"],"😆":["smiling","face","open","mouth","tightly-closed","eyes"],"😇":["smiling","face","halo"],"😀":["grinning","face"],"😁":["grinning","face","smiling","eyes"],"😂":["face","tears","of","joy"]]
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
        let tagsArray = sentence.componentsSeparatedByString(" ");
        var result: [String: [Int]] = [String: [Int]](); //key=emoji, value=[Number of occurrences, score]
        for word in tagsArray {
            for (key, tagArray) in emojiTag {
                for tag in tagArray {
                    if tag.rangeOfString(word) != nil {
                        if (result[key] != nil) {
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
    
//    func getScoresFromMemory() -> [String: Int] {
//        //TODO: load scores from NSUSerDefaults
//        //let scores = NSUserDefaults.standardUserDefaults().objectForKey("scores") as! NSDictionary
//        let scores = self.emojiScore;
//        if (scores.isEmpty) {
//            //INIT WITH CONSTANT and store
//            let scores = ["😍":1,"😎":1,"😏":1,"😊":1,"🔣":1,"🏸":1,"😔":1,"😆":1,"😵":1,"😴":1,"😳":1,"😲":1,"😱":1,"🔱":1,"💊":1,"🛃":1,"🔲":1,"😹":1,"😸":1,"🔳":1,"🔢":1,"🔴":1,"🗂":1,"🗃":1,"🗄":1,"📂":1,"®":1,"♉":1,"♈":1,"🔶":1,"✨":1,"🌘":1,"😁":1,"🌙":1,"♌":1,"♋":1,"♊":1,"♏":1,"♎":1,"♍":1,"🌔":1,"🌕":1,"🙂":1,"😷":1,"😾":1,"🗡":1,"😼":1,"😻":1,"😺":1,"😶":1,"🙈":1,"🙉":1,"🙊":1,"‼":1,"🙏":1,"🙁":1,"🇯":1,"🌌":1,"🌋":1,"🌊":1,"🚁":1,"⛪":1,"🌎":1,"🌍":1,"😐":1,"😰":1,"🔟":1,"🔝":1,"🔞":1,"🔛":1,"🔜":1,"🔚":1,"😮":1,"⏮":1,"🎖":1,"🎗":1,"🎐":1,"🎑":1,"🎒":1,"🎓":1,"👟":1,"👞":1,"👝":1,"👜":1,"🎙":1,"👚":1,"㊗":1,"3":1,"0":1,"⏯":1,"6":1,"7":1,"4":1,"5":1,"⏪":1,"8":1,"9":1,"㊙":1,"📨":1,"😒":1,"🍣":1,"🏓":1,"⏫":1,"🎞":1,"🎟":1];
//            NSUserDefaults.standardUserDefaults().setObject(scores, forKey: "scores");
//        }
//        return scores;
//    }
    
    func incrementScore(emoji: String) -> Int {
        if self.emojiScore[emoji] != nil {
            self.emojiScore[emoji] = (self.emojiScore[emoji] as Int!) + 1;
            return (self.emojiScore[emoji] as Int!);
        }
        self.emojiScore[emoji] = 0;
        return 0
    }
    
}