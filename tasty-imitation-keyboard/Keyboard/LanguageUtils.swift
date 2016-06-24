//
//  LanguageUtils.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 04/02/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import Foundation

extension String {
    func translation(language: String) -> String {
        switch language {
        case "es":
            if self == "space" {
                return "espacio"
            } else if self == "return" {
                return "intro"
            }
        case "fr":
            if self == "space" {
                return "espace"
            } else if self == "return" {
                return "retour"
            }
        case "ge":
            if self == "space" {
                return "Leerzeichen"
            } else if self == "return" {
                return "Return"
            }
        case "it":
            if self == "space" {
                return "spazio"
            } else if self == "return" {
                return "invio"
            }
        case "pt":
            if self == "space" {
                return "espaço"
            } else if self == "return" {
                return "retorno"
            }
        default:
            break
        }
        return self
    }
}

func accentAfterCharacter(lastTwo: String, withLanguage language: String) -> String {
    if lastTwo == "qu" {
        return "'"
    }
    //TODO refacto
    if let char = lastTwo.characters.last {
        let character = String(char)

        switch language {
        case "fr":
            switch character {
            case "qu":
                return "'"
            case "e":
                return "\u{301}"
            case "a", "u":
                return "\u{300}"
            case "i", "o":
                return "\u{302}"
            default:
                return "'"
            }
        case "es":
            switch character {
            case "e", "o", "a", "i", "u":
                return "\u{301}"
            case "n":
                return "\u{303}"
            default:
                return "'"
            }
        case "it":
            switch character {
            case "a", "e", "i", "o", "u":
                return "\u{300}"
                //        case "che", " ne", " se":
            //            return "\u{301}"
            default:
                return "'"
            }
        case "en":
            switch character {
            case "e":
                return "\u{301}"
            default:
                return "'"
            }
        default:
            return "'"
        }
    }
    return "'"
}