//
//  DscribeKeyboardController.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 06/11/2015.
//  Copyright © 2015 Apple. All rights reserved.
//

import UIKit
//import Mixpanel

let kAutoReplace = "kAutoReplace"
let kAutocorrectLanguage = "kAutocorrectLanguage"
let kEscapeCue = "|"
let kKeyboardType = "kKeyboardType"

let kAZERTY = "AZERTY"
let kQWERTY = "QWERTY"
let kAccentedAZERTY = "Accented AZERTY"


class Dscribe: KeyboardViewController, DscribeBannerDelegate {

    fileprivate let backgroundSearchQueue = DispatchQueue(label: "julien.dscribe.photoQueue", attributes: DispatchQueue.Attributes.concurrent)

    class var bannerColors: DscribeColors.Type { get { return DscribeColors.self }}

    var keyboardType: String = kQWERTY

    let takeDebugScreenshot: Bool = false

    var escapeMode: Bool = false
    var searchEmojiKey: KeyboardKey?
    var accentKey: KeyboardKey?
    var accentKeyModel: Key?


    var overlayView: UIView = UIView()

    var emojiClass: Emoji?

    var autoReplaceActive: Bool = true
    var appleLexicon: UILexicon = UILexicon()
    var language: String = "en_US"
    var autoreplaceSuggestion: String = ""

    var selectedText: String = ""
    var fullContextBeforeChange: String = "" //Necessary to communicate between two functions

    var numberOfEnteredEmojis: Int = 0
    var wordBeforeReplace: String = ""


    // MARK: UIInputViewController methods & classes
    override class var globalColors: GlobalColors.Type { get { return DscribeColors.self }}
    override class var layoutClass: KeyboardLayout.Type { get { return DscribeLayout.self }}

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        //To change the height of the banner
        metrics = [
        "topBanner": 43
        ]

        // TODO: move to search
        self.requestSupplementaryLexicon(completion: {
            lexicon in
            self.appleLexicon = lexicon
        })

        UserDefaults(suiteName: "group.dscribekeyboard")!.register(defaults: [
            kAutocorrectLanguage: language,
            kAutoReplace: true,
            kSmallLowercase: true,
            kKeyboardType: kQWERTY
            ])
        self.autoReplaceActive = UserDefaults(suiteName: "group.dscribekeyboard")!.bool(forKey: kAutoReplace)
        if let newType: String = UserDefaults(suiteName: "group.dscribekeyboard")!.object(forKey: kKeyboardType) as? String {
            keyboardType = newType
        }
        if let newLanguage: String = UserDefaults(suiteName: "group.dscribekeyboard")!.object(forKey: kAutocorrectLanguage) as? String {
            language = newLanguage
        }

//        Mixpanel.sharedInstanceWithToken("2251f78e023ae81fc07ba7b3234cfc23")

