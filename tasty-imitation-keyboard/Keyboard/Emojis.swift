//
//  Emojis.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 06/11/2015.
//  Copyright © 2015 Apple. All rights reserved.
//

import Foundation


var emojiScore = ["🔣":1,"🏸":1,"😔":1,"😆":2,"😵":1,"😴":1,"😳":1,"😲":1,"😱":1,"🔱":1,"💊":1,"🛃":1,"🔲":1,"😹":1,"😸":1,"🔳":1,"🔢":1,"🔴":1,"🗂":1,"🗃":1,"🗄":1,"📂":1,"®":1,"♉":1,"♈":1,"🔶":1,"✨":1,"🌘":1,"😁":1,"🌙":1,"♌":1,"♋":1,"♊":1,"♏":1,"♎":1,"♍":1,"🌔":1,"🌕":1,"🙂":1,"😷":1,"😾":1,"🗡":1,"😼":1,"😻":1,"😺":1,"😶":1,"🙈":1,"🙉":1,"🙊":1,"‼":1,"🙏":1,"🙁":1,"🇯":1,"🌌":1,"🌋":1,"🌊":1,"🚁":1,"⛪":1,"🌎":1,"🌍":1,"😐":1,"😰":1,"🔟":1,"🔝":1,"🔞":1,"🔛":1,"🔜":1,"🔚":1,"😮":1,"⏮":1,"🎖":1,"🎗":1,"🎐":1,"🎑":1,"🎒":1,"🎓":1,"👟":1,"👞":1,"👝":1,"👜":1,"🎙":1,"👚":1,"㊗":1,"3":1,"0":1,"⏯":1,"6":1,"7":1,"4":1,"5":1,"⏪":1,"8":1,"9":1,"㊙":1,"📨":1,"😒":1,"🍣":1,"🏓":1,"⏫":1,"🎞":1,"🎟":1];


class Emoji {
    var emojiScore = ["😍":1,"😎":1,"😏":1,"😊":1,"🔣":1,"🏸":1,"😔":1,"😆":1,"😵":1,"😴":1,"😳":1,"😲":1,"😱":1,"🔱":1,"💊":1,"🛃":1,"🔲":1,"😹":1,"😸":1,"🔳":1,"🔢":1,"🔴":1,"🗂":1,"🗃":1,"🗄":1,"📂":1,"®":1,"♉":1,"♈":1,"🔶":1,"✨":1,"🌘":1,"😁":1,"🌙":1,"♌":1,"♋":1,"♊":1,"♏":1,"♎":1,"♍":1,"🌔":1,"🌕":1,"🙂":1,"😷":1,"😾":1,"🗡":1,"😼":1,"😻":1,"😺":1,"😶":1,"🙈":1,"🙉":1,"🙊":1,"‼":1,"🙏":1,"🙁":1,"🇯":1,"🌌":1,"🌋":1,"🌊":1,"🚁":1,"⛪":1,"🌎":1,"🌍":1,"😐":1,"😰":1,"🔟":1,"🔝":1,"🔞":1,"🔛":1,"🔜":1,"🔚":1,"😮":1,"⏮":1,"🎖":1,"🎗":1,"🎐":1,"🎑":1,"🎒":1,"🎓":1,"👟":1,"👞":1,"👝":1,"👜":1,"🎙":1,"👚":1,"㊗":1,"3":1,"0":1,"⏯":1,"6":1,"7":1,"4":1,"5":1,"⏪":1,"8":1,"9":1,"㊙":1,"📨":1,"😒":1,"🍣":1,"🏓":1,"⏫":1,"🎞":1,"🎟":1];
    
