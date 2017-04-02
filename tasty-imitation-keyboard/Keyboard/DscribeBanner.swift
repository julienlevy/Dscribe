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
    func appendEmoji(_ emoji: String)
    func appendSuggestion(_ suggestion: String)
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
    var selectedSuggestionBackgroungColor: UIColor?
    var selectedTextColor: UIColor?

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

        self.backgroundColor = UIColor.clear

        self.setupScrollView()

        self.beforeScrollView.frame = CGRect( x: -self.frame.width, y: space / 2, width: self.frame.width, height: self.frame.height)

        //Frame defined at the end of displayEmojis function
        self.scrollView.addSubview(self.afterScrollView)
        self.scrollView.addSubview(self.beforeScrollView)

        var count: Int = 0
        for subview in self.scrollView.subviews {
            if subview is UIButton {
                count += 1
            }
        }
        if count == 0 {
            self.displaySuggestions([], originalString: "")
        }
        self.updateBannerColors()
    }
    func setupScrollView() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.contentSize = CGSize(width: self.frame.width, height: self.frame.height)
        self.scrollView.isScrollEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(self.scrollView)

        self.addConstraint(NSLayoutConstraint(
                item: scrollView, attribute: NSLayoutAttribute.height,
                relatedBy: NSLayoutRelation.equal,
                toItem: self, attribute: NSLayoutAttribute.height,
                multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(
                item: scrollView, attribute: NSLayoutAttribute.centerY,
                relatedBy: NSLayoutRelation.equal,
                toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(
                item: scrollView, attribute: NSLayoutAttribute.width,
                relatedBy: NSLayoutRelation.equal,
                toItem: self, attribute: NSLayoutAttribute.width,
                multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(
                item: scrollView, attribute: NSLayoutAttribute.centerX,
                relatedBy: NSLayoutRelation.equal,
                toItem: self, attribute: NSLayoutAttribute.centerX,
                multiplier: 1, constant: 0))
    }

    func updateBannerColors() {
        emojiBackgroundColor = self.globalColors?.regularKey(self.darkMode, solidColorMode: self.solidColorMode)
        suggestionBackgroundColor = self.globalColors?.specialKey(self.darkMode, solidColorMode: self.solidColorMode)
        selectedSuggestionBackgroungColor = self.bannerColors?.selectedSuggestionBackground(self.darkMode, solidColorMode: self.solidColorMode)
        selectedTextColor = self.bannerColors?.selectedTextColor(self.darkMode)

        self.setButtonColors()
    }
    func setButtonColors() {
        self.beforeScrollView.backgroundColor = emojiBackgroundColor
        self.afterScrollView.backgroundColor = emojiBackgroundColor
        for subview in self.scrollView.subviews {
            if let button = subview as? UIButton {
                if button.tag == 1 { //Normal suggestion
                    button.backgroundColor = suggestionBackgroundColor
                    button.setTitleColor(UIColor.black, for: UIControlState.highlighted)
                } else if subview.tag == 2 { //Will Replace suggestion
                    button.backgroundColor = selectedSuggestionBackgroungColor
                    button.setTitleColor(selectedTextColor, for: UIControlState.highlighted)
                    button.setTitleColor(selectedTextColor, for: UIControlState())
                } else if subview.tag == 3 { //Emoji
                    button.backgroundColor = emojiBackgroundColor
                }
            }
        }
    }
    func removeSpecialSuggestionColor() {
        for subview in self.scrollView.subviews {
            if let button = subview as? UIButton {
                if subview.tag == 2 { //Will Replace suggestion
                    subview.tag = 1 //Normal suggestion
                    button.backgroundColor = suggestionBackgroundColor
                    button.setTitleColor(UIColor.black, for: UIControlState.highlighted)
                    button.setTitleColor(UIColor.white, for: UIControlState())
                }
            }
        }
    }

    func emojiSelected(_ sender: UIButton!) {
        delegate?.appendEmoji((sender.titleLabel?.text)!)
    }

    func suggestionSelected(_ sender: UIButton!) {
        delegate?.appendSuggestion((sender.titleLabel?.text)!)
    }

    func alreadyTypedWord(_ sender: UIButton!) {
        delegate?.refusedSuggestion()
    }

    func displayEmojis(_ emojiList: [String], stringToSearch: String = "") {
        let numberEmoji: Int = emojiList.count

        if numberEmoji == 0 {
            return
        }

        self.removeAllButtonsFromScrollView()
        self.beforeScrollView.isHidden = false
        self.afterScrollView.isHidden = false

        var xOrigin: CGFloat = 0
        var width: CGFloat = 80
        var lastButton: UIButton = UIButton()

        scrollView.isScrollEnabled = true
        // To scroll back to the first page of emojis:
        self.scrollView.contentSize.width = scrollView.bounds.width

        if numberEmoji <= 4 {
            width = (self.frame.width) / CGFloat(numberEmoji)
            scrollView.isScrollEnabled = false
        }

        var count: Int = 0
        for emoji in emojiList {
            count += 1
            if count > 15 {
                break
            }
            let button: UIButton = UIButton()
            button.frame = CGRect(x: xOrigin, y: space / 2, width: width, height: self.frame.height + 1)
            button.setTitle(emoji, for: UIControlState())
            button.addTarget(self, action: #selector(DscribeBanner.emojiSelected(_:)), for: UIControlEvents.touchUpInside)
            button.titleLabel?.font = button.titleLabel?.font.withSize(22)
            button.tag = 3

            xOrigin += width + 1

            self.scrollView.addSubview(button)

            lastButton = button
        }
        self.scrollView.contentSize.width = lastButton.frame.origin.x + lastButton.frame.width
        self.scrollView.contentSize.height = self.frame.height

        self.afterScrollView.frame = CGRect( x: self.scrollView.contentSize.width - 1, y: space / 2, width: self.frame.width, height: self.frame.height)

        self.setButtonColors()
    }

    func displaySuggestions(_ suggestionList: [String], originalString: String, willReplaceString: String = "") {
        var varSuggestionList: [String] = suggestionList
        if willReplaceString != "" {
            varSuggestionList.insert(willReplaceString, at: 0)
        }
        varSuggestionList.insert(originalString, at: 0)

        self.removeAllButtonsFromScrollView()
        self.beforeScrollView.isHidden = true
        self.afterScrollView.isHidden = true

        let width: CGFloat = ((self.frame.width - CGFloat(2) * space) / CGFloat(3))
        scrollView.isScrollEnabled = false
        scrollView.setContentOffset(CGPoint.zero, animated: false)

        for index in 0 ..< 3 {
            let button: UIButton = UIButton()
            button.layer.borderWidth = 0.4
            button.layer.borderColor = UIColor.clear.cgColor
            button.frame = CGRect(x: CGFloat(index) * (width + space), y: 0, width: width, height: self.frame.height)
            button.tag = 1
            button.addTarget(self, action: #selector(DscribeBanner.cancelHighlight(_:)), for: [UIControlEvents.touchUpInside, UIControlEvents.touchDragExit, UIControlEvents.touchUpOutside, UIControlEvents.touchCancel, UIControlEvents.touchDragOutside])
            button.addTarget(self, action: #selector(DscribeBanner.highlightButton(_:)), for: [.touchDown, .touchDragInside])

            if varSuggestionList.count > index {
                var suggestion: String = ""
                suggestion = varSuggestionList[index]
                if index == 0 {
                    button.setTitle((suggestion != "" ? "\"" + suggestion + "\"" : ""), for: UIControlState())
                    button.addTarget(self, action: #selector(DscribeBanner.alreadyTypedWord(_:)), for: UIControlEvents.touchUpInside)
                } else {
                    button.setTitle(suggestion, for: UIControlState())
                    button.addTarget(self, action: #selector(DscribeBanner.suggestionSelected(_:)), for: UIControlEvents.touchUpInside)
                    if index == 1 && willReplaceString != "" {
                        button.tag = 2
                    }
                }
            }

            self.scrollView.addSubview(button)
        }

        self.setButtonColors()
    }

    func removeAllButtonsFromScrollView() {
        for subview in self.scrollView.subviews {
            if subview is UIButton {
                subview.removeFromSuperview()
            }
        }
    }
    func highlightButton(_ sender: UIButton) {
        sender.backgroundColor = selectedSuggestionBackgroungColor
    }
    func cancelHighlight(_ sender: UIButton) {
        if sender.tag == 1 {
            sender.backgroundColor = suggestionBackgroundColor
        }
    }
}
