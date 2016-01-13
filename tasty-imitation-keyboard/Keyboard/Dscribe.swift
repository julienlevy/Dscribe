//
//  DscribeKeyboardController.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 06/11/2015.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit

let kAutoReplace = "kAutoReplace"
let kAutocorrectLanguage = "kAutocorrectLanguage"
let kEscapeCue = "|"


class Dscribe: KeyboardViewController, DscribeBannerDelegate {

    private let backgroundSearchQueue = dispatch_queue_create("julien.dscribe.photoQueue", DISPATCH_QUEUE_CONCURRENT)
    
    class var bannerColors: DscribeColors.Type { get { return DscribeColors.self }}

    let takeDebugScreenshot: Bool = false

    var escapeMode: Bool = false

    // TODO delete
    var stringToSearch: String = ""

    var overlayView: UIView = UIView()

    var emojiClass: Emoji?

    var autoReplaceActive: Bool = true
    var appleLexicon: UILexicon = UILexicon()
    var checker: UITextChecker = UITextChecker()
    var language: String = "en_US"
    var suggestions: [String] = [String]()
    var autoreplaceSuggestion: String = ""

    var selectedText: String = ""
    var fullContextBeforeChange: String = "" //Necessary to communicate between two functions

    var numberOfEnteredEmojis: Int = 0

    // MARK: UIInputViewController methods & classes
    override class var globalColors: GlobalColors.Type { get { return DscribeColors.self }}
    override class var layoutClass: KeyboardLayout.Type { get { return DscribeLayout.self }}

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // TODO review
        if let savedEmojis = loadEmojis() {
            emojiClass = savedEmojis
        } else {
            loadSampleEmojis()
        }
        
        //To change the height of the banner
        metrics = [
        "topBanner": 43
        ]

        self.requestSupplementaryLexiconWithCompletion({
            lexicon in
            self.appleLexicon = lexicon
        })

        NSUserDefaults(suiteName: "group.dscribekeyboard")!.registerDefaults([
            kAutocorrectLanguage: "en_UK",
            kAutoReplace: true,
            kSmallLowercase: true
            ])
        autoReplaceActive = NSUserDefaults(suiteName: "group.dscribekeyboard")!.boolForKey(kAutoReplace)

