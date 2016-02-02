//
//  Utilities.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 02/02/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

func keyboardWasActivated() -> Bool {
    if let appBundleID = NSBundle.mainBundle().bundleIdentifier {
        if let keyboards = NSUserDefaults.standardUserDefaults().objectForKey("AppleKeyboards") as? [String] {
            if keyboards.contains(appBundleID + ".Keyboard") {
                print("Yes Utils")
                return true
            }
        }
        print("no utils")
    }
    return false
}

func backgroungLayerWithFrame(frame: CGRect) -> CAGradientLayer {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = frame
    gradientLayer.colors = [UIColor.dscribeDarkOrange().CGColor, UIColor.dscribeLightOrange().CGColor]

    return gradientLayer
}