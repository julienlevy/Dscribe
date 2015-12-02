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
let kEscapeCue = "|"


class Dscribe: KeyboardViewController, DscribeBannerDelegate {
    
    
    let takeDebugScreenshot: Bool = false
    
    var escapeMode: Bool = false
    
    var stringToSearch: String = ""
    
    var overlayView: UIView = UIView()
    
    var emojis: Emoji = Emoji()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        NSUserDefaults.standardUserDefaults().registerDefaults([kCatTypeEnabled: true])
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: kSmallLowercase)
        
        //To change the height of the banner
        metrics = [
        "topBanner": 35
        ]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if view.bounds == CGRectZero {
            return
        }
        
        // TODO: call this in a more appropriate place: viewDidLayoutSubviews is called everytime a key is hit
        if overlayView.frame == CGRectZero {
            overlayView.backgroundColor = UIColor.blackColor()
            overlayView.alpha = 0.2
            overlayView.frame = self.view.frame
            overlayView.frame.origin = CGPointMake(0, (self.bannerView?.frame.size.height)!)
            overlayView.userInteractionEnabled = false
            overlayView.hidden = true
            self.view.addSubview(overlayView)
        }
    }
    
    override func keyPressed(key: Key) {
        let textDocumentProxy = self.textDocumentProxy as UITextDocumentProxy
        
        let keyOutput = key.outputForCase(self.shiftState.uppercase())
        
        //if keyOutput == kEscapeCue {
        //Check predecessor : if star also :
        //toggle escape mode (when escaped mode, change design to darker or funnier)
        //if escapeMode just gone out, delete string between escaping keys (and if emoji swiped down?)
        // }
        //If in escape mode
        //search for last occurence of escape key and store string since
        //Send string to Model to analyse and compare to emoji tag
        //Get back array of emoji and display array of emoji
        
        
        //OVERWRITE case when DELETE key is hit
        //if escape && deleted/to delete key is kEscapeCue
        //go out of escape mode
        //Same, OVERWRITE return button
        
        // TODO refacto :
        let context = textDocumentProxy.documentContextBeforeInput
        let firstRange = context!.rangeOfString(kEscapeCue, options:NSStringCompareOptions.BackwardsSearch)
        
        if keyOutput == kEscapeCue {
            if escapeMode {
                escapeMode = false;
                self.toggleSearchMode()
                
                // TODO : Store the string inputted in a variable instead because context might not be
                if (firstRange != nil) {
                    let lastIndex = context!.endIndex
                    let count = (firstRange!.startIndex..<lastIndex).count
                    for var i = 0; i < count; i++ {
                        textDocumentProxy.deleteBackward()
                    }
                }
                return
            } else {
                escapeMode = true
                self.toggleSearchMode()
                
                self.stringToSearch = ""
                textDocumentProxy.insertText(keyOutput)
                return
            }
        }
        else if escapeMode {
            //Not going to work because of delete, spaces etc..
            //self.stringToSearch += keyOutput
            //Call search function
            //
            textDocumentProxy.insertText(keyOutput)
            if keyOutput == "\n" {
                escapeMode = false
                self.toggleSearchMode()
                return
            }
            
            if (firstRange != nil) {
                let lastIndex = context!.endIndex
                self.stringToSearch = (context?.substringWithRange(firstRange!.startIndex..<lastIndex))!
                self.stringToSearch += keyOutput
            }
            //Send to search function
            //Display emojis
        }
        else {
            textDocumentProxy.insertText(keyOutput)
            return
        }
    }
    
    override func backspaceDown(sender: KeyboardKey) {
        
        
        let context = self.textDocumentProxy.documentContextBeforeInput
        
        if context?.characters.last == kEscapeCue.characters.first {
            self.escapeMode = false
            self.toggleSearchMode()
        }
        
        if escapeMode {
            let context = textDocumentProxy.documentContextBeforeInput
            let firstRange = context!.rangeOfString(kEscapeCue, options:NSStringCompareOptions.BackwardsSearch)
            
            if (firstRange != nil) {
                let lastIndex = context!.endIndex
                self.stringToSearch = (context?.substringWithRange(firstRange!.startIndex..<lastIndex.predecessor()))!
            }
        }
        
        
        super.backspaceDown(sender)
        
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
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("takeScreenshot"), userInfo: nil, repeats: false)
    }
    
    func takeScreenshot() {
        if !CGRectIsEmpty(self.view.bounds) {
            UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
            
            let oldViewColor = self.view.backgroundColor
            self.view.backgroundColor = UIColor(hue: (216/360.0), saturation: 0.05, brightness: 0.86, alpha: 1)
            
            let rect = self.view.bounds
            UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
            self.view.drawViewHierarchyInRect(self.view.bounds, afterScreenUpdates: true)
            let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let name = (self.interfaceOrientation.isPortrait ? "Screenshot-Portrait" : "Screenshot-Landscape")
            let imagePath = "/Users/archagon/Documents/Programming/OSX/RussianPhoneticKeyboard/External/tasty-imitation-keyboard/\(name).png"
            UIImagePNGRepresentation(capturedImage)!.writeToFile(imagePath, atomically: true)
            
            self.view.backgroundColor = oldViewColor
        }
    }
    
    func toggleSearchMode() {
        if self.escapeMode {
            overlayView.hidden = false
        } else {
            overlayView.hidden = true
        }
    }
    
    func searchEmojis(string: String) {
//        self.emojis.
    }
        
    func appendEmoji(emoji: String) {
        // Uses the data passed back
        NSLog("emoji button delegate")
        //TODO clear search text if any

        self.textDocumentProxy.insertText(emoji)
        
        self.dynamicType.globalColors
    }
}