        // TODO: refacto and improve performances
        UserDefaults.standard.register(defaults: ["version_1.1_emojis_updated": false])
        if UserDefaults.standard.bool(forKey: "version_1.1_emojis_updated") {
            if let savedEmojis = self.loadEmojis() {
                self.emojiClass = savedEmojis
            } else {
                self.loadSampleEmojis()
            }
        } else {
            UserDefaults.standard.set(true, forKey: "version_1.1_emojis_updated")
            self.loadSampleEmojis()
            self.saveEmojis()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func defaultsChanged(_ notification: Notification) {
        super.defaultsChanged(notification)
        if let newLanguage = UserDefaults(suiteName: "group.dscribekeyboard")!.object(forKey: kAutocorrectLanguage) as? String {
            self.language = newLanguage

            if let languageCode = language.components(separatedBy: "_").first {
                self.changeKeyLanguages("space".translation(languageCode), returnText: "return".translation(languageCode))
            }
            print("Default changed, language is " + language)
        }
        self.autoReplaceActive = UserDefaults(suiteName: "group.dscribekeyboard")!.bool(forKey: kAutoReplace)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if view.bounds == CGRect.zero {
            return
        }

        self.setupBannerConstraints()

        // TODO: call this in a more appropriate place: viewDidLayoutSubviews is called everytime a key is hit
        if overlayView.frame == CGRect.zero {
            overlayView.backgroundColor = UIColor.black//(red: 250.0/255, green: 193.0/255, blue: 62.0/255, alpha: 1.0)
            overlayView.alpha = 0.2
            overlayView.frame = self.view.frame
            overlayView.isUserInteractionEnabled = false
            overlayView.isHidden = true
            self.view.insertSubview(overlayView, at: 0)
            self.setupOverlayConstraints()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

//        Mixpanel.sharedInstance().track("Keyboard appears")
    }

    // MARK: Keyboard Setup methods
    override func updateAppearances(_ appearanceIsDark: Bool) {
        super.updateAppearances(appearanceIsDark)

        (self.bannerView as? DscribeBanner)?.updateBannerColors()
    }

    override func setupKeys() {

        if self.layout == nil {
            return
        }

        for page in keyboard.pages {
            for rowKeys in page.rows { // TODO: quick hack
                for key in rowKeys {
                    if let keyView = self.layout?.viewForKey(key) {
                        keyView.removeTarget(nil, action: nil, for: UIControlEvents.allEvents)

                        switch key.type {
                        case Key.KeyType.keyboardChange:
                            keyView.addTarget(self, action: #selector(KeyboardViewController.advanceTapped(_:)), for: .touchUpInside)
                        case Key.KeyType.backspace:
                            let cancelEvents: UIControlEvents = [UIControlEvents.touchUpInside, UIControlEvents.touchUpInside, UIControlEvents.touchDragExit, UIControlEvents.touchUpOutside, UIControlEvents.touchCancel, UIControlEvents.touchDragOutside]

                            keyView.addTarget(self, action: #selector(KeyboardViewController.backspaceDown(_:)), for: .touchDown)
                            keyView.addTarget(self, action: #selector(KeyboardViewController.backspaceUp(_:)), for: cancelEvents)
                        case Key.KeyType.shift:
                            keyView.addTarget(self, action: #selector(KeyboardViewController.shiftDown(_:)), for: .touchDown)
                            keyView.addTarget(self, action: #selector(KeyboardViewController.shiftUp(_:)), for: .touchUpInside)
                            keyView.addTarget(self, action: #selector(KeyboardViewController.shiftDoubleTapped(_:)), for: .touchDownRepeat)
                        case Key.KeyType.modeChange:
                            keyView.addTarget(self, action: #selector(KeyboardViewController.modeChangeTapped(_:)), for: .touchDown)
                        case Key.KeyType.settings:
                            keyView.addTarget(self, action: #selector(KeyboardViewController.toggleSettings), for: .touchUpInside)
                            keyView.addTarget(self, action: #selector(Dscribe.askedToOpenSettings), for: .touchUpInside)
                        case Key.KeyType.searchEmoji:
                            keyView.addTarget(self, action: #selector(Dscribe.searchEmojiPressed(_:)), for: .touchUpInside)
                        case Key.KeyType.accentCharacter:
                            keyView.addTarget(self, action: #selector(Dscribe.accentPressed(_:)), for: .touchUpInside)
                            self.accentKeyModel = key
                            self.accentKey = keyView
                        default:
                            break
                        }

                        if key.isCharacter || key.type == Key.KeyType.accentCharacter {
                            if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.pad {
                                keyView.addTarget(self, action: #selector(KeyboardViewController.showPopup(_:)), for: [.touchDown, .touchDragInside, .touchDragEnter])
                                keyView.addTarget(keyView, action: #selector(KeyboardKey.hidePopup), for: [.touchDragExit, .touchCancel])
                                keyView.addTarget(self, action: #selector(KeyboardViewController.hidePopupDelay(_:)), for: [.touchUpInside, .touchUpOutside, .touchDragOutside])
                            }
                        }

                        if key.hasOutput && key.type != Key.KeyType.accentCharacter {
                            keyView.addTarget(self, action: #selector(KeyboardViewController.keyPressedHelper(_:)), for: .touchUpInside)
                        }

                        if key.type != Key.KeyType.shift && key.type != Key.KeyType.modeChange {
                            keyView.addTarget(self, action: #selector(KeyboardViewController.highlightKey(_:)), for: [.touchDown, .touchDragInside, .touchDragEnter])
                            keyView.addTarget(self, action: #selector(KeyboardViewController.unHighlightKey(_:)), for: [.touchUpInside, .touchUpOutside, .touchDragOutside, .touchDragExit, .touchCancel])
                        }

                        keyView.addTarget(self, action: #selector(KeyboardViewController.playKeySound), for: .touchDown)
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
                            keyView.addTarget(self, action: #selector(Dscribe.takeScreenshotDelay), for: .touchDown)
                        }
                    }
                }
            }
        }
    }

    override func createBanner() -> ExtraView? {
        let dscribeBanner = DscribeBanner(globalColors: type(of: self).globalColors, bannerColors: type(of: self).bannerColors, darkMode: false, solidColorMode: self.solidColorMode())
        dscribeBanner.delegate = self
        return dscribeBanner
    }
    override func createSettings() -> ExtraView? {
        let settingsView = DscribeSettings(globalColors: type(of: self).globalColors, darkMode: false, solidColorMode: self.solidColorMode())
        settingsView.backButton?.addTarget(self, action: Selector("toggleSettings"), for: UIControlEvents.touchUpInside)
        settingsView.backButton?.addTarget(self, action: #selector(Dscribe.backFromSettings), for: UIControlEvents.touchUpInside)
        return settingsView
    }

    func setupBannerConstraints() {
        self.bannerView?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(
            item: self.bannerView!, attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: nil, attribute: NSLayoutAttribute.notAnAttribute,
            multiplier: 1, constant: metric("topBanner")))
        self.view.addConstraint(NSLayoutConstraint(
            item: self.bannerView!, attribute: NSLayoutAttribute.bottom,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.forwardingView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(
            item: self.bannerView!, attribute: NSLayoutAttribute.width,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.view, attribute: NSLayoutAttribute.width,
            multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(
            item: self.bannerView!, attribute: NSLayoutAttribute.left,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.view, attribute: NSLayoutAttribute.left,
            multiplier: 1, constant: 0))
    }
    func setupOverlayConstraints() {
        self.overlayView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraint(NSLayoutConstraint(
            item: self.overlayView, attribute: NSLayoutAttribute.height,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.forwardingView, attribute: NSLayoutAttribute.height,
            multiplier: 1, constant: metric("topBanner")))
        self.view.addConstraint(NSLayoutConstraint(
            item: self.overlayView, attribute: NSLayoutAttribute.top,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.forwardingView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: -metric("topBanner")))
        self.view.addConstraint(NSLayoutConstraint(
            item: self.overlayView, attribute: NSLayoutAttribute.width,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.view, attribute: NSLayoutAttribute.width,
            multiplier: 1, constant: 0))
        self.view.addConstraint(NSLayoutConstraint(
            item: self.overlayView, attribute: NSLayoutAttribute.left,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.view, attribute: NSLayoutAttribute.left,
            multiplier: 1, constant: 0))
    }

    func switchKeyboard() {
        print("Changing keyboard")
        if keyboardType == kAZERTY {
            self.keyboard = azertyKeyboard()
        } else if keyboardType == kQWERTY {
            self.keyboard = defaultKeyboard()
        } else if keyboardType == kAccentedAZERTY {
            self.keyboard = accentedAZERTYKeyboard()
        } else {
            return
        }

        for subview in forwardingView.subviews {
            subview.removeFromSuperview()
        }
        self.constraintsAdded = false
        self.setupLayout()

        self.forwardingView.resetTrackedViews()
        self.shiftStartingState = nil
        self.shiftWasMultitapped = false

        let uppercase = self.shiftState.uppercase()
        let characterUppercase = (UserDefaults(suiteName: "group.dscribekeyboard")!.bool(forKey: kSmallLowercase) ? uppercase : true)
        self.layout?.layoutKeys(0, uppercase: uppercase, characterUppercase: characterUppercase, shiftState: self.shiftState)
        self.setupKeys()

        self.currentMode = 0 //Otherwise change mode button won't work because keyboard would still be considered on mode 1
    }
    func checkKeyboardType() {
        if let typeSetting = UserDefaults(suiteName: "group.dscribekeyboard")!.object(forKey: kKeyboardType) as? String {
            if typeSetting != "" && typeSetting != keyboardType {
                self.keyboardType = typeSetting
                self.switchKeyboard()
            }
        }
    }

    func changeKeyLanguages(_ spaceText: String, returnText: String) {
        for page in keyboard.pages {
            for rowKeys in page.rows {
                for key in rowKeys {
                    if key.type == Key.KeyType.space {
                        key.uppercaseKeyCap = spaceText
                        if let keyboardKey = self.layout?.modelToView[key] {
                            keyboardKey.text = spaceText
                        }
                    } else if key.type == Key.KeyType.return {
                        key.uppercaseKeyCap = returnText
                        if let keyboardKey = self.layout?.modelToView[key] {
                            keyboardKey.text = returnText
                        }
                    }
                }
            }
        }
    }

    // MARK: TODO: define use for those methods
    func takeScreenshotDelay() {
        print("Take Screenshot Delay")
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(Dscribe.takeScreenshot), userInfo: nil, repeats: false)
    }

    func takeScreenshot() {
        if !self.view.bounds.isEmpty {
            print("Taking screenshot")
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()

            let oldViewColor = self.view.backgroundColor
            self.view.backgroundColor = UIColor(hue: (216/360.0), saturation: 0.05, brightness: 0.86, alpha: 1)

            let rect = self.view.bounds
            UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
            self.view.drawHierarchy(in: self.view.bounds, afterScreenUpdates: true)
            let capturedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let name = (self.interfaceOrientation.isPortrait ? "Screenshot-Portrait" : "Screenshot-Landscape")
            let imagePath = "/Users/archagon/Documents/Programming/OSX/RussianPhoneticKeyboard/External/tasty-imitation-keyboard/\(name).png"
            try? UIImagePNGRepresentation(capturedImage!)!.write(to: URL(fileURLWithPath: imagePath), options: [.atomic])

            self.view.backgroundColor = oldViewColor
        }
    }

    // MARK: Input Delegate to handle selected text
    // For when some text in selected (and deleted), 
    //selection functions not working, never called...
    override func selectionWillChange(_ textInput: UITextInput?) {
        print("SELECTION WILL change")
        print(textInput ?? "Text input was nil")
        print(textInputContextIdentifier ?? "Text input context id was nil")
    }
    override func selectionDidChange(_ textInput: UITextInput?) {
        print("SELECTION DID change")
        print(textInput ?? "Text input was nil")
        print(textInputContextIdentifier ?? "Text input context id was nil")
    }
    override func textWillChange(_ textInput: UITextInput?) {
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
    override func textDidChange(_ textInput: UITextInput?) {
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

        // TODO case selection is in a totally different context
        var inDifference: Bool = false
        var firstIndex: Int = 0
        var lastIndex: Int = 0
        var j: Int = 0

        for i in 0..<self.fullContextBeforeChange.characters.count {
            if j >= fullTextAfter.characters.count {
                firstIndex = j
                lastIndex = self.fullContextBeforeChange.characters.count
                break
            }
            if !inDifference {
                if self.fullContextBeforeChange[self.fullContextBeforeChange.characters.index(self.fullContextBeforeChange.startIndex, offsetBy: i)] == fullTextAfter[fullTextAfter.characters.index(fullTextAfter.startIndex, offsetBy: j)] {
                    j += 1
                } else {
                    firstIndex = i
                    inDifference = true
                }
            } else {
                if self.fullContextBeforeChange.substring(from: self.fullContextBeforeChange.characters.index(self.fullContextBeforeChange.startIndex, offsetBy: i)) == fullTextAfter.substring(from: fullTextAfter.characters.index(fullTextAfter.startIndex, offsetBy: j)) {
                    lastIndex = i
                    inDifference = false
                    break
                }
            }
        }
        if firstIndex < lastIndex && lastIndex <= self.fullContextBeforeChange.characters.count {
            self.selectedText = self.fullContextBeforeChange.substring(with: (self.fullContextBeforeChange.characters.index(self.fullContextBeforeChange.startIndex, offsetBy: firstIndex) ..< self.fullContextBeforeChange.characters.index(self.fullContextBeforeChange.startIndex, offsetBy: lastIndex)))
        } else {
            self.selectedText = ""
        }
        print("Selected is: \"" + self.selectedText + "\"")
    }

    // MARK: Keyboard functions (key pressed, delete, etc..)
    override func keyPressed(_ key: Key) {
        let keyOutput = key.outputForCase(self.shiftState.uppercase())
        if ["-", "/", ":", ";", "(", ")", "$", "&", "@", "\"",".", ",", "?", "!", "'", " ", "\n"].contains(keyOutput) {
            if self.autoreplaceSuggestion != "" {
                self.deleteLastWordAndAppendNew(autoreplaceSuggestion)
            }
        }
        self.autoreplaceSuggestion = ""
        self.numberOfEnteredEmojis = 0

        self.checkAndResetSelectedText()

        self.textDocumentProxy.insertText(keyOutput)

        let context = self.textDocumentProxy.documentContextBeforeInput

//        if let keyCharacter = keyOutput.characters.first {
//            self.updateAccentKey(keyCharacter)
//        }
        if let certainContext = context {
            let length = certainContext.characters.count
            if length > 2 {
                let lastCharacters = certainContext.substring(from: certainContext.characters.index(certainContext.startIndex, offsetBy: certainContext.characters.count - 2))
                self.updateAccentKey(lastCharacters)
            } else {
                self.updateAccentKey(keyOutput)
            }
        }


        if escapeMode {
            if keyOutput == "\n" {
                self.toggleSearchMode()
                return
            }
            let firstRange = context?.range(of: kEscapeCue, options:NSString.CompareOptions.backwards)
            if firstRange != nil {
                let lastIndex = context!.endIndex
                //FIXME
                let stringToSearch = context!.substring(with: context!.index(after: firstRange!.lowerBound)..<lastIndex)
                self.searchEmojis(stringToSearch)
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

    override func backspaceDown(_ sender: KeyboardKey) {
        self.autoreplaceSuggestion = ""

        if self.textDocumentProxy.documentContextBeforeInput?.characters.last == kEscapeCue.characters.first {
            if self.escapeMode {
                self.toggleSearchMode()
            }
        }

        self.checkAndResetSelectedText()

        super.backspaceDown(sender)
    }

    override func backspaceRepeatCallback() {
        let context: String? = self.textDocumentProxy.documentContextBeforeInput
        if context != nil {
            if self.textDocumentProxy.documentContextBeforeInput?.characters.last == kEscapeCue.characters.first {
                if self.escapeMode {
                    self.toggleSearchMode()
                }
            }
            if self.numberOfEnteredEmojis > 0 {
                self.numberOfEnteredEmojis -= 1
            }
        }

        super.backspaceRepeatCallback()
    }

    override func backspaceUp(_ sender: KeyboardKey) {
        super.backspaceUp(sender)

        let context = self.textDocumentProxy.documentContextBeforeInput
        if context == nil {
            return
        }

        if self.escapeMode {
            let firstRange = context!.range(of: kEscapeCue, options:NSString.CompareOptions.backwards)
            if firstRange != nil {
                let lastIndex = context!.endIndex
                // FIXME
                let stringToSearch = context!.substring(with: context!.index(after: firstRange!.lowerBound)..<lastIndex)
                self.searchEmojis(stringToSearch)
            }
        } else if numberOfEnteredEmojis == 0 {
            if let lastCharacter = context?.characters.last {
                self.updateAccentKey(String(lastCharacter))
            }
            self.searchSuggestions(context!, shouldAutoReplace: false, showFormerWord: true)
        } else {
            self.numberOfEnteredEmojis -= 1
        }
    }

    func updateAccentKey(_ lastLetter: String) {
        if let keyModel = self.accentKeyModel {
            if let languageCode = language.components(separatedBy: "_").first {
                let accent = accentAfterCharacter(lastLetter, withLanguage: languageCode)
                keyModel.setLetter(accent)
                self.accentKey?.text = accent
            }
        }
    }
    func accentPressed(_ sender: KeyboardKey) {
        self.textDocumentProxy.insertText(sender.text)

        if let keyModel = self.accentKeyModel {
            keyModel.setLetter("'")
            if let key = self.accentKey {
                key.text = "'"
            }
        }
    }

    func searchEmojiPressed(_ sender: KeyboardKey) {
        if self.searchEmojiKey == nil {
            self.searchEmojiKey = sender
        }
        if escapeMode {
            _ = self.deleteSearchText()
        } else {
            self.searchEmojis("")

            self.textDocumentProxy.insertText(kEscapeCue + " ")
        }
        self.toggleSearchMode()
    }

    func toggleSearchMode() {
        escapeMode = !escapeMode
        self.displaySearchMode()
        (self.layout as? DscribeLayout)?.inSearchMode = escapeMode

        if self.searchEmojiKey != nil {
            if let keyModel = self.layout?.viewToModel[self.searchEmojiKey!] {
                self.layout?.updateKeyCap(self.searchEmojiKey!, model: keyModel, fullReset: true, uppercase: false, characterUppercase: false, shiftState: self.shiftState)
                self.layout?.setAppearanceForKey(self.searchEmojiKey!, model: keyModel, darkMode: self.darkMode(), solidColorMode: self.solidColorMode())
            }
        }
    }

    func askedToOpenSettings() {
//        Mixpanel.sharedInstance().track("Keyboard Settings")
    }

    // MARK: text input processing tools/functions
    func deleteSearchText() -> String {
        var search: String = ""

        if let context = self.textDocumentProxy.documentContextBeforeInput {

            if let firstRange = context.range(of: kEscapeCue, options:NSString.CompareOptions.backwards) {
                search = context.substring(from: firstRange.lowerBound)

                let lastIndex = context.endIndex
                let count = context.distance(from: firstRange.lowerBound, to: lastIndex)
                for _ in 0 ..< count {
                    self.textDocumentProxy.deleteBackward()
                }
            }
        }
        return search
    }

    func deleteLastWordAndAppendNew(_ word: String) {
        let context = self.textDocumentProxy.documentContextBeforeInput
        if context != nil {
            if let lastWord = context!.components(separatedBy: CharacterSet(charactersIn: " \n")).last {
                for _ in 0 ..< lastWord.characters.count {
                    self.textDocumentProxy.deleteBackward()
                }
            }
        }
        self.textDocumentProxy.insertText(word)
    }

    func checkAndResetSelectedText() {
        if self.selectedText != "" {
            if self.selectedText.range(of: kEscapeCue) != nil {
                if self.escapeMode {
                    self.toggleSearchMode()
                }
            }
            self.selectedText = ""
        }
    }

    // MARK: UI search mode
    func displaySearchMode() {
        if self.escapeMode {
            overlayView.isHidden = false
        } else {
            overlayView.isHidden = true
        }
    }

    // MARK: Calls to banner
    func searchEmojis(_ string: String) {
        backgroundSearchQueue.async {
            let emojiList: [String] = self.emojiClass!.tagSearch(string) as [String]
            DispatchQueue.main.async {
                (self.bannerView as! DscribeBanner).displayEmojis(emojiList)
            }
        }
    }

    func searchSuggestions(_ contextString: String, shouldAutoReplace: Bool = true, showFormerWord: Bool = false) {
        var lastWord = contextString.components(separatedBy: CharacterSet(charactersIn: " \n")).last
        let rangeOfLast = NSMakeRange(contextString.characters.count - lastWord!.characters.count, lastWord!.characters.count)

        let checker: UITextChecker = UITextChecker()
        var suggestions: [String] = [String]()
        var guesses: [String]? = []
        var completion: [String]? = []
        var autoReplace: Bool = false

        if showFormerWord && lastWord!.characters.count > 1 {
            lastWord = self.wordBeforeReplace
        } else if lastWord! != "" {
            self.wordBeforeReplace = lastWord!
        }

        //Contacts and stuff
        for lexiconEntry in self.appleLexicon.entries {
            if lexiconEntry.userInput == lastWord {
                print("Found a Lexicon Entry")
                print(lexiconEntry.documentText)
                suggestions.append(lexiconEntry.documentText)
            }
        }

        // Spelling and Autocorrect
        let misspelledRange = checker.rangeOfMisspelledWord(in: contextString, range: rangeOfLast, startingAt: 0, wrap: false, language: language)
        if misspelledRange.location != NSNotFound && shouldAutoReplace && autoReplaceActive {
            autoReplace = true
        }
        guesses = checker.guesses(forWordRange: rangeOfLast, in: contextString, language: language) 
        completion = checker.completions(forPartialWordRange: rangeOfLast, in: contextString, language: language) 

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

    // MARK: Back from settings, in addition to IBAction toggleSetttings
    func backFromSettings() {
        if let settings = self.settingsView as? DscribeSettings {
            // Can't use hidden because two events fired at the same time
            let language: String = settings.currentPickerLanguage
            if language != "" {
                settings.saveLanguage(language)
            }
            let typeSetting: String = settings.currentPickerType
            if typeSetting != "" {
                settings.saveKeyboardType(typeSetting)
                self.checkKeyboardType()
            }
        }
    }
    // MARK: Banner delegate
    func appendEmoji(_ emoji: String) {
        // Uses the data passed back
        if self.escapeMode {
            self.toggleSearchMode()

//            let searched: String =
            _ = self.deleteSearchText()
//            Mixpanel.sharedInstance().track("Emoji", properties: ["emoji" : emoji, "search": searched])
//        } else {
//            Mixpanel.sharedInstance().track("Emoji", properties: ["emoji" : emoji, "search": "n°" + String(self.numberOfEnteredEmojis + 1)])
        }

        _ = self.emojiClass!.incrementScore(emoji)
        _ = self.saveEmojis()

        self.textDocumentProxy.insertText(emoji)
        self.numberOfEnteredEmojis += 1
    }

    func appendSuggestion(_ suggestion: String) {
        self.deleteLastWordAndAppendNew(suggestion + " ")
        self.autoreplaceSuggestion = ""
        (self.bannerView as! DscribeBanner).removeSpecialSuggestionColor()
    }

    func refusedSuggestion() {
        let context = self.textDocumentProxy.documentContextBeforeInput
        if context != nil {
            var lastWord = context!.components(separatedBy: CharacterSet(charactersIn: " \n")).last
            if lastWord! != self.wordBeforeReplace {
                lastWord = self.wordBeforeReplace
                self.deleteLastWordAndAppendNew(lastWord!)
            }
            if !(lastWord ?? "").isEmpty {
                UITextChecker.learnWord(lastWord!)
            }
            self.autoreplaceSuggestion = ""
            self.searchSuggestions(context! + " ")
        }

        self.textDocumentProxy.insertText(" ")
    }

    // MARK: Low-level string processing
    func isEmoji(_ mystring: String) -> Bool {
        // FIXME, should be optional as checking Variation Selector 1-16 character but not sure
//        let characterSet: CharacterSet = CharacterSet(range: NSRange(location: 0xFE00, length: 16))
//        if mystring.rangeOfCharacter(from: characterSet) != nil {
//            return true
//        }

        let high: UInt32 = UInt32((mystring as NSString).character(at: 0)) // UInt16

        if 0xD800 <= high && high <= 0xDBFF {
            let low: UInt32 = UInt32((mystring as NSString).character(at: 1))

            let codepoint: Int = Int((high - 0xD800) * 0x400 + (low - 0xDC00) + 0x10000)

            return (0x1D000 <= codepoint && codepoint <= 0x1F9FF)
        }

        return false
    }

    // MARK: Access to memory
    func saveEmojis() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(emojiClass!, toFile: Emoji.ArchiveURL.path)
        if !isSuccessfulSave {
            print("Failed to save emojis...")
        }
    }

    func loadEmojis() -> Emoji? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Emoji.ArchiveURL.path) as? Emoji
    }

    func loadSampleEmojis() {
        self.emojiClass = Emoji()
    }
}