        if let newLanguage: String = NSUserDefaults(suiteName: "group.dscribekeyboard")!.objectForKey(kAutocorrectLanguage) as? String {
            language = newLanguage
            print("language init to " + language)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func defaultsChanged(notification: NSNotification) {
        super.defaultsChanged(notification)
        if let newLanguage: String = NSUserDefaults(suiteName: "group.dscribekeyboard")!.objectForKey(kAutocorrectLanguage) as? String {
            language = newLanguage
            print("Default changed, language is " + language)
        }
        autoReplaceActive = NSUserDefaults(suiteName: "group.dscribekeyboard")!.boolForKey(kAutoReplace)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if view.bounds == CGRectZero {
            return
        }

        self.setupBannerConstraints()

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

    // MARK: Keyboard Setup methods
    override func updateAppearances(appearanceIsDark: Bool) {
        super.updateAppearances(appearanceIsDark)
        
        (self.bannerView as? DscribeBanner)?.updateBannerColors()
    }

    override func setupKeys() {
//        super.setupKeys()
        // COPY PASTE instead of call to super not to loop through keys twice

        if self.layout == nil {
            return
        }

        for page in keyboard.pages {
            for rowKeys in page.rows { // TODO: quick hack
                for key in rowKeys {
                    if let keyView = self.layout?.viewForKey(key) {
                        keyView.removeTarget(nil, action: nil, forControlEvents: UIControlEvents.AllEvents)

                        switch key.type {
                        case Key.KeyType.KeyboardChange:
                            keyView.addTarget(self, action: "advanceTapped:", forControlEvents: .TouchUpInside)
                        case Key.KeyType.Backspace:
                            let cancelEvents: UIControlEvents = [UIControlEvents.TouchUpInside, UIControlEvents.TouchUpInside, UIControlEvents.TouchDragExit, UIControlEvents.TouchUpOutside, UIControlEvents.TouchCancel, UIControlEvents.TouchDragOutside]
                            
                            keyView.addTarget(self, action: "backspaceDown:", forControlEvents: .TouchDown)
                            keyView.addTarget(self, action: "backspaceUp:", forControlEvents: cancelEvents)
                        case Key.KeyType.Shift:
                            keyView.addTarget(self, action: Selector("shiftDown:"), forControlEvents: .TouchDown)
                            keyView.addTarget(self, action: Selector("shiftUp:"), forControlEvents: .TouchUpInside)
                            keyView.addTarget(self, action: Selector("shiftDoubleTapped:"), forControlEvents: .TouchDownRepeat)
                        case Key.KeyType.ModeChange:
                            keyView.addTarget(self, action: Selector("modeChangeTapped:"), forControlEvents: .TouchDown)
                        case Key.KeyType.Settings:
                            keyView.addTarget(self, action: Selector("toggleSettings"), forControlEvents: .TouchUpInside)
                        case Key.KeyType.SearchEmoji:
                            keyView.addTarget(self, action: Selector("searchEmojiPressed"), forControlEvents: .TouchUpInside)
                        default:
                            break
                        }

                        if key.isCharacter {
                            if UIDevice.currentDevice().userInterfaceIdiom != UIUserInterfaceIdiom.Pad {
                                keyView.addTarget(self, action: Selector("showPopup:"), forControlEvents: [.TouchDown, .TouchDragInside, .TouchDragEnter])
                                keyView.addTarget(keyView, action: Selector("hidePopup"), forControlEvents: [.TouchDragExit, .TouchCancel])
                                keyView.addTarget(self, action: Selector("hidePopupDelay:"), forControlEvents: [.TouchUpInside, .TouchUpOutside, .TouchDragOutside])
                            }
                        }

                        if key.hasOutput {
                            keyView.addTarget(self, action: "keyPressedHelper:", forControlEvents: .TouchUpInside)
                        }

                        if key.type != Key.KeyType.Shift && key.type != Key.KeyType.ModeChange {
                            keyView.addTarget(self, action: Selector("highlightKey:"), forControlEvents: [.TouchDown, .TouchDragInside, .TouchDragEnter])
                            keyView.addTarget(self, action: Selector("unHighlightKey:"), forControlEvents: [.TouchUpInside, .TouchUpOutside, .TouchDragOutside, .TouchDragExit, .TouchCancel])
                        }

                        keyView.addTarget(self, action: Selector("playKeySound"), forControlEvents: .TouchDown)
                    }
                }
            }
        }

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
        let dscribeBanner = DscribeBanner(globalColors: self.dynamicType.globalColors, bannerColors: self.dynamicType.bannerColors, darkMode: false, solidColorMode: self.solidColorMode())
        dscribeBanner.delegate = self
        return dscribeBanner
    }
    override func createSettings() -> ExtraView? {
        let settingsView = DscribeSettings(globalColors: self.dynamicType.globalColors, darkMode: false, solidColorMode: self.solidColorMode())
        settingsView.backButton?.addTarget(self, action: Selector("toggleSettings"), forControlEvents: UIControlEvents.TouchUpInside)
        return settingsView
    }

    func setupBannerConstraints() {
        self.bannerView?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(
            item: self.bannerView!, attribute: NSLayoutAttribute.Height,
            relatedBy: NSLayoutRelation.Equal,
            toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute,
            multiplier: 1, constant: metric("topBanner")))
        self.view.addConstraint(NSLayoutConstraint(
            item: self.bannerView!, attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.forwardingView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(
            item: self.bannerView!, attribute: NSLayoutAttribute.Width,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view, attribute: NSLayoutAttribute.Width,
            multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(
            item: self.bannerView!, attribute: NSLayoutAttribute.Left,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.view, attribute: NSLayoutAttribute.Left,
            multiplier: 1, constant: 0))
    }

    // MARK: TODO: define use for those methods
    func takeScreenshotDelay() {
        print("Take Screenshot Delay")
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("takeScreenshot"), userInfo: nil, repeats: false)
    }

    func takeScreenshot() {
        if !CGRectIsEmpty(self.view.bounds) {
            print("Taking screenshot")
            UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()

            let oldViewColor = self.view.backgroundColor
            print(oldViewColor)
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

    // MARK: Input Delegate to handle selected text
    // For when some text in selected (and deleted), 
    //selection functions not working, never called...
    override func selectionWillChange(textInput: UITextInput?) {
        print("SELECTION WILL change")
        print(textInput)
        print(textInputContextIdentifier)
    }
    override func selectionDidChange(textInput: UITextInput?) {
        print("SELECTION DID change")
        print(textInput)
        print(textInputContextIdentifier)
    }
    override func textWillChange(textInput: UITextInput?) {
        super.textWillChange(textInput)

        self.fullContextBeforeChange = ""
        if self.textDocumentProxy.documentContextBeforeInput != nil {
            self.fullContextBeforeChange = self.textDocumentProxy.documentContextBeforeInput!
        }
        self.fullContextBeforeChange = self.fullContextBeforeChange + self.selectedText
        if self.textDocumentProxy.documentContextAfterInput != nil {
            self.fullContextBeforeChange = self.fullContextBeforeChange + self.textDocumentProxy.documentContextAfterInput!
        }
    }
    override func textDidChange(textInput: UITextInput?) {
        super.textDidChange(textInput)

        if self.fullContextBeforeChange == "" {
            return
        }

        var fullTextAfter: String = ""
        if self.textDocumentProxy.documentContextBeforeInput != nil {
            fullTextAfter = self.textDocumentProxy.documentContextBeforeInput!
        }
        if self.textDocumentProxy.documentContextAfterInput != nil {
            fullTextAfter = fullTextAfter + self.textDocumentProxy.documentContextAfterInput!
        }

        // TODO case select is in a totally different context
        var inDifference: Bool = false
        var firstIndex: Int = 0
        var lastIndex: Int = 0
        var j: Int = 0

        for i in 0...self.fullContextBeforeChange.characters.count {
            if j >= fullTextAfter.characters.count {
                firstIndex = j
                lastIndex = self.fullContextBeforeChange.characters.count
                break
            }
            if !inDifference {
                if self.fullContextBeforeChange[self.fullContextBeforeChange.startIndex.advancedBy(i)] == fullTextAfter[fullTextAfter.startIndex.advancedBy(j)] {
                    j++
                }
                else {
                    firstIndex = i
                    inDifference = true
                }
            }
            else {
                if self.fullContextBeforeChange.substringFromIndex(self.fullContextBeforeChange.startIndex.advancedBy(i)) == fullTextAfter.substringFromIndex(fullTextAfter.startIndex.advancedBy(j)) {
                    lastIndex = i
                    inDifference = false
                    break
                }
            }
        }
        if firstIndex < lastIndex && lastIndex <= self.fullContextBeforeChange.characters.count {
            self.selectedText = self.fullContextBeforeChange.substringWithRange(Range(start: self.fullContextBeforeChange.startIndex.advancedBy(firstIndex), end: self.fullContextBeforeChange.startIndex.advancedBy(lastIndex)))
        } else {
            self.selectedText = ""
        }
        print("Selected is: \"" + self.selectedText + "\"")
    }

    // MARK: Keyboard functions (key pressed, delete, etc..)
    override func keyPressed(key: Key) {
        let keyOutput = key.outputForCase(self.shiftState.uppercase())
        if ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\"",".", ",", "?", "!", "'", " ", "\n"].contains(keyOutput) {
            if self.autoreplaceSuggestion != "" {
                self.deleteLastWordAndAppendNew(autoreplaceSuggestion)
            }
        }
        self.autoreplaceSuggestion = ""
        self.numberOfEnteredEmojis = 0
        
        self.checkAndResetSelectedText()

        if keyOutput == kEscapeCue {
//            if escapeMode {
//                self.deleteSearchText()
//            } else {
//                //TODO replace with most used emoji
//                self.searchEmojis("")
//
//                self.textDocumentProxy.insertText(keyOutput)
//            }
//
//            escapeMode = !escapeMode
//            self.displaySearchMode()
            self.textDocumentProxy.insertText(keyOutput)
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
                    self.stringToSearch = context!.substringWithRange(firstRange!.startIndex.successor()..<lastIndex)
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
        self.autoreplaceSuggestion = ""

        if self.textDocumentProxy.documentContextBeforeInput?.characters.last == kEscapeCue.characters.first {
            self.escapeMode = false
            self.displaySearchMode()
        }
        
        self.checkAndResetSelectedText()

        super.backspaceDown(sender)
    }

    override func backspaceRepeatCallback() {
        let context: String? = self.textDocumentProxy.documentContextBeforeInput
        if context != nil {
            if self.textDocumentProxy.documentContextBeforeInput?.characters.last == kEscapeCue.characters.first {
                self.escapeMode = false
                self.displaySearchMode()
            }
            if self.numberOfEnteredEmojis > 0 {
                self.numberOfEnteredEmojis--
            }
        }

        super.backspaceRepeatCallback()
    }

    override func backspaceUp(sender: KeyboardKey) {
        super.backspaceUp(sender)

        let context = self.textDocumentProxy.documentContextBeforeInput
        if context == nil {
            return
        }

        if self.escapeMode {
            let firstRange = context!.rangeOfString(kEscapeCue, options:NSStringCompareOptions.BackwardsSearch)
            if (firstRange != nil) {
                let lastIndex = context!.endIndex
                self.stringToSearch = context!.substringWithRange(firstRange!.startIndex.successor()..<lastIndex)
                self.searchEmojis(self.stringToSearch)
            }
        } else if numberOfEnteredEmojis == 0 {
            let contextString: String = String(context!.characters.dropLast())
            self.searchSuggestions(contextString, shouldAutoReplace: false)
        } else {
            self.numberOfEnteredEmojis--
        }
    }
    
    func searchEmojiPressed() {
        if escapeMode {
            self.deleteSearchText()
        } else {
            //TODO replace with most used emoji
            self.searchEmojis("")
            
            self.textDocumentProxy.insertText(kEscapeCue + " ")
        }
        
        escapeMode = !escapeMode
        self.displaySearchMode()
    }

    // MARK: text input processing tools/functions
    func deleteSearchText() {
        let context = self.textDocumentProxy.documentContextBeforeInput
        if context != nil {
            let firstRange = context!.rangeOfString(kEscapeCue, options:NSStringCompareOptions.BackwardsSearch)
            if (firstRange != nil) {
                let lastIndex = context!.endIndex
                let count = (firstRange!.startIndex..<lastIndex).count
                for var i = 0; i < count; i++ {
                    self.textDocumentProxy.deleteBackward()
                }
            }
        }
    }
    
    func deleteLastWordAndAppendNew(word: String) {
        let context = self.textDocumentProxy.documentContextBeforeInput
        if context != nil {
            let lastWord = context!.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: " \n")).last
            for var i = 0; i < lastWord?.characters.count; i++ {
                self.textDocumentProxy.deleteBackward()
            }
        }
        self.textDocumentProxy.insertText(word)
    }

    func checkAndResetSelectedText() {
        if self.selectedText != "" {
            if self.selectedText.rangeOfString(kEscapeCue) != nil {
                self.escapeMode = false
                self.displaySearchMode()
            }
            self.selectedText = ""
        }
    }

    // MARK: UI search mode
    func displaySearchMode() {
        if self.escapeMode {
            overlayView.hidden = false
        } else {
            overlayView.hidden = true
        }
    }
    
    // MARK: Calls to banner
    func searchEmojis(string: String) {
        dispatch_async(backgroundSearchQueue) {
            let emojiList: [String] = self.emojiClass!.tagSearch(string) as [String]
            dispatch_async(dispatch_get_main_queue()) {
                (self.bannerView as! DscribeBanner).displayEmojis(emojiList)
            }
        }
    }

    func searchSuggestions(contextString: String, shouldAutoReplace: Bool = true) {
        let lastWord = contextString.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: " \n")).last
        let rangeOfLast = NSMakeRange(contextString.characters.count - lastWord!.characters.count, lastWord!.characters.count)

        suggestions = []
        var guesses: [String]? = []
        var completion: [String]? = []
        var autoReplace: Bool = false

        //Contacts and stuff
        for lexiconEntry in self.appleLexicon.entries {
            if (lexiconEntry.userInput == lastWord) {
                print("Found a Lexicon Entry")
                print(lexiconEntry.documentText)
                suggestions.append(lexiconEntry.documentText)
            }
        }

        // Spelling and Autocorrect
        let misspelledRange = checker.rangeOfMisspelledWordInString(contextString, range: rangeOfLast, startingAt: 0, wrap: false, language: language)
        if misspelledRange.location != NSNotFound && shouldAutoReplace && autoReplaceActive {
            autoReplace = true
        }
        guesses = checker.guessesForWordRange(rangeOfLast, inString: contextString, language: language) as! [String]?
        completion = checker.completionsForPartialWordRange(rangeOfLast, inString: contextString, language: language) as! [String]?

        if guesses != nil {
            suggestions += guesses!
        }
        if completion != nil {
            suggestions += completion!
        }

        if autoReplace && suggestions.count > 0 {
            self.autoreplaceSuggestion = suggestions.removeFirst()
        }

        (self.bannerView as! DscribeBanner).displaySuggestions(suggestions, originalString: lastWord!, willReplaceString: self.autoreplaceSuggestion)
    }

