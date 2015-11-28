//
//  Emojis.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 06/11/2015.
//  Copyright © 2015 Apple. All rights reserved.
//

import Foundation


var emojiArray = ["😀", "😬", "😁", "😂", "😃", "😄", "😅", "😆", "😇", "😉", "😊", "🙂", "🙃", "☺️", "😋", "😌", "😍", "😘", "😗", "😙", "😚", "😜", "😝", "😛", "🤑", "🤓", "😎", "🤗", "😏", "😐😑", "😒", "🙄", "🤔", "😳", "😞", "😟", "😠", "😡", "😔", "😕", "🙁", "☹️", "😣", "😖", "😫", "😩", "😤", "😮", "😱", "😨", "😰", "😯", "😦", "😧", "😢", "😥", "😪", "😓", "😭", "😵", "😲", "🤐", "😷", "🤒", "🤕", "😴", "💤", "💩", "😈", "👿", "👹", "👺", "💀", "👻", "👽", "🤖", "😺", "😸", "😹", "😻", "😼", "😽", "🙀", "😿", "😾", "🙌", "👏", "👋", "👍", "👊", "✊", "✌️", "👌", "✋", "💪🙏", "☝️", "👆", "👇", "👈", "👉", "🖕", "🤘", "🖖", "✍", "💅", "👄", "👅", "👂", "👃", "👁", "👀", "👤", "🗣", "👶", "👦", "👧", "👨", "👩", "👱", "👴", "👵", "👲", "👳", "👮", "👷", "💂", "🕵", "🎅", "👼", "👸", "👰", "🚶", "🏃", "💃", "👯", "👫", "👬", "👭", "🙇", "💁", "🙅", "🙆", "🙋", "🙎", "🙍", "💇", "💆", "💑", "👩‍❤️‍👩", "👨‍❤️‍👨", "💏", "👩‍❤️‍💋‍👩", "👨‍❤️‍💋‍👨", "👪", "👨‍👩‍👧", "👨‍👩‍👧‍👦", "👨‍👩‍👦‍👦", "👨‍👩‍👧‍👧", "👩‍👩‍👦", "👩‍👩‍👧", "👩‍👩‍👧‍👦", "👩‍👩‍👦‍👦", "👩‍👩‍👧‍👧", "👨‍👨‍👦", "👨‍👨‍👧", "👨‍👨‍👧‍👦", "👨‍👨‍👦‍👦", "👨‍👨‍👧‍👧", "👚", "👕", "👖", "👔", "👗", "👙", "👘", "💄", "💋", "👣", "👠", "👡", "👢", "👞", "👟", "👒", "🎩", "⛑", "🎓", "👑", "🎒", "👝", "👛", "👜", "💼", "👓", "🕶", "💍", "🌂"]

class Emoji {
    var character: String
    
    var tags: [String]
    
    let emojiDict = ["😍":["smiling","face","heart-shaped","eyes"],"😎":["smiling","face","sunglasses"],"😏":["smirking","face"],"😊":["smiling","face","smiling","eyes"],"😋":["face","savouring","delicious","food"],"😌":["relieved","face"],"🕥":["clock","face","ten-thirty"],"🃏":["playing","card","black","joker"],"🕧":["clock","face","twelve-thirty"],"🕦":["clock","face","eleven-thirty"],"🕡":["clock","face","six-thirty"],"🕠":["clock","face","five-thirty"],"🕣":["clock","face","eight-thirty"],"🕢":["clock","face","seven-thirty"],"🦄":["unicorn","face"],"🚩":["triangular","flag","on","post"],"🔘":["radio","button"],"🎿":["ski","ski","boot"],"🎾":["tennis","racquet","ball"],"🎽":["running","shirt","sash"],"🎼":["musical","score"],"🎻":["violin"],"🎺":["trumpet"],"🕤":["clock","face","nine-thirty"],"🌊":["water","wave"],"🔑":["key"],"🌌":["milky","way"],"🌋":["volcano"],"🌎":["earth","globe","americas"],"🌍":["earth","globe","europe-africa"],"🔖":["bookmark"],"🌏":["earth","globe","asia-australia"],"🌉":["bridge","at","night"],"🌈":["rainbow"],"🎵":["musical","note"],"🎴":["flower","playing","cards"],"🎳":["bowling"],"🎲":["game","die"],"🎱":["billiards"],"🎰":["slot","machine"],"🌁":["foggy"],"🌀":["cyclone"],"🌃":["night","stars"],"🌂":["closed","umbrella"],"🌅":["sunrise"],"🌄":["sunrise","over","mountains"],"🌇":["sunset","over","buildings"],"🌆":["cityscape","at","dusk"],"🚺":["womens"],"🏣":["japanese","post","office"],"🏉":["rugby","football"],"😄":["smiling","face","open","mouth","smiling","eyes"],"😅":["smiling","face","open","mouth","cold","sweat"],"😆":["smiling","face","open","mouth","tightly-closed","eyes"],"😇":["smiling","face","halo"],"😀":["grinning","face"],"😁":["grinning","face","smiling","eyes"],"😂":["face","tears","of","joy"]]
    
    
    func tagSearch(word: NSString) -> NSMutableArray {
        var result: NSMutableArray = NSMutableArray();
        for (key, tagArray) in emojiDict {
            for tag in tagArray {
                if tag == word {
                    result.addObject(key);
                }
            }
        }
        return result;
    }
    

    
    init(emoji: String) {
        self.character = emoji
        self.tags = []
    }
    
}