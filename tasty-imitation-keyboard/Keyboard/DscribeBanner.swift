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

    var emojiBackgroundColor: UIColor?
    var suggestionBackgroundColor: UIColor?
    
    let space: CGFloat = 0.8


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

        emojiBackgroundColor = self.globalColors?.regularKey(self.darkMode, solidColorMode: self.solidColorMode)
        suggestionBackgroundColor = self.globalColors?.specialKey(self.darkMode, solidColorMode: self.solidColorMode)

        self.scrollView.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        self.scrollView.contentSize = CGSizeMake(140, 600)
        self.scrollView.scrollEnabled = true
        self.addSubview(self.scrollView)

        self.beforeScrollView.frame = CGRectMake( -self.frame.width - 1, space, self.frame.width, self.frame.height)
        self.beforeScrollView.backgroundColor = emojiBackgroundColor
        self.scrollView.addSubview(self.beforeScrollView)

        //Frame defined at the end of displayEmojis function
        self.afterScrollView.backgroundColor = emojiBackgroundColor
        self.scrollView.addSubview(self.afterScrollView)

        self.displayEmojis(Array(emojiScore.keys))
    }
    
    func emojiSelected(sender: UIButton!) {
        delegate?.appendEmoji((sender.titleLabel?.text)!)
    }

    func suggestionSelected(sender: UIButton!) {
        delegate?.appendSuggestion((sender.titleLabel?.text)!)
    }
    
    func alreadyTypedWord(sender: UIButton!) {
        print("already typed word")
        delegate?.refusedSuggestion()
    }

    func displayEmojis(emojiList: [String], stringToSearch: String = "") {
        let numberEmoji: Int = emojiList.count

        if numberEmoji == 0 {
            return
        }

        self.removeAllButtonsFromScrollView()
        
        var xOrigin: CGFloat = 0
        var width: CGFloat = 80
        var lastButton:UIButton = UIButton()

        scrollView.scrollEnabled = true
        
        if numberEmoji <= 3 {
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
            button.backgroundColor = emojiBackgroundColor
            button.frame = CGRectMake(xOrigin, space, width, self.frame.height + 1)
            button.setTitle(emoji, forState: UIControlState.Normal)
            button.addTarget(self, action: Selector("emojiSelected:"), forControlEvents: UIControlEvents.TouchUpInside);
            button.titleLabel?.font = button.titleLabel?.font.fontWithSize(22)
            
            xOrigin += width + 1
            
            self.scrollView.addSubview(button)
            
            lastButton = button
        }
        self.scrollView.contentSize.width = lastButton.frame.origin.x + lastButton.frame.width
        self.scrollView.contentSize.height = self.frame.height

        self.afterScrollView.frame = CGRectMake( self.scrollView.contentSize.width - 1, space, self.frame.width, self.frame.height)
    }

    func displaySuggestions(var suggestionList: [String], originalString: String, willReplaceString: String = "") {
        if willReplaceString != "" {
            suggestionList.insert(willReplaceString, atIndex: 0)
        }
        suggestionList.insert(originalString, atIndex: 0)
        print(suggestionList)

        self.removeAllButtonsFromScrollView()

//        let numberSuggestion: Int = suggestionList.count
//        let width: CGFloat = ((self.frame.width - CGFloat(min(3, numberSuggestion) - 1) * space) / CGFloat(min(3, numberSuggestion)))
        let width: CGFloat = ((self.frame.width - CGFloat(2) * space) / CGFloat(3))
        scrollView.scrollEnabled = false

//        var count: CGFloat = 0
////        var suggIndex: Int = 0
//        for suggestion in suggestionList {
//            let button: UIButton = UIButton()
//            button.backgroundColor = suggestionBackgroundColor
//            button.layer.borderWidth = 0.4
//            button.layer.borderColor = UIColor.clearColor().CGColor
//            button.frame = CGRectMake(count * (width + space), 0, width, self.frame.height)
//            button.titleLabel?.textColor = UIColor.blackColor()
//            if count == 0 {
//                button.setTitle("\"" + suggestion + "\"", forState: UIControlState.Normal)
//                button.addTarget(self, action: Selector("alreadyTypedWord:"), forControlEvents: UIControlEvents.TouchUpInside);
//            } else {
//                button.setTitle(suggestion, forState: UIControlState.Normal)
//                button.addTarget(self, action: Selector("suggestionSelected:"), forControlEvents: UIControlEvents.TouchUpInside);
//                if count == 1 && willReplaceString != "" {
//                    button.backgroundColor = UIColor.whiteColor()
//                    button.setTitleColor(self.tintColor, forState: UIControlState.Normal)
//                }
//            }
//            self.scrollView.addSubview(button)
//
//            count++
//            if count > 2 {
//                break
//            }
//        }

        //OTHER WAY
        for (var index = 0; index < 3; index++) {
            let button: UIButton = UIButton()
            button.backgroundColor = suggestionBackgroundColor
            button.layer.borderWidth = 0.4
            button.layer.borderColor = UIColor.clearColor().CGColor
            button.frame = CGRectMake(CGFloat(index) * (width + space), 0, width, self.frame.height)
            button.titleLabel?.textColor = UIColor.blackColor()

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
                        button.backgroundColor = UIColor.whiteColor()
                        button.setTitleColor(self.tintColor, forState: UIControlState.Normal)
                    }
                }
            }

            self.scrollView.addSubview(button)
        }
    }

    func removeAllButtonsFromScrollView() {
        for subview in self.scrollView.subviews {
            if subview is UIButton {
                subview.removeFromSuperview()
            }
        }
    }
}
