//
//  DscribeBanner.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 06/11/2015.
//  Copyright © 2015 Apple. All rights reserved.
//


import UIKit

/*
This is the demo banner. The banner is needed so that the top row popups have somewhere to go. Might as well fill it
with something (or leave it blank if you like.)
*/

protocol DscribeBannerDelegate {
    func appendEmoji(emoji: String)
    func appendSuggestion(suggestion: String)
    func refusedSuggestion()
}

class DscribeBanner: ExtraView {
    var delegate: DscribeBannerDelegate?
    
    var scrollView: UIScrollView = UIScrollView()
    var buttons: NSMutableArray = NSMutableArray()
    var wbefore: CGFloat = CGFloat()
    var wAfter: CGFloat = CGFloat()

    var beforeScrollView: UIView = UIView()
    var afterScrollView: UIView = UIView()

    var suggestionBackgroundColor: UIColor?
    var selectedSuggestionBackgroungColor: UIColor?
    
    var bannerColors: DscribeColors.Type?
    
    let space: CGFloat = 0.8

    required init(globalColors: GlobalColors.Type?, bannerColors: DscribeColors.Type?, darkMode: Bool, solidColorMode: Bool) {
        super.init(globalColors: globalColors, darkMode: darkMode, solidColorMode: solidColorMode)
        self.bannerColors = bannerColors

        suggestionBackgroundColor = self.globalColors?.specialKey(self.darkMode, solidColorMode: self.solidColorMode)
        selectedSuggestionBackgroungColor = self.bannerColors?.selectedSuggestionBackground(self.darkMode, solidColorMode: self.solidColorMode)
    }
 