    var emojiDict = ["😍":["smiling","face","heart-shaped","hearts","eyes"],"😎":["smiling","face","sunglasses"],"😏":["smirking","face"],"😊":["smiling","face","smiling","eyes"],"😋":["face","savouring","delicious","food"],"😌":["relieved","face"],"🕥":["clock","face","ten-thirty"],"🃏":["playing","card","black","joker"],"🕧":["clock","face","twelve-thirty"],"🕦":["clock","face","eleven-thirty"],"🕡":["clock","face","six-thirty"],"🕠":["clock","face","five-thirty"],"🕣":["clock","face","eight-thirty"],"🕢":["clock","face","seven-thirty"],"🦄":["unicorn","face"],"🚩":["triangular","flag","on","post"],"🔘":["radio","button"],"🎿":["ski","ski","boot"],"🎾":["tennis","racquet","ball"],"🎽":["running","shirt","sash"],"🎼":["musical","score"],"🎻":["violin"],"🎺":["trumpet"],"🕤":["clock","face","nine-thirty"],"🌊":["water","wave"],"🔑":["key"],"🌌":["milky","way"],"🌋":["volcano"],"🌎":["earth","globe","americas"],"🌍":["earth","globe","europe-africa"],"🔖":["bookmark"],"🌏":["earth","globe","asia-australia"],"🌉":["bridge","at","night"],"🌈":["rainbow"],"🎵":["musical","note"],"🎴":["flower","playing","cards"],"🎳":["bowling"],"🎲":["game","die"],"🎱":["billiards"],"🎰":["slot","machine"],"🌁":["foggy"],"🌀":["cyclone"],"🌃":["night","stars"],"🌂":["closed","umbrella"],"🌅":["sunrise"],"🌄":["sunrise","over","mountains"],"🌇":["sunset","over","buildings"],"🌆":["cityscape","at","dusk"],"🚺":["womens"],"🏣":["japanese","post","office"],"🏉":["rugby","football"],"😄":["smiling","face","open","mouth","smiling","eyes"],"😅":["smiling","face","open","mouth","cold","sweat"],"😆":["smiling","face","open","mouth","tightly-closed","eyes"],"😇":["smiling","face","halo"],"😀":["grinning","face"],"😁":["grinning","face","smiling","eyes"],"😂":["face","tears","of","joy"]]
    
    func tagSearch(sentence: String) -> [String] {
        let tagsArray = sentence.componentsSeparatedByString(" ");
        var result: [String: Int] = [String: Int]();
        for word in tagsArray {
            for (key, tagArray) in emojiDict {
                for tag in tagArray {
                    //TODO only match the beginning of words, not a substring in the middle ?
                    if tag.rangeOfString(word) != nil {
                        result[key] = emojiScore[key];
                    }
                }
            }
        }
        let myArr = Array(result.keys)
        let sortedKeys = myArr.sort( {
            let obj1 = emojiScore[$0]
            let obj2 = emojiScore[$1]
            return obj1 > obj2
        })
        return sortedKeys
    }
    
    func getScoresFromMemory() -> [String: Int] {
        //TODO: load scores from NSUSerDefaults
        //let scores = NSUserDefaults.standardUserDefaults().objectForKey("scores") as! NSDictionary
        let scores = self.emojiScore;
        if (scores.isEmpty) {
            //INIT WITH CONSTANT and store
            let scores = ["😍":1,"😎":1,"😏":1,"😊":1,"🔣":1,"🏸":1,"😔":1,"😆":1,"😵":1,"😴":1,"😳":1,"😲":1,"😱":1,"🔱":1,"💊":1,"🛃":1,"🔲":1,"😹":1,"😸":1,"🔳":1,"🔢":1,"🔴":1,"🗂":1,"🗃":1,"🗄":1,"📂":1,"®":1,"♉":1,"♈":1,"🔶":1,"✨":1,"🌘":1,"😁":1,"🌙":1,"♌":1,"♋":1,"♊":1,"♏":1,"♎":1,"♍":1,"🌔":1,"🌕":1,"🙂":1,"😷":1,"😾":1,"🗡":1,"😼":1,"😻":1,"😺":1,"😶":1,"🙈":1,"🙉":1,"🙊":1,"‼":1,"🙏":1,"🙁":1,"🇯":1,"🌌":1,"🌋":1,"🌊":1,"🚁":1,"⛪":1,"🌎":1,"🌍":1,"😐":1,"😰":1,"🔟":1,"🔝":1,"🔞":1,"🔛":1,"🔜":1,"🔚":1,"😮":1,"⏮":1,"🎖":1,"🎗":1,"🎐":1,"🎑":1,"🎒":1,"🎓":1,"👟":1,"👞":1,"👝":1,"👜":1,"🎙":1,"👚":1,"㊗":1,"3":1,"0":1,"⏯":1,"6":1,"7":1,"4":1,"5":1,"⏪":1,"8":1,"9":1,"㊙":1,"📨":1,"😒":1,"🍣":1,"🏓":1,"⏫":1,"🎞":1,"🎟":1];
            NSUserDefaults.standardUserDefaults().setObject(scores, forKey: "scores");
        }
        return scores;
    }
    
    func incrementScore(emoji: String) -> Int {
        if self.emojiScore[emoji] != nil {
            self.emojiScore[emoji] = (self.emojiScore[emoji] as Int!) + 1;
            return (self.emojiScore[emoji] as Int!);
        }
        self.emojiScore[emoji] = 0;
        return 0
    }
    
}