    // MARK: Banner delegate
    func appendEmoji(emoji: String) {
        // Uses the data passed back
        if self.escapeMode {
            self.deleteSearchText()
            self.escapeMode = false
            self.displaySearchMode()
        }

        self.emojiClass!.incrementScore(emoji)
        self.saveEmojis()

        self.textDocumentProxy.insertText(emoji)
        self.numberOfEnteredEmojis++
    }

    func appendSuggestion(suggestion: String) {
        self.deleteLastWordAndAppendNew(suggestion + " ")
    }

    func refusedSuggestion() {
        let context = self.textDocumentProxy.documentContextBeforeInput
        if context != nil {
            let lastWord = context!.componentsSeparatedByCharactersInSet(NSCharacterSet(charactersInString: " \n")).last
            if !(lastWord ?? "").isEmpty {
                UITextChecker.learnWord(lastWord!)
            }
            self.autoreplaceSuggestion = ""
            self.searchSuggestions(context! + " ")
        }

        self.textDocumentProxy.insertText(" ")
    }

    // MARK: Low-level string processing
    func isEmoji(mystring: String) -> Bool {
        let characterSet: NSCharacterSet = NSCharacterSet(range: NSRange(location: 0xFE00, length: 16))
        if mystring.rangeOfCharacterFromSet(characterSet) != nil {
            return true
        }

        let high: UInt32 = UInt32((mystring as NSString).characterAtIndex(0)) // UInt16

        if (0xD800 <= high && high <= 0xDBFF) {
            let low: UInt32 = UInt32((mystring as NSString).characterAtIndex(1))

            let codepoint: Int = Int((high - 0xD800) * 0x400 + (low - 0xDC00) + 0x10000)

            return (0x1D000 <= codepoint && codepoint <= 0x1F9FF)
        }

        return false
    }

    // MARK: Access to memory
    func saveEmojis() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(emojiClass!, toFile: Emoji.ArchiveURL.path!)
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


