//
//  DscribeCharactersUtils.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 07/01/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

let smallPunctuation: [String] = [".", ",", ";", "*", ":", ";"]

func keyLabelOffsetForCharacter(character: String, font: UIFont) -> CGFloat {
    let offset: CGFloat = 0.8 * (font.capHeight - font.xHeight) * 2
//    print(character)
//    print(offset)
    return 0
}

func fontForKeyWithText(keyText: String, keytype: Key.KeyType) -> UIFont {
    if keytype == Key.KeyType.Character && keyText == keyText.lowercaseString {
        if #available(iOSApplicationExtension 8.2, *) {
            return UIFont.systemFontOfSize(24, weight: UIFontWeightLight)
        }
        return UIFont.systemFontOfSize(24)
    }
    else if smallPunctuation.contains(keyText) {
        return UIFont.systemFontOfSize(24)
    }
    return UIFont.systemFontOfSize(22)
}