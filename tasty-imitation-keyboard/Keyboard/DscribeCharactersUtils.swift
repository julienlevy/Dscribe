//
//  DscribeCharactersUtils.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 07/01/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

let smallPunctuation: [String] = [".", ",", ";", "*", ":", ";"]
let bigOffset: [String] = ["{", "}", "[", "]", "+", "=", "\\", "/", "|", "<", ">", "-", ":", ";", "(", ")", "@"] //3 - 4.5 (Sketch)
let mediumOffset: [String] = ["_", "•", ".", ","] //2-3
let smallOffset: [String] = ["#", "%", "~", "€", "¥", "£", "*", "?", "!", "'", "$", "&", "\""] //1 - 2

func keyLabelOffsetForCharacter(character: String, font: UIFont) -> CGFloat {
    if bigOffset.contains(character) {
        return 4.4
    }
    if mediumOffset.contains(character) {
        return 2.0
    }
    if smallOffset.contains(character) {
        return 1.3
    }
    if character == character.lowercaseString && Int(character) == nil {
        return 0.7 * (font.capHeight - font.xHeight) * 2
    }
    return 1.0
}

func fontForKeyWithText(keyText: String, keytype: Key.KeyType) -> UIFont {
    if keytype == Key.KeyType.Character && keyText == keyText.lowercaseString {
        if #available(iOSApplicationExtension 8.2, *) {
            return UIFont.systemFontOfSize(24.5, weight: UIFontWeightLight)
        }
        return UIFont.systemFontOfSize(24)
    }
    else if smallPunctuation.contains(keyText) {
        return UIFont.systemFontOfSize(24)
    }
    return UIFont.systemFontOfSize(22)
}