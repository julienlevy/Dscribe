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
                return "spazio"
            } else if self == "return" {
                return "retorno"
            }
        case "fr":
            if self == "space" {
                return "espace"
            } else if self == "return" {
                return "retour"
            }
        case "ge":
            if self == "space" {
                return "espace"
            } else if self == "return" {
                return "retorno"
            }
        default:
            break
        }
        return self
    }
}