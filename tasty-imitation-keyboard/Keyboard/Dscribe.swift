//
//  DscribeKeyboardController.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 06/11/2015.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit

/*
This is the demo keyboard. If you're implementing your own keyboard, simply follow the example here and then
set the name of your KeyboardViewController subclass in the Info.plist file.
*/

let kEscapeTypeEnabled = "kEscapeTypeEnabled"


class Dscribe: KeyboardViewController, DscribeBannerDelegate {
    
    
    let takeDebugScreenshot: Bool = false
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        NSUserDefaults.standardUserDefaults().registerDefaults([kCatTypeEnabled: true])
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func keyPressed(key: Key) {
        if let textDocumentProxy = self.textDocumentProxy as? UITextDocumentProxy {
            let keyOutput = key.outputForCase(self.shiftState.uppercase())
            
            if !NSUserDefaults.standardUserDefaults().boolForKey(kCatTypeEnabled) {
                textDocumentProxy.insertText(keyOutput)
                return
            }
            
            if key.type == .Character || key.type == .SpecialCharacter {
                let context = textDocumentProxy.documentContextBeforeInput
                if context != nil {
                    if context?.characters.count < 2 {
                        textDocumentProxy.insertText(keyOutput)
                        return
                    }
                    
                    var index = context!.endIndex
                    
                    index = index.predecessor()
                    if context![index] != " " {
                        textDocumentProxy.insertText(keyOutput)
                        return
                    }
                    
                    index = index.predecessor()
                    if context![index] == " " {
                        textDocumentProxy.insertText(keyOutput)
                        return
                    }
                    
                    textDocumentProxy.insertText("DSCRIBE")
                    textDocumentProxy.insertText(" ")
                    textDocumentProxy.insertText(keyOutput)
                    return
                }
                else {
                    textDocumentProxy.insertText(keyOutput)
                    return
                }
            }
            else {
                textDocumentProxy.insertText(keyOutput)
                return
            }
            //––––––––––––––––––
            if keyOutput == "|" {
                //Check predecessor : if star also :
                    //toggle escape mode (when escaped mode, change design to darker or funnier)
                    //if escapeMode just gone out, delete string between escaping keys (and if emoji swiped down?)
            }
            //If in escape mode
                //search for last occurence of escape key and store string since
                //Send string to Model to analyse and compare to emoji tag
                //Get back array of emoji and display array of emoji
            
            
            //OVERWRITE case when DELETE key is hit
            //if escape && deleted/to delete key is "|"
                //go out of escape mode
            //Same, OVERWRITE return button
            
        }
    }
    
    override func setupKeys() {
        super.setupKeys()
        
        if takeDebugScreenshot {
            if self.layout == nil {
                return
            }
            
            for page in keyboard.pages {
                for rowKeys in page.rows {
                    for key in rowKeys {
                        if let keyView = self.layout!.viewForKey(key) {
                            keyView.addTarget(self, action: "takeScreenshotDelay", forControlEvents: .TouchDown)
                        }
                    }
                }
            }
        }
    }
    
    override func createBanner() -> ExtraView? {
        let dscribeBanner = DscribeBanner(globalColors: self.dynamicType.globalColors, darkMode: false, solidColorMode: self.solidColorMode())
        dscribeBanner.delegate = self
        return dscribeBanner
    }
    
    func takeScreenshotDelay() {
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("takeScreenshot"), userInfo: nil, repeats: false)
    }
    
    func takeScreenshot() {
        if !CGRectIsEmpty(self.view.bounds) {
            UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
            
            let oldViewColor = self.view.backgroundColor
            self.view.backgroundColor = UIColor(hue: (216/360.0), saturation: 0.05, brightness: 0.86, alpha: 1)
            
            let rect = self.view.bounds
            UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
            var context = UIGraphicsGetCurrentContext()
            self.view.drawViewHierarchyInRect(self.view.bounds, afterScreenUpdates: true)
            let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let name = (self.interfaceOrientation.isPortrait ? "Screenshot-Portrait" : "Screenshot-Landscape")
            let imagePath = "/Users/archagon/Documents/Programming/OSX/RussianPhoneticKeyboard/External/tasty-imitation-keyboard/\(name).png"
            UIImagePNGRepresentation(capturedImage)!.writeToFile(imagePath, atomically: true)
            
            self.view.backgroundColor = oldViewColor
        }
    }
    
    func appendEmoji(emoji: String) {
        // Uses the data passed back
        NSLog("emoji button delegate")
        
        if let textDocumentProxy = self.textDocumentProxy as? UITextDocumentProxy {
            textDocumentProxy.insertText(emoji)
        }
    }
}


