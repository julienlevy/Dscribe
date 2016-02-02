//
//  InstallKeyboardViewController.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 02/02/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class InstallKeyboardViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear")
        
    }

    @IBAction func installKeyboardPressed(sender: AnyObject) {
        if let settingsURL = NSURL(string: "prefs:root=General&path=Keyboard/KEYBOARDS") {
            UIApplication.sharedApplication().openURL(settingsURL)
        }
    }
}
