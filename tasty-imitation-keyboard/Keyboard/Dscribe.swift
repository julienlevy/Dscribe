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
    
    var emojiClass: Emoji = Emoji()
    
    var appleLexicon: UILexicon = UILexicon()
    var checker: UITextChecker = UITextChecker()
    let language = "en"
    var suggestions: [String] = [String]()

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        NSUserDefaults.standardUserDefaults().registerDefaults([kCatTypeEnabled: true])
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        if let savedEmojis = loadEmojis() {
            emojiClass = savedEmojis
        } else {
            loadSampleEmojis()
        }
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: kSmallLowercase)
        //To change the height of the banner
        metrics = [
        "topBanner": 38
        ]

        self.requestSupplementaryLexiconWithCompletion({
            lexicon in

            self.appleLexicon = lexicon

            print("LEXICON")

            NSLog("Number of lexicon entries : %i", self.appleLexicon.entries.count)

            for lexiconEntry in self.appleLexicon.entries {
                NSLog("%@ -> %@", lexiconEntry.userInput, lexiconEntry.documentText)
            }
        })
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
            overlayView.userInteractionEnabled = false
            overlayView.hidden = true
            self.view.insertSubview(overlayView, atIndex: 0)
        }
    }

    override func keyPressed(key: Key) {
        let keyOutput = key.outputForCase(self.shiftState.uppercase())
        if keyOutput == kEscapeCue {
            if escapeMode {

                let context = self.textDocumentProxy.documentContextBeforeInput
                let firstRange = context?.rangeOfString(kEscapeCue, options:NSStringCompareOptions.BackwardsSearch)
                
                if (firstRange != nil) {
                    let lastIndex = context!.endIndex
                    let count = (firstRange!.startIndex..<lastIndex).count
                    for var i = 0; i < count; i++ {
                        textDocumentProxy.deleteBackward()
                    }
                }
            } else {
                //TODO replace with most used emoji
                (self.bannerView as! DscribeBanner).displayEmojis(Array(emojiScore.keys))
                
                self.textDocumentProxy.insertText(keyOutput)
            }
            
            escapeMode = !escapeMode
            self.displaySearchMode()
        } else {
            self.textDocumentProxy.insertText(keyOutput)
            let context = self.textDocumentProxy.documentContextBeforeInput
            if escapeMode {
                if keyOutput == "\n" {
                    escapeMode = false
                    self.displaySearchMode()
                    return
                }
                let firstRange = context?.rangeOfString(kEscapeCue, options:NSStringCompareOptions.BackwardsSearch)
                if (firstRange != nil) {
                    let lastIndex = context!.endIndex
                    self.stringToSearch = (context?.substringWithRange(firstRange!.startIndex.successor()..<lastIndex))!
                    self.searchEmojis(self.stringToSearch)
                }
            } else {
                if context != nil {
                    self.searchSuggestions(context!)
                } else {
                    print("That was unexpected, context is nil, here is the key output:")
                    print(keyOutput)
                }
            }
        }
    }
    
    override func backspaceDown(sender: KeyboardKey) {
        let context = self.textDocumentProxy.documentContextBeforeInput
        
        if context?.characters.last == kEscapeCue.characters.first {
            self.escapeMode = false
            self.displaySearchMode()
        }

        if escapeMode {
            let firstRange = context!.rangeOfString(kEscapeCue, options:NSStringCompareOptions.BackwardsSearch)
            if (firstRange != nil) {
                let lastIndex = context!.endIndex
                self.stringToSearch = (context?.substringWithRange(firstRange!.startIndex.successor()..<lastIndex.predecessor()))!
                self.searchEmojis(self.stringToSearch)
            }
        } else {
            if context != nil {
                let contextString: String = String(context!.characters.dropLast())
                self.searchSuggestions(contextString)
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

    func displaySearchMode() {
        if self.escapeMode {
            overlayView.hidden = false
        } else {
            overlayView.hidden = true
        }
    }
    
    func searchEmojis(string: String) {

        let emojiList: [String] = self.emojiClass.tagSearch(string) as [String]

        //Change display
        (self.bannerView as! DscribeBanner).displayEmojis(emojiList)
    }

    func searchSuggestions(contextString: String) {
        //TEST AUTOCORRECT TODO move
        let lastWord = contextString.componentsSeparatedByString(" ").last
        let rangeOfLast = NSMakeRange(contextString.characters.count - lastWord!.characters.count, lastWord!.characters.count)

        suggestions = []
        var guesses: [String]? = []
        var completion: [String]? = []

        //Contacts and stuff
        for lexiconEntry in self.appleLexicon.entries {
            if (lexiconEntry.userInput == lastWord) {
                print("Found a Lexicon Entry")
                print(lexiconEntry.documentText)
                suggestions.append(lexiconEntry.documentText)
            }
        }

        // Spelling and Autocorrect
        let misspelledRange = checker.rangeOfMisspelledWordInString(contextString, range: rangeOfLast, startingAt: 0, wrap: false, language: "en")
        if misspelledRange.location == NSNotFound {
            print("No mispelled word")
        } else {
            guesses = checker.guessesForWordRange(misspelledRange, inString: contextString, language: language) as! [String]?
        }

        completion = checker.completionsForPartialWordRange(rangeOfLast, inString: contextString, language: language) as! [String]?

        if completion != nil {
            suggestions += completion!
        }
        if guesses != nil {
            suggestions += guesses!
        }

        print("Suggestions: ")
        print(suggestions)

        (self.bannerView as! DscribeBanner).displaySuggestions(suggestions, originalString: lastWord!)
    }

    func appendEmoji(emoji: String) {
        // Uses the data passed back
        if self.escapeMode {
            let textDocumentProxy = self.textDocumentProxy as UITextDocumentProxy
            let context = textDocumentProxy.documentContextBeforeInput
            if context != nil {
                let firstRange = context!.rangeOfString(kEscapeCue, options:NSStringCompareOptions.BackwardsSearch)

                if (firstRange != nil) {
                    let lastIndex = context!.endIndex
                    let count = (firstRange!.startIndex..<lastIndex).count
                    for var i = 0; i < count; i++ {
                        textDocumentProxy.deleteBackward()
                    }
                }
            }

            self.escapeMode = false
            self.displaySearchMode()
            self.emojiClass.incrementScore(emoji)
            self.saveEmojis()
        }
        self.textDocumentProxy.insertText(emoji)
    }

    func appendSuggestion(suggestion: String) {
        // Uses the data passed back
        let textDocumentProxy = self.textDocumentProxy as UITextDocumentProxy
        let context = textDocumentProxy.documentContextBeforeInput
        let lastWord = context!.componentsSeparatedByString(" ").last

        for var i = 0; i < lastWord?.characters.count; i++ {
            textDocumentProxy.deleteBackward()
        }

        self.textDocumentProxy.insertText(suggestion)
    }

    func saveEmojis() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(emojiClass, toFile: Emoji.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save emojis...")
        }
    }

    func loadEmojis() -> Emoji? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Emoji.ArchiveURL.path!) as? Emoji
    }

    func loadSampleEmojis() {
        self.emojiClass = Emoji()
    }
}


