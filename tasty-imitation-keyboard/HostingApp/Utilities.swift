//
//  Utilities.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 02/02/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

func keyboardWasActivated() -> Bool {
    if let appBundleID = Bundle.main.bundleIdentifier {
        if let keyboards = UserDefaults.standard.object(forKey: "AppleKeyboards") as? [String] {
            if keyboards.contains(appBundleID + ".Keyboard") {
                print("Yes Utils")
                return true
            }
        }
        print("no utils")
    }
    return false
}

func backgroungLayerWithFrame(_ frame: CGRect) -> CAGradientLayer {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = frame
    gradientLayer.colors = [UIColor.dscribeDarkOrange().cgColor, UIColor.dscribeLightOrange().cgColor]

    return gradientLayer
}
