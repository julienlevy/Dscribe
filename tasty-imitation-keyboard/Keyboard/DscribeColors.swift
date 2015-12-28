//
//  DscribeColors.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 28/12/2015.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit

class DscribeColors: GlobalColors {
    class var lightModeSuggestion: UIColor { get { return UIColor.redColor() }} //(red: CGFloat(38.6)/CGFloat(255), green: CGFloat(18)/CGFloat(255), blue: CGFloat(39.3)/CGFloat(255), alpha: 0.4) }}
    class var lightModeHighlightedSuggestion: UIColor { get { return UIColor(red: CGFloat(38.6)/CGFloat(255), green: CGFloat(18)/CGFloat(255), blue: CGFloat(39.3)/CGFloat(255), alpha: 0.4) }}
    
    class var darkModeSuggestion: UIColor { get { return UIColor(red: CGFloat(38.6)/CGFloat(255), green: CGFloat(18)/CGFloat(255), blue: CGFloat(39.3)/CGFloat(255), alpha: 0.4) }}
    class var darkModeSolidColorSuggestion: UIColor { get { return UIColor(red: CGFloat(38.6)/CGFloat(255), green: CGFloat(18)/CGFloat(255), blue: CGFloat(39.3)/CGFloat(255), alpha: 0.4) }}
    
    class var darkModeHighlightedSuggestion: UIColor { get { return UIColor(red: CGFloat(38.6)/CGFloat(255), green: CGFloat(18)/CGFloat(255), blue: CGFloat(39.3)/CGFloat(255), alpha: 0.4) }}
    class var darkModeSolidColorHighlightedSuggestion: UIColor { get { return UIColor(red: CGFloat(38.6)/CGFloat(255), green: CGFloat(18)/CGFloat(255), blue: CGFloat(39.3)/CGFloat(255), alpha: 0.4) }}
    
    class func suggestionBackground(darkMode: Bool, solidColorMode: Bool) -> UIColor {
        if darkMode {
            if solidColorMode {
                return self.darkModeSolidColorSuggestion
            }
            else {
                return self.darkModeSuggestion
            }
        }
        else {
            return self.lightModeSuggestion
        }
    }
    
    class func highlightedSuggestionBackground(darkMode: Bool, solidColorMode: Bool) -> UIColor {
        if darkMode {
            if solidColorMode {
                return self.darkModeSolidColorHighlightedSuggestion
            }
            else {
                return self.darkModeHighlightedSuggestion
            }
        }
        else {
            return self.lightModeHighlightedSuggestion
        }
    }
}