    required init(globalColors: GlobalColors.Type?, darkMode: Bool, solidColorMode: Bool) {
        super.init(globalColors: globalColors, darkMode: darkMode, solidColorMode: solidColorMode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func setNeedsLayout() {
        super.setNeedsLayout()
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.backgroundColor = UIColor.clearColor()

        print("layout subviews")
        //TODO refacto
        self.scrollView.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        self.scrollView.contentSize = CGSizeMake(140, 600)
        self.scrollView.scrollEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(self.scrollView)

        self.beforeScrollView.frame = CGRectMake( -self.frame.width, space, self.frame.width, self.frame.height)
        self.scrollView.addSubview(self.beforeScrollView)

        //Frame defined at the end of displayEmojis function
        self.scrollView.addSubview(self.afterScrollView)
        
        self.displaySuggestions([], originalString: "")
        self.updateBannerColors()
    }
    
    func updateBannerColors() {
        let emojiBackgroundColor: UIColor? = self.globalColors?.regularKey(self.darkMode, solidColorMode: self.solidColorMode)
        suggestionBackgroundColor = self.globalColors?.specialKey(self.darkMode, solidColorMode: self.solidColorMode)
        selectedSuggestionBackgroungColor = self.bannerColors?.selectedSuggestionBackground(self.darkMode, solidColorMode: self.solidColorMode)
        let selectedTextColor: UIColor? = self.bannerColors?.selectedTextColor(self.darkMode)

        self.beforeScrollView.backgroundColor = emojiBackgroundColor
        self.afterScrollView.backgroundColor = emojiBackgroundColor
        for subview in self.scrollView.subviews {
            if subview is UIButton {
                let button = subview as! UIButton
                if button.tag == 1 { //Normal suggestion
                    button.backgroundColor = suggestionBackgroundColor
                    button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
                }
                else if subview.tag == 2 { //Will Replace suggestion
                    button.backgroundColor = selectedSuggestionBackgroungColor
                    button.setTitleColor(selectedTextColor, forState: [UIControlState.Normal, UIControlState.Highlighted])
                    button.setTitleColor(selectedTextColor, forState: .Normal)
                }
                else if subview.tag == 3 { //Emoji
                    button.backgroundColor = emojiBackgroundColor
                }
            }
        }
    }
    
    func emojiSelected(sender: UIButton!) {
        delegate?.appendEmoji((sender.titleLabel?.text)!)
    }

    func suggestionSelected(sender: UIButton!) {
        delegate?.appendSuggestion((sender.titleLabel?.text)!)
    }
    
    func alreadyTypedWord(sender: UIButton!) {
        delegate?.refusedSuggestion()
    }

    func displayEmojis(emojiList: [String], stringToSearch: String = "") {
        let numberEmoji: Int = emojiList.count

        if numberEmoji == 0 {
            return
        }

        self.removeAllButtonsFromScrollView()
        self.beforeScrollView.hidden = false
        self.afterScrollView.hidden = false
        
        var xOrigin: CGFloat = 0
        var width: CGFloat = 80
        var lastButton:UIButton = UIButton()

        scrollView.scrollEnabled = true
        
        if numberEmoji <= 4 {
            width = (self.frame.width) / CGFloat(numberEmoji)
            scrollView.scrollEnabled = false
        }
        
        
        var count: Int = 0
        for emoji in emojiList {
            count++
            if count > 15 {
                break
            }
            let button: UIButton = UIButton()
            button.frame = CGRectMake(xOrigin, space / 2, width, self.frame.height + 1)
            button.setTitle(emoji, forState: UIControlState.Normal)
            button.addTarget(self, action: Selector("emojiSelected:"), forControlEvents: UIControlEvents.TouchUpInside);
            button.titleLabel?.font = button.titleLabel?.font.fontWithSize(22)
            button.tag = 3
            
            xOrigin += width + 1
            
            self.scrollView.addSubview(button)
            
            lastButton = button
        }
        self.scrollView.contentSize.width = lastButton.frame.origin.x + lastButton.frame.width
        self.scrollView.contentSize.height = self.frame.height

        self.afterScrollView.frame = CGRectMake( self.scrollView.contentSize.width - 1, space, self.frame.width, self.frame.height)

        self.updateBannerColors()
    }

    func displaySuggestions(var suggestionList: [String], originalString: String, willReplaceString: String = "") {
        if willReplaceString != "" {
            suggestionList.insert(willReplaceString, atIndex: 0)
        }
        suggestionList.insert(originalString, atIndex: 0)

        self.removeAllButtonsFromScrollView()
        self.beforeScrollView.hidden = true
        self.afterScrollView.hidden = true

//        let numberSuggestion: Int = suggestionList.count
//        let width: CGFloat = ((self.frame.width - CGFloat(min(3, numberSuggestion) - 1) * space) / CGFloat(min(3, numberSuggestion)))
        let width: CGFloat = ((self.frame.width - CGFloat(2) * space) / CGFloat(3))
        scrollView.scrollEnabled = false
        scrollView.setContentOffset(CGPointZero, animated: false)

        for (var index = 0; index < 3; index++) {
            let button: UIButton = UIButton()
            button.layer.borderWidth = 0.4
            button.layer.borderColor = UIColor.clearColor().CGColor
            button.frame = CGRectMake(CGFloat(index) * (width + space), 0, width, self.frame.height)
            button.tag = 1;
            button.addTarget(self, action: Selector("cancelHighlight:"), forControlEvents: [UIControlEvents.TouchUpInside, UIControlEvents.TouchDragExit, UIControlEvents.TouchUpOutside, UIControlEvents.TouchCancel, UIControlEvents.TouchDragOutside])
            button.addTarget(self, action: Selector("highlightButton:"), forControlEvents: [.TouchDown, .TouchDragInside])

            if suggestionList.count > index {
                var suggestion: String = ""
                suggestion = suggestionList[index]
                if index == 0 {
                    button.setTitle("\"" + suggestion + "\"", forState: UIControlState.Normal)
                    button.addTarget(self, action: Selector("alreadyTypedWord:"), forControlEvents: UIControlEvents.TouchUpInside);
                } else {
                    button.setTitle(suggestion, forState: UIControlState.Normal)
                    button.addTarget(self, action: Selector("suggestionSelected:"), forControlEvents: UIControlEvents.TouchUpInside);
                    if index == 1 && willReplaceString != "" {
                        button.tag = 2
                    }
                }
            }

            self.scrollView.addSubview(button)
        }

        self.updateBannerColors()
    }

    func removeAllButtonsFromScrollView() {
        for subview in self.scrollView.subviews {
            if subview is UIButton {
                subview.removeFromSuperview()
            }
        }
    }
    func highlightButton(sender: UIButton) {
        sender.backgroundColor = selectedSuggestionBackgroungColor
    }
    func cancelHighlight(sender: UIButton) {
        if sender.tag == 1 {
            sender.backgroundColor = suggestionBackgroundColor
        }
    }
}
