//
//  DscribeColors.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 28/12/2015.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit

class DscribeColors: GlobalColors {
    override class var lightModeSpecialKey: UIColor { get { return DscribeColors.lightModeSolidColorSpecialKey }}
    override class var lightModeSolidColorSpecialKey: UIColor { get { return UIColor.black.withAlphaComponent(0.16) }}

    // TODO actually use
//    class var lightModeSuggestion: UIColor { get { return UIColor.redColor() }} //(red: CGFloat(38.6)/CGFloat(255), green: CGFloat(18)/CGFloat(255), blue: CGFloat(39.3)/CGFloat(255), alpha: 0.4) }}
    class var lightModeSelectedSuggestion: UIColor { get { return UIColor(red: CGFloat(235)/CGFloat(255), green: CGFloat(237)/CGFloat(255), blue: CGFloat(239)/CGFloat(255), alpha: 1) }}

//    class var darkModeSuggestion: UIColor { get { return UIColor(red: CGFloat(38.6)/CGFloat(255), green: CGFloat(18)/CGFloat(255), blue: CGFloat(39.3)/CGFloat(255), alpha: 0.4) }}
//    class var darkModeSolidColorSuggestion: UIColor { get { return UIColor(red: CGFloat(38.6)/CGFloat(255), green: CGFloat(18)/CGFloat(255), blue: CGFloat(39.3)/CGFloat(255), alpha: 0.4) }}
//    
//    class var darkModeHighlightedSuggestion: UIColor { get { return UIColor(red: CGFloat(38.6)/CGFloat(255), green: CGFloat(18)/CGFloat(255), blue: CGFloat(39.3)/CGFloat(255), alpha: 0.4) }}
//    class var darkModeSolidColorHighlightedSuggestion: UIColor { get { return UIColor(red: CGFloat(38.6)/CGFloat(255), green: CGFloat(18)/CGFloat(255), blue: CGFloat(39.3)/CGFloat(255), alpha: 0.4) }}

    class var selectedTextColor: UIColor { get { return UIColor(red: CGFloat(20)/CGFloat(255), green: CGFloat(111)/CGFloat(255), blue: CGFloat(223)/CGFloat(255), alpha: 1) }}
    class var darkModeSelectedTextColor: UIColor { get { return UIColor(red: CGFloat(128)/CGFloat(255), green: CGFloat(179)/CGFloat(255), blue: 1.0, alpha: 1) }}
    
    class func selectedSuggestionBackground(_ darkMode: Bool, solidColorMode: Bool) -> UIColor {
        if darkMode {
            if solidColorMode {
                return self.darkModeSolidColorRegularKey
            } else {
                return self.darkModeRegularKey
            }
        } else {
            return self.lightModeSelectedSuggestion
        }
    }

    class func selectedTextColor(_ darkMode: Bool) -> UIColor {
        if darkMode {
            return self.darkModeSelectedTextColor
        } else {
            return self.selectedTextColor
        }
    }
}
