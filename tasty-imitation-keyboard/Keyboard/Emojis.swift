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
        self.emojiScore = ["👦":1,"👧":1,"👤":1,"👥":1,"👢":1,"👣":1,"👠":1,"👡":1,"🚥":1,"🚤":1,"🚧":1,"🚦":1,"🚡":1,"⃣":1,"👨":1,"👩":1,"🎐":1,"🎑":1,"💙":1,"💘":1,"🎒":1,"❓":1,"💓":1,"💒":1,"💑":1,"🎓":1,"💗":1,"💖":1,"💕":2,"💔":1,"♉":1,"♈":1,"✨":2,"🌄":1,"🔩":1,"🚠":1,"👯":1,"🌂":1,"👭":1,"👮":1,"👫":1,"👬":1,"🌅":1,"👪":1,"🚮":1,"🚭":1,"🌉":1,"🚯":1,"🚪":1,"🎁":1,"🛁":1,"🚫":1,"💡":1,"🎀":1,"🏰":1,"🔨":1,"♌":1,"♋":1,"♊":1,"♏":1,"♎":1,"♍":1,"📐":1,"🌵":1,"💜":1,"💛":1,"💚":1,"🛀":1,"💟":1,"💞":1,"💝":1,"🔖":1,"📓":1,"🌞":1,"📡":1,"📔":1,"📕":1,"↩":1,"💉":1,"㊗":1,"🏪":1,"◀":1,"㊙":1,"💈":1,"🚄":1,"🃏":1,"🚅":1,"🚂":1,"✒":1,"🔅":1,"🔄":1,"🔇":1,"🔆":1,"🔁":1,"🔀":1,"🔃":1,"🔂":1,"🆎":1,"🔈":1,"🚕":1,"🚔":1,"🚗":1,"🚖":1,"🚑":1,"🚐":1,"🚓":1,"🚒":1,"🐺":1,"🍏":1,"🍎":1,"🍍":1,"🍌":1,"🍋":1,"🍊":1,"🌆":1,"Ⓜ":1,"♓":1,"🌲":1,"📧":1,"😈":1,"😉":1,"😆":1,"😇":1,"😄":1,"😅":1,"😂":2,"😃":1,"😀":1,"😁":1,"🚞":1,"🚝":1,"🚟":1,"🚚":1,"⛪":1,"🍉":1,"🍈":1,"🍇":1,"🍆":1,"🍅":1,"🐲":1,"🐵":1,"🐴":1,"🐷":1,"🐶":1,"♻":1,"🔍":1,"🔏":1,"♿":1,"🔌":1,"🔋":1,"📘":1,"📙":1,"☎":1,"😏":2,"📑":1,"😍":2,"😎":2,"😋":1,"😌":1,"📖":1,"😊":2,"🍯":1,"🈳":1,"🈲":1,"🌸":1,"🌹":1,"🈷":1,"🈶":1,"🈵":1,"🈴":1,"🍶":1,"🌳":1,"🈹":1,"🈸":1,"🌷":1,"⬛":1,"⬜":1,"🍪":1,"🌱":1,"🎨":1,"🎩":1,"🅱":1,"🎤":1,"🎥":1,"🎦":1,"🎧":1,"🎠":1,"🎡":1,"🎢":1,"🎣":1,"🌴":1,"🕞":1,"🈺":1,"📦":1,"💎":1,"🌻":1,"🌼":1,"🌺":1,"🌿":1,"🌽":1,"📹":1,"🎿":1,"🍬":1,"💊":1,"🌃":1,"📪":1,"🐡":1,"💌":1,"🌁":1,"🌀":1,"🎭":1,"🎮":1,"🎯":1,"🍫":1,"🎪":1,"🎫":1,"🎬":1,"⚠":1,"⚡":1,"🔭":1,"🔬":1,"‼":1,"🔫":1,"👾":1,"🚺":1,"🚻":1,"🚼":1,"👺":1,"🚾":1,"👼":1,"❎":1,"🌈":1,"⤵":1,"⤴":1,"☺":1,"🐢":1,"😣":1,"↙":1,"🐣":1,"🍒":1,"🚰":1,"👴":1,"👷":1,"🚳":1,"👱":1,"👰":1,"👳":1,"🚷":1,"🚸":1,"🚹":1,"👹":1,"👸":1,"🌘":1,"🐧":1,"⚪":1,"⚫":1,"🐤":1,"🐥":1,"✴":1,"✳":1,"📒":1,"🐦":1,"➡":1,"🐑":1,"🚴":1,"🍷":1,"🍴":1,"🍵":1,"🍲":1,"🍳":1,"🍰":1,"🍱":1,"🏠":1,"🏡":1,"🏢":1,"🏣":1,"🏤":1,"🏥":1,"🍸":1,"🏧":1,"🐔":1,"🚵":1,"💣":1,"💢":1,"🎉":1,"💠":1,"💧":1,"💦":1,"💥":1,"💤":1,"🎃":1,"🎂":1,"💩":1,"💨":1,"🎇":1,"🎆":1,"🎅":1,"🎄":1,"🐘":1,"🍻":1,"🍼":1,"🍺":1,"🀄":1,"🏫":1,"🏬":1,"🏭":1,"🏮":1,"🏯":1,"🈂":1,"🈁":1,"💬":1,"💫":1,"💪":1,"💯":1,"💮":1,"💭":1,"🎌":1,"🎋":1,"🎊":1,"🎏":1,"🎎":1,"🎍":1,"🍮":1,"🍭":1,"❄":1,"🛅":1,"🕠":1,"🛃":1,"🛂":1,"🕥":1,"😞":1,"😝":1,"😟":1,"😚":1,"😜":1,"😛":1,"⭐":1,"⭕":1,"🌐":1,"♠":1,"♣":1,"⚓":1,"♥":1,"♦":1,"♨":1,"🐐":1,"⛔":1,"🎺":1,"🎼":1,"🎻":1,"🎾":1,"🐠":1,"🎽":1,"😙":1,"😘":2,"😕":1,"😔":1,"😗":1,"😖":1,"😑":1,"😐":1,"😓":1,"😒":2,"🐈":1,"🐉":1,"🐄":1,"🐅":1,"🐆":1,"🐇":1,"🐀":1,"🐁":1,"🐂":1,"🐃":1,"➕":1,"➗":1,"➖":1,"🐾":1,"📩":1,"📨":1,"💻":1,"💼":1,"📥":1,"📤":1,"💿":1,"📢":1,"💽":1,"💾":1,"🔸":1,"🔹":1,"🐽":1,"✈":1,"✉":1,"🔰":1,"🔱":1,"🔲":1,"🔳":1,"🔴":1,"🔵":1,"🔶":1,"🔷":1,"⏬":1,"⏫":1,"™":1,"🔦":1,"🐍":1,"🐎":1,"🐏":1,"🐊":1,"🐋":1,"🐌":1,"🔤":1,"✏":1,"🔺":1,"🔻":1,"🔼":1,"✋":1,"✌":1,"✊":1,"💸":1,"💹":1,"💲":1,"💳":1,"💰":1,"💱":1,"💶":1,"💷":1,"💴":1,"💵":1,"⬇":1,"⬆":1,"⬅":1,"↗":1,"💐":1,"🐬":1,"🐙":1,"🐪":1,"🐯":1,"🍞":1,"🌝":1,"🐭":1,"🎵":1,"🍀":1,"👽":1,"👿":1,"🎰":1,"🚽":1,"🎳":1,"🌙":1,"🕣":1,"🕢":1,"🕡":1,"🛄":1,"❕":1,"❔":1,"❗":1,"🕤":1,"👜":1,"👻":1,"🎴":1,"📗":1,"🎷":1,"➿":1,"🎶":1,"🕧":1,"🌗":1,"📻":1,"📼":1,"📺":1,"👊":1,"👋":1,"👌":2,"👍":2,"👎":1,"👏":2,"🕦":1,"🍥":1,"🍤":1,"🍧":1,"🍦":1,"❌":1,"🍠":1,"🍣":1,"🍢":1,"🚜":1,"🍩":1,"🍨":1,"👈":1,"👉":1,"↕":1,"📵":1,"📲":1,"📳":1,"📰":1,"📱":1,"👀":1,"🍡":1,"👂":1,"👃":1,"👄":1,"👅":1,"👆":1,"👇":1,"🎲":1,"📝":1,"🚨":1,"🏈":1,"🏉":1,"🏂":1,"🏃":1,"🚿":1,"🏁":1,"🏆":1,"🏇":1,"🏄":1,"🕕":1,"🈚":1,"▫":1,"▪":1,"🏊":1,"👵":1,"♐":1,"♑":1,"♒":1,"🚱":1,"⛄":1,"⛅":1,"🚲":1,"🐜":1,"🐛":1,"🐚":1,"👶":1,"🐟":1,"🐞":1,"🐝":1,"🕛":1,"🕜":1,"🕚":1,"🕟":1,"🕝":1,"❇":1,"💍":1,"📶":1,"💏":1,"🚶":1,"💋":1,"↖":1,"🔯":1,"🔮":1,"👲":1,"⏩":1,"📴":1,"🔪":1,"😠":1,"😡":1,"😢":1,"↔":1,"😤":1,"😥":1,"😦":1,"😧":1,"😨":1,"😩":1,"🏨":1,"🐓":1,"🐒":1,"🕘":1,"🕙":1,"🐗":1,"🐖":1,"🐕":1,"🗻":1,"🕒":1,"🕓":1,"🕐":1,"🕑":1,"🕖":1,"🕗":1,"🕔":1,"↘":1,"⛎":1,"🗿":1,"😪":1,"😫":1,"😬":1,"😭":2,"😮":1,"😯":1,"💄":1,"💅":1,"💆":1,"💇":1,"💀":1,"💁":1,"💂":1,"💃":1,"🔧":1,"✔":1,"🔥":2,"✖":1,"🔣":1,"🔢":1,"🔡":1,"🔠":1,"💺":1,"🌌":1,"📣":1,"⏪":1,"🉑":1,"🉐":1,"🌾":1,"🌔":1,"🌕":1,"🌖":1,"📠":1,"ℹ":1,"🌑":1,"🌒":1,"🌓":1,"🌋":1,"🚣":1,"📉":1,"📈":1,"📁":1,"📀":1,"📃":1,"📂":1,"📅":1,"📄":1,"📇":1,"📆":1,"🌊":1,"🚢":1,"🔉":1,"🌟":1,"🌚":1,"🌛":1,"🌜":1,"✅":1,"☀":1,"📊":1,"✂":1,"📌":1,"📋":1,"📎":1,"📍":1,"📏":1,"▶":1,"⛺":1,"🚍":1,"🚎":1,"🚋":1,"🚌":1,"🚊":1,"🔟":1,"🔝":1,"🔞":1,"🔛":1,"🔜":1,"🔚":1,"🌏":1,"🐼":1,"🐻":1,"☝":1,"🅾":1,"🅿":1,"🚙":1,"🚘":1,"🌎":1,"❤":2,"🔗":1,"🔔":1,"🔕":1,"🔒":1,"🔓":1,"🔐":1,"🔑":1,"🔘":1,"🔙":1,"🚆":1,"🚇":1,"⛳":1,"⛲":1,"⛵":1,"🚃":1,"🚀":1,"🚁":1,"🌍":1,"🚈":1,"🚉":1,"🅰":1,"☑":1,"☔":1,"☕":1,"🏀":1,"🍘":1,"🍙":1,"🐨":1,"🐩":1,"🍐":1,"🍑":1,"🈯":1,"🍓":1,"🍔":1,"🍕":1,"🍖":1,"🍗":1,"🆘":1,"🆙":1,"🌠":1,"🆒":1,"🆓":1,"🆑":1,"🆖":1,"🆗":1,"🆔":1,"🆕":1,"◽":1,"◾":1,"◻":1,"◼":1,"⁉":1,"👙":1,"👘":1,"👗":1,"👖":1,"👕":1,"👔":1,"👓":1,"👒":1,"👑":1,"👐":1,"🚏":1,"☁":1,"🆚":1,"⌛":1,"📚":1,"🐫":1,"🍚":1,"🍛":1,"🍜":1,"🍝":1,"📛":1,"🍟":1,"🐮":1,"🎹":1,"🎸":1,"📜":1,"🏩":1,"🎱":1,"👟":1,"👞":1,"👝":1,"➰":1,"👛":1,"👚":1,"📞":1,"📟":1,"📷":1,"🐹":1,"〽":1,"🔽":1,"🚬":1,"🙋":1,"🙌":1,"🙊":1,"🙏":1,"🎈":1,"🙍":1,"🙎":1,"⚾":1,"⚽":1,"🚩":1,"🗼":1,"😿":1,"😾":1,"😽":1,"😼":1,"😻":1,"😺":1,"🗽":1,"🚛":1,"🐱":1,"🏦":1,"🐰":1,"🍹":1,"🐳":1,"🙀":1,"🍄":1,"🙆":1,"🙇":1,"🙅":1,"⌚":1,"🍃":1,"🙈":2,"🙉":1,"↪":1,"🍂":1,"⛽":1,"〰":1,"🍁":1,"📯":1,"⏰":1,"⏳":1,"📮":1,"🌰":1,"🌇":1,"🔎":1,"📭":1,"📬":1,"🗾":1,"🐸":1,"📫":1,"😷":1,"😶":1,"😵":1,"😴":1,"😳":1,"😲":1,"😱":1,"😰":1,"🔊":1,"😹":1,"😸":1];
        
        self.emojiTag = ["👵": ["older","woman","grandmother","female","women","girl","lady"],"👴": ["older","man","bald","grandfather","human","male","men"],"👷": ["construction","worker","ambulance","male","human","wip","guy","build"],"👶": ["baby","toddler","child","boy","girl"],"👱": ["person","blond","hair","yellow","man","male","boy","blonde","guy"],"👰": ["bride","veil","wife","wedding","couple","marriage"],"👳": ["man","turban","male","indian","hinduism","arabs"],"👲": ["mao","army","soldier","male","boy"],"👽": ["extraterrestrial","alien","ufo","paul","weird","outer_space"],"👼": ["baby","angel","heaven","wings","halo"],"👿": ["imp","devil","evil","purple","angry","horns"],"✊": ["raised","fist","power","fingers","hand","grasp"],"👹": ["ogre","devil","evil","red","monster","mask","halloween","scary","creepy","demon"],"👸": ["princess","crown","girl","woman","female","blond","royal","queen"],"👻": ["ghost","crazy","halloween","spooky","scary"],"👺": ["goblin","devil","evil","red","mask","monster","scary","creepy"],"👥": ["busts","silhouette","user","person","human","group","team"],"👤": ["bust","silhouette","user","person","human"],"👧": ["girl","female","woman","teenager"],"👦": ["boy","man","male","guy","teenager"],"👡": ["womans","sandal","shoe","shoes","fashion","flip flops"],"👠": ["high-heeled","shoe","heels","fashion","shoes","female","pumps","stiletto"],"👣": ["footprints","feet","tracking","walking","beach"],"👢": ["womans","boots","shoe","shoes","fashion"],"👭": ["women","girls","holdinghands","gay","couple","lesbian","pair","friendship","love","like","female","people","human"],"👬": ["two","men","holdinghands","couple","gay","pair","love","like","bromance","friendship","people","human"],"👯": ["woman","bunny","ears","dancing","friends","bff","female","women","girls"],"👮": ["police","officer","man","law","legal","enforcement","arrest","911"],"👩": ["woman","female","girls","lady"],"👨": ["man","dad","mustache","father","guy","classy","sir","moustache"],"👫": ["man","woman","holdinghands","couple","pair","people","human","love","date","dating","like","affection","valentines","marriage"],"👪": ["family","home","parents","child","mom","dad","father","mother","people","human"],"👕": ["t-shirt","clothes","fashion","cloth","casual","tshirt","tee"],"👔": ["necktie","shirt","clothes","suitup","formal","fashion","cloth","business"],"👗": ["dress","clothes","fashion","shopping"],"👖": ["jeans","trousers","clothes","fashion","shopping"],"👑": ["crown","king","queen","kod","leader","royalty","lord"],"👐": ["open","hands","massage","fingers","butterfly"],"👓": ["eyeglasses","glasses","fashion","accessories","eyesight","nerd","dork","geek"],"👒": ["womans","hat","showoff","fashion","accessories","female","lady","spring"],"👝": ["pouch","handbag","bag","accessories","shopping"],"👜": ["handbag","fashion","accessory","accessories","shopping"],"👟": ["athletic","shoe","white","shoes","sports","sneakers"],"👞": ["mans","shoe","fashion","male"],"👙": ["bikini","swimsuit","tan","swimming","female","woman","girl","fashion","beach","summer"],"👘": ["kimono","japanese","dress","fashion","women","female"],"👛": ["purse","fashion","accessories","money","sales","shopping"],"👚": ["womans","clothes","fashion","shopping","female"],"👅": ["tongue","mouth","playful"],"👄": ["mouth","kiss"],"👇": ["down","index","fingers","hand","direction"],"👆": ["up","finger","index","fingers","hand","direction"],"👀": ["eyes","wink","watching","look","watch","stalk","peek","see"],"👃": ["nose","smell","sniff"],"👂": ["ear","face","hear","sound","listen"],"👍": ["thumbsup","hand","good","approve","nice","cool","yes","awesome","agree","accept","like"],"👌": ["ok","hand","perfect","nice","delicious","incredible","fingers","limbs"],"👏": ["clapping","hands","applause","congrats","praise","yay"],"👎": ["thumbsdown","down","hand","bad","sad","disappointed","no","dislike"],"👉": ["right","finger","index","fingers","hand","direction"],"👈": ["left","finger","index","direction","fingers","hand"],"👋": ["waving","hand","goodbye","greetings","hands","gesture","solong","farewell","hello","palm"],"👊": ["fisted","fist","punch","force","boxing","beating","strong","angry","violence","hit","attack","hand"],"🐵": ["monkey","face","animal","nature","circus"],"🐴": ["horse","face","animal","brown","nature","unicorn"],"🐷": ["pig","face","animal","oink","nature"],"👾": ["alien","monster","game","arcade","play"],"🐱": ["cat","face","animal","meow","nature","pet"],"🐰": ["rabbit","face","animal","nature","pet","spring","magic"],"🐳": ["spouting","whale","animal","nature","sea","ocean"],"🐲": ["dragon","face","animal","myth","nature","chinese","green"],"🐽": ["pig","nose","animal","oink"],"🐼": ["panda","face","animal","nature"],"🐾": ["paw","prints","animal","tracking","footprints","dog","cat","pet","paw_prints"],"🐹": ["hamster","face","animal","nature"],"🐸": ["frog","face","animal","nature","croak"],"🐻": ["bear","face","animal","nature","wild"],"🐺": ["wolf","face","animal","nature","wild"],"🐥": ["front-facing","baby","chick","animal","chicken","bird"],"🐤": ["baby","chick","animal","chicken","bird"],"🐧": ["penguin","animal","nature"],"🐦": ["bird","animal","nature","fly","tweet","spring"],"🐡": ["blowfish","animal","nature","food","sea","ocean"],"🐠": ["tropical","fish","animal","swim","ocean","beach","nemo"],"🐣": ["hatching","chick","egg","animal","chicken","born","baby","bird"],"🐢": ["turtle","slow","animal","nature","tortoise"],"🐭": ["mouse","face","animal","nature","cheese"],"🐬": ["dolphin","animal","nature","fish","sea","ocean","flipper","fins","beach"],"🐯": ["tiger","face","animal","cat","danger","wild","nature","roar"],"🐮": ["cow","face","beef","ox","animal","nature","moo","milk"],"🐩": ["poodle","dog","animal","101","nature","pet"],"🐨": ["koala","australia","animal","nature"],"🐫": ["bactrian","camel","animal","nature","hot","desert","hump"],"🐪": ["dromedary","camel","animal","hot","desert","hump"],"🐕": ["dog","animal","nature","friend","doge","pet","faithful"],"🐔": ["chicken","animal","cluck","nature","bird"],"🐗": ["boar","animal","nature"],"🐖": ["pig","animal","nature"],"🐑": ["sheep","animal","nature","wool","shipit"],"🐐": ["goat","animal","nature"],"🐓": ["rooster","animal","nature","chicken"],"🐒": ["monkey","animal","nature","banana","circus"],"🐝": ["honeybee","animal","insect","nature","bug","spring"],"🐜": ["ant","animal","insect","nature","bug"],"🐟": ["fish","animal","food","nature"],"🐞": ["lady","beetle","animal","insect","nature","bug"],"🐙": ["octopus","animal","creature","ocean","sea","nature","beach"],"🐘": ["elephant","animal","nature","nose","thailand","circus"],"🐛": ["bug","animal","insect","nature","worm"],"🐚": ["spiral","shell","nature","sea","beach"],"🐅": ["tiger","animal","nature","roar"],"🐄": ["cow","beef","ox","animal","nature","moo","milk"],"🐇": ["rabbit","animal","nature","pet","magic","spring"],"🐆": ["leopard","animal","nature"],"🐁": ["mouse","animal","nature","rodent"],"🐀": ["rat","animal","mouse","rodent"],"🐃": ["water","buffalo","animal","nature","ox","cow"],"🐂": ["ox","animal","cow","beef"],"🐍": ["snake","animal","evil","nature","hiss"],"🐌": ["snail","slow","animal","shell"],"🐏": ["ram","animal","sheep","nature"],"🐎": ["horse","animal","gamble","luck"],"🐉": ["dragon","animal","myth","nature","chinese","green"],"🐈": ["cat","animal","meow","pet","cats"],"🐋": ["whale","big","animal","nature","sea","ocean"],"☔": ["umbrella","rain","drops","rainy","weather","spring"],"📵": ["mobile","phones","forbidden","iphone","mute","circle"],"🚵": ["mountain","bicyclist","cyclist","bike","transportation","sports","human","race"],"📷": ["camera","photo","gadgets"],"📶": ["antenna","service","bars","blue-square","reception","phone","internet","connection","wifi","bluetooth"],"📱": ["mobile","phone","iphone","technology","apple","gadgets","dial"],"📰": ["newspaper","press","headline"],"📳": ["vibration","orange-square","phone"],"🍷": ["wine","glass","drink","alcohol","dinner","beverage","drunk","booze"],"📼": ["videocassette","record","video","oldschool","90s","80s"],"📹": ["video","camera","film","record"],"🍴": ["fork","knife","dinner","cutlery","kitchen"],"📻": ["radio","communication","music","podcast","program"],"📺": ["television","technology","program","oldschool","show"],"📥": ["inbox","tray","email","documents"],"📤": ["outbox","tray","inbox","email"],"📧": ["e-mail","communication","inbox","email"],"📦": ["package","box","delivery","amazon","mail","gift","cardboard","moving"],"📡": ["satellite","antenna","space","technology","communication","future","radio"],"📠": ["fax","machine","communication","technology"],"📣": ["cheering","megaphone","speaker","sound","volume"],"📢": ["public","address","loudspeaker","volume","sound"],"📭": ["open","mailbox","lowered","flag","email","inbox"],"📬": ["mailbox","email","inbox","communication"],"📯": ["postal","horn","instrument","music"],"📮": ["postbox","email","letter","envelope"],"📩": ["envelope","email","communication"],"📨": ["envelope","email","inbox"],"📫": ["closed","mailbox","email","inbox","communication"],"📪": ["mailbox","email","communication","inbox"],"📕": ["closed","book","read","library","knowledge","textbook","learn"],"📔": ["notebook","decorative","cover","classroom","notes","record","paper","study"],"📗": ["green","book","read","library","knowledge","study"],"📖": ["open","book","open_book","read","library","knowledge","literature","learn","study"],"📑": ["bookmark","tabs","favorite","save","order","tidy"],"📐": ["triangular","ruler","school","geometry","stationery","math","architect","sketch"],"📓": ["notebook","write","book","stationery","record","notes","paper","study"],"📒": ["ledger","notes","paper"],"📝": ["memo","write","note","documents","stationery","pencil","paper","writing","legal","exam","quiz","test","study"],"📜": ["scroll","documents","ancient","history","paper"],"📟": ["pager","bbcall","oldschool","90s"],"📞": ["telephone","receiver","technology","communication","dial"],"📙": ["orange","book","read","library","knowledge","textbook","study"],"📘": ["blue","book","read","library","knowledge","learn","study"],"📛": ["name","badge","fire","forbid"],"📚": ["books","read","literature","library","study"],"📅": ["calendar","schedule"],"📄": ["page","facing","up","documents","office","paper","information"],"📇": ["card","index","business","stationery"],"📆": ["tear-off","calendar","schedule","date","planning"],"📁": ["file","folder","documents","business","office"],"📀": ["dvd","cd","disk","disc"],"📃": ["page","curl","documents","office","paper"],"📂": ["open","file","folder","documents","load"],"📍": ["round","pushpin","pin","stationery","location","map","here"],"📌": ["pushpin","stationery","mark","here"],"📏": ["straight","ruler","stationery","calculate","length","math","school","drawing","architect","sketch"],"📎": ["paperclip","documents","stationery"],"📉": ["chart","downwards","trend","graph","presentation","stats","recession","business","economics","money","sales","bad","failure"],"📈": ["chart","upwards","trend","graph","presentation","stats","recovery","business","economics","money","sales","good","success"],"📋": ["clipboard","stationery","documents"],"📊": ["bar","chart","graph","presentation","stats"],"💵": ["banknote","dollar","cash","money","sales","bill","currency"],"💴": ["banknote","yen","cash","money","sales","japanese","dollar","currency"],"💷": ["banknote","pound","cash","british","sterling","money","sales","bills","uk","england","currency"],"💶": ["banknote","euro","cash","money","sales","dollar","currency"],"💱": ["registered","currencies","money","international","sign","sales","dollar","travel"],"⛄": ["snowman","without","snow","winter","season","cold","weather","christmas","xmas","frozen"],"💳": ["credit","card","gold","rich","money","sales","dollar","bill","payment","shopping"],"🆗": ["squared","ok","good","agree","yes","blue-square"],"💽": ["minidisc","cd","disc","technology","record","data","disk","90s"],"💼": ["briefcase","corporate","business","documents","work","law","legal"],"💿": ["optical","disc","cd","technology","dvd","disk","90s"],"💾": ["floppy","disk","oldschool","technology","save","90s","80s"],"💹": ["chart","upwards","yen","growth","green-square","graph","presentation","stats"],"💸": ["money","wings","cash","rich","dollar","bills","payment","sale"],"💻": ["personal","computer","mac","imac","design","tech","laptop","screen","display","monitor"],"💺": ["seat","plane","sit","airplane","transport","bus","flight","fly"],"💥": ["collision","boom","explosion","bomb","explode","blown"],"💤": ["sleeping","zzzz","asleep","sleepy","tired"],"💧": ["droplet","water","rain","drip","faucet","spring"],"💦": ["splashing","sweat","water","splashes","wet","drip","oops"],"💡": ["electric","light","bulb","idea","smart","electricity"],"🍸": ["cocktail","glass","martini","drink","drunk","alcohol","beverage","booze"],"💣": ["bomb","boom","explode","explosion","terrorism"],"💢": ["anger","angry","mad"],"💭": ["thought","balloon","bubble","cloud","speech","thinking"],"💬": ["speech","balloon","bubble","words","message","talk","chatting"],"💯": ["hundred","points","score","perfect","numbers","century","exam","quiz","test","pass"],"🍹": ["tropical","drink","cocktail","alcohol","beverage","summer","beach","booze"],"💩": ["poop","smile","crotte","shit","shitface","fail","turd"],"💨": ["dash","air","fart","smell","wind","fast","shoo","smoke","puff"],"💫": ["dizzy","stars","star","sparkle","shoot","magic"],"💪": ["biceps","strong","muscle","arm","flex","hand","summer"],"💕": ["two","hearts","love","like","affection","valentines"],"💔": ["broken","heart","sad","sorry","break"],"💗": ["growing","heart","like","love","affection","valentines","pink"],"💖": ["sparkling","heart","love","like","affection","valentines"],"💑": ["couple","relationship","heart","pair","love","like","affection","human","dating","valentines","marriage"],"💐": ["bouquet","flowers","nature","spring"],"💓": ["beating","heart","love","like","affection","valentines","pink"],"🍧": ["ice","icecream","scoops","food","hot","dessert","summer"],"💝": ["heart","ribbon","love","valentines"],"💜": ["purple","heart","love","like","affection","valentines"],"💟": ["heart","pink","purple-square","love","like"],"💞": ["revolving","hearts","love","like","affection","valentines"],"💙": ["blue","heart","love","like","affection","valentines"],"💘": ["heart","arrow","pink","love","like","affection","valentines"],"💛": ["yellow","heart","love","like","affection","valentines"],"💚": ["green","heart","love","like","affection","valentines"],"💅": ["nail","polish","beauty","manicure","finger","fashion"],"💄": ["lipstick","female","girl","fashion","woman"],"💇": ["haircut","hairdress","female","girl","woman"],"💆": ["face","massage","head","female","girl","woman"],"💁": ["information","desk","princess","arrogant","female","girl","woman","human"],"💀": ["skull","death","dead","skeleton","creepy"],"💃": ["dancer","tango","female","girl","woman","fun"],"💂": ["guardsman","english","uk","gb","british","male","guy","royal"],"💍": ["ring","wedding","union","propose","marriage","valentines","diamond","fashion","jewelry","gem"],"💌": ["love","letter","email","like","affection","envelope","valentines"],"💏": ["kiss","love","inlove","relationship","couple","pair","valentines","like","dating","marriage"],"💎": ["gem","stone","diamond","rich","blue","ruby","jewelry"],"💉": ["syringe","drug","doctor","hospital","health","drugs","blood","medicine","needle","nurse"],"💈": ["barber","sign","hair","salon","style"],"💋": ["kiss","mark","lips","love","face","like","affection","valentines"],"💊": ["pill","drug","medicine","health","doctor","pharmacy"],"🍠": ["roasted","eggplant","potato","food","nature"],"🆚": ["squared","vs","versus","words","orange-square"],"🍡": ["dango","skewer","marshmallow","sweets","food","barbecue","meat"],"🕥": ["clock","time","ten-thirty","late","early","schedule"],"🍮": ["custard","dessert","food"],"🕧": ["clock","time","twelve-thirty","late","early","schedule"],"🕦": ["clock","time","eleven-thirty","late","early","schedule"],"🕡": ["clock","time","six-thirty","late","early","schedule"],"🆘": ["distress","sos","help","red-square","words","emergency","911"],"🕣": ["clock","eight-thirty","time","late","early","schedule"],"🚬": ["smoking","cigarette","kills","tobacco","joint"],"🆙": ["squared","up","exclamation","order","blue-square","above","high"],"⬜": ["white","square","shape","icon","stone","button"],"➕": ["plus","sign","+","addition","math","calculation","more","increase"],"🕕": ["clock","time","six","oclock","late","early","schedule","dawn","dusk"],"🕔": ["clock","time","five","oclock","late","early","schedule"],"🕗": ["clock","time","eight","oclock","late","early","schedule"],"🕖": ["clock","time","seven","oclock","late","early","schedule"],"🕑": ["clock","time","two","oclock","late","early","schedule"],"🕐": ["clock","time","one","oclock","late","early","schedule"],"🕓": ["clock","time","four","oclock","late","early","schedule"],"〰": ["wavy","dash"],"🕝": ["clock","time","two-thirty","late","early","schedule"],"🍪": ["cookie","dough","food","snack","oreo","chocolate","sweet","dessert"],"🕟": ["clock","time","four-thirty","late","early","schedule"],"🕞": ["clock","time","three-thirty","late","early","schedule"],"🕙": ["clock","time","ten","oclock","late","early","schedule"],"🕘": ["clock","time","nine","oclock","late","early","schedule"],"🕛": ["clock","time","twelve","oclock","midnight","midday","noon","late","early","schedule"],"🍫": ["chocolate","bar","food","snack","dessert","sweet"],"🆒": ["squared","cool","words","blue-square"],"🍨": ["ice","cream","icecream","food","hot","dessert"],"🚶": ["pedestrian","walking","human","feet","steps"],"☺": ["shy","pleased","embarassed","happy","smile","face"],"➿": ["double","curly","loop","tape","cassette"],"🔵": ["blue","circle","shape","icon","button"],"🍖": ["meat","bone","chicken","wings","good","food","drumstick"],"🔷": ["blue","diamond","shape","jewel","gem"],"🔶": ["orange","diamond","shape","jewel","gem"],"⛅": ["sun","behind","cloud","weather","nature","cloudy","morning","fall","spring"],"❄": ["snowflake"],"🔳": ["white","square","shape","input"],"🍗": ["poultry","leg","chicken","wings","food","meat","drumstick","bird","turkey"],"🔽": ["triangle","blue-square","direction","bottom"],"🔼": ["triangle","blue-square","direction","point","forward","top"],"♊": ["gemini","zodiac","sign","purple-square","astrology"],"🔹": ["blue","losange","diamond","shape","jewel","gem"],"🍔": ["hamburger","burger","macdonalds","fat","meat","fast food","beef","cheeseburger","mcdonalds","burger king"],"🔻": ["red","triangle","shape","direction","bottom"],"🔺": ["red","danger","triangle","shape","direction","up","top"],"🔥": ["fire","burning","hot","cook","flame"],"🆎": ["squared","ab","red-square","alphabet"],"🔧": ["wrench","tool","builder","tools","diy","ikea","fix","maintainer"],"🔦": ["electric","torch","dark","camping","sight","night"],"🔡": ["letters","abcd","alphabet","blue-square"],"✏": ["pencil"],"🔣": ["symbols","blue-square","music","note","ampersand","percent","glyphs","characters"],"🔢": ["numbers","digits","1234","blue-square"],"🔭": ["telescope","stars","space","zoom"],"🔬": ["microscope","science","biology","study","research","laboratory","experiment","zoomin"],"🔯": ["sixpointed","david","star","jewish","purple-square","religion","hexagram"],"🔮": ["crystal","ball","guess","magic","disco","party","circus","fortune_teller"],"🔩": ["nut","bolt","handy","tools","fix"],"🔨": ["hammer","tool","builder","tools","verdict","judge","done","law","legal","ruling","gavel"],"🔫": ["pistol","gun","firearm","kill","shoot","violence","weapon","revolver"],"🔪": ["hocho","knife","cut","blade","cutlery","kitchen","weapon"],"🔕": ["bell","cancellation","stroke","sound","volume","mute","quiet","silent"],"🔔": ["bell","sound","notification","christmas","xmas","chime"],"🔗": ["chain","link","rings","url"],"🔖": ["bookmark","favorite","label","save"],"🔑": ["key","lock","door","password"],"❤": ["black","red","heart","love"],"🔓": ["open","lock","privacy","security"],"🔒": ["lock","closed","security","password","padlock"],"🔝": ["top","upwards","arrow","above","words","blue-square"],"🔜": ["soon","rightwards","arrow","will","words"],"🔟": ["keycap","ten","numbers","10","blue-square"],"🍑": ["peach","fruit","nature","food"],"🔙": ["back","leftwards","arrow","words","return"],"🔘": ["button","input","old","music","circle"],"🔛": ["on","left","right","arrow","words"],"🔚": ["end","leftwards","arrow","words"],"🔅": ["brightness","sun","afternoon","warm","summer"],"🍞": ["bread","food","wheat","breakfast","toast"],"🔇": ["speaker","cancellation","sound","volume","silence","quiet"],"🔆": ["brightness","sun","light"],"⛵": ["sailboat","boat","sea","ship","summer","transportation","water","sailing"],"🔀": ["twisted","shuffle","random","arrows","blue-square","music"],"🔃": ["circle","cycle","repeat","again","arrows","sync","round"],"🍟": ["french","fries","food","junk","macdonalds","chips","snack","fast food"],"🔍": ["magnifying","glass","loupe","search","zoom","find","detective"],"🔌": ["electric","plug","charger","power"],"🔏": ["lock","ink","pen","security","secret"],"🔎": ["magnifying","glass","loupe","search","zoom","find","detective"],"🔉": ["speaker","sound","volume","broadcast"],"🔈": ["speaker","sound","volume","silence","broadcast"],"🔋": ["battery","power","energy","sustain"],"🔊": ["speaker","sound","volume","noise","noisy","broadcast"],"🍝": ["spaghetti","food","italian","noodle"],"⬇": ["downwards","arrow"],"🗽": ["statue","liberty","newyork","postcard","american"],"🗼": ["tokyo","tower","photo","japanese"],"🗿": ["moyai","stone","history","easter island","beach","statue"],"🗾": ["japan","island","nation","country","japanese","asia"],"🗻": ["mount","fuji","japan","photo","mountain","nature","japanese"],"🍛": ["curry","rice","food","spicy","hot","indian"],"🐶": ["dog","face","animal","friend","nature","woof","puppy","pet","faithful"],"☕": ["hot","beverage","drink","tea","cafe","espresso"],"🍘": ["rice","cracker","food","japanese"],"🍙": ["rice","sushi","food","japanese"],"🍆": ["aubergine","eggplant","vegetable","nature","food"],"🍇": ["grapes","fruit","food","wine"],"⚪": ["white","circle","shape","round"],"🍄": ["mushroom","plant","vegetable"],"🀄": ["mahjong","tile","chinese","game","play","kanji"],"🍅": ["tomato","fruit","vegetable","nature","food"],"🍂": ["fallen","leaf","autumn","nature","plant","vegetable","leaves"],"🎋": ["tanabata","tree","plant","nature","branch","summer"],"🍃": ["leaf","fluttering","in","wind","nature","plant","tree","vegetable","grass","lawn","spring"],"🍀": ["four","leaf","clover","vegetable","plant","nature","lucky"],"🆓": ["squared","free","blue-square","words"],"🚂": ["steam","locomotive","transportation","vehicle","train"],"🍰": ["shortcake","cake","pastry","food","dessert"],"🍎": ["red","apple","fruit","mac","school"],"🍏": ["green","apple","fruit","nature"],"🍌": ["banana","fruit","food","monkey"],"🍍": ["pineapple","fruit","nature","food"],"♥": ["heart","cards","game","suit"],"🍊": ["tangerine","fruit","food","nature"],"⛪": ["church","building","religion","christ"],"⏬": ["double","triangle","blue-square","direction","bottom"],"🍱": ["bento","box","food","japanese"],"🍋": ["lemon","fruit","nature"],"🍈": ["melon","fruit","nature","food"],"🍉": ["watermelon","fruit","food","picnic","summer"],"🎶": ["musical","notes","music","score"],"🎷": ["saxophone","music","instrument","jazz","blues"],"🎴": ["flower","playing","cards","game","sunset","red"],"🎵": ["musical","note","score","tone","sound"],"🎲": ["game","dice","random","tabbletop","play","luck"],"🎳": ["bowling","sports","fun","play"],"🎰": ["slot","machine","game","luck","bet","gamble","vegas","fruit machine","casino"],"🎱": ["billiards","8","pool","hobby","game","luck","magic"],"🎾": ["tennis","racquet","ball","sport","sports","balls","green"],"🎿": ["skis","boot","winter","snow","sport","sports","cold"],"🎼": ["musical","score","note","treble","clef"],"🎽": ["running","shirt","sash","play","pageant"],"🎺": ["trumpet","music","instrument","brass"],"🎻": ["violin","music","instrument","orchestra","symphony"],"🎸": ["guitar","music","instrument"],"🎹": ["musical","keyboard","piano","instrument"],"🎦": ["cinema","blue-square","record","film","movie"],"🎧": ["headphone","music","score","gadgets"],"🎤": ["microphone","singer","sound","music","pa"],"🎥": ["movie","camera","film","record"],"🎢": ["roller","coaster","postcard","carnival","playground","photo","fun"],"🎣": ["fishing","pole","fish","food","hobby","summer"],"🎠": ["carousel","horse","postcard","photo","carnival"],"🎡": ["ferris","wheel","postcard","photo","carnival","londoneye"],"🎮": ["video","game","geek","play","console","ps4","controller"],"🎯": ["direct","hit","dart","tagert","game","play","bar"],"🎬": ["clapper","board","movie","film","record"],"🎭": ["performing","arts","masks","acting","theater","drama"],"🎪": ["circus","tent","festival","carnival","party"],"🎫": ["ticket","event","concert","pass"],"🎨": ["artist","palette","paint","design","draw","colors"],"🎩": ["top","hat","magic","gentleman","classy","circus"],"™": ["trade","mark","trademark"],"🎒": ["school","satchel","student","education","bag"],"🎓": ["graduation","cap","school","college","degree","university","hat","legal","learn","education"],"🎐": ["wind","chime","nature","ding","spring","bell"],"🎑": ["moon","viewing","ceremony","photo","japan","asia","tsukimi"],"🙅": ["face","no","cross","combat","female","girl","woman","nope"],"🎇": ["firework","sparkler","stars","night","shine"],"🙇": ["person","bowing","deeply","focused","thinking","surprised","man","male","boy"],"🙆": ["ok","gesture","combat","women","girl","female","pink","human"],"🎂": ["birthday","cake","party","celebration"],"🎃": ["jack-o-lantern","halloween","pumpkin","light","creepy","fall"],"🎀": ["ribbon","knot","surprise","present","gift","decoration","pink","girl","bowtie"],"🎁": ["wrapped","present","gift","birthday","christmas","xmas"]]
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
        if tagsArray.count == 0 {
            print("Search with empty array")
            for (emoji, tagArray) in emojiTag {
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
        if self.emojiScore[emoji] != nil {
            self.emojiScore[emoji] = (self.emojiScore[emoji] as Int!) + 1;
            return (self.emojiScore[emoji] as Int!);
        }
        self.emojiScore[emoji] = 0;
        return 0
    }
    
}