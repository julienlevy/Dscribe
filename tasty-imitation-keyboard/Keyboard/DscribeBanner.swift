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
}

class DscribeBanner: ExtraView {
    var delegate: DscribeBannerDelegate?
    
    var scrollView: UIScrollView = UIScrollView()
    var buttons: NSMutableArray = NSMutableArray()
    var wbefore: CGFloat = CGFloat()
    var wAfter: CGFloat = CGFloat()

    var beforeScrollView: UIView = UIView()
    var afterScrollView: UIView = UIView()

    var buttonsBackgroundColor: UIColor?

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

        buttonsBackgroundColor = self.globalColors?.regularKey(self.darkMode, solidColorMode: self.solidColorMode)

        self.scrollView.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        self.scrollView.contentSize = CGSizeMake(140, 600)
        self.scrollView.scrollEnabled = true
        self.addSubview(self.scrollView)

        self.beforeScrollView.frame = CGRectMake( -self.frame.width - 1, 0, self.frame.width, self.frame.height)
        self.beforeScrollView.backgroundColor = buttonsBackgroundColor
        self.scrollView.addSubview(self.beforeScrollView)

        //Frame defined at the end of displayEmojis function
        self.afterScrollView.backgroundColor = buttonsBackgroundColor
        self.scrollView.addSubview(self.afterScrollView)

        self.displayEmojis(Array(emojiScore.keys))
    }
    
    func emojiSelected(sender: UIButton!) {
        NSLog("NSLog emoji button clicked")

        delegate?.appendEmoji((sender.titleLabel?.text)!)
    }
    
    func displayEmojis(emojiList: [String], stringToSearch: String = "") {
        let numberEmoji: Int = emojiList.count

        if numberEmoji == 0 {
            return
        }

        for subview in self.scrollView.subviews {
            if subview is UIButton {
                subview.removeFromSuperview()
            }
        }
        
        var xOrigin: CGFloat = 0
        var width: CGFloat = 80
        var lastButton:UIButton = UIButton()
        
//        let label:UILabel = UILabel(frame: CGRectMake(0, 0, 10, self.frame.height))
//        label.text = stringToSearch
//        label.sizeToFit()
//        xOrigin = label.frame.width
//        self.scrollView.addSubview(label)
        
        scrollView.scrollEnabled = true
        
        if numberEmoji <= 3 {
            width = (self.frame.width) / CGFloat(numberEmoji)
            scrollView.scrollEnabled = false
        }
        
        
        var count: Int = 0
        for emoji in emojiList {
            count++
            if count > 7 {
                break
            }
            let button: UIButton = UIButton()
            button.backgroundColor = buttonsBackgroundColor
            button.layer.borderWidth = 0.4
            button.layer.borderColor = UIColor.clearColor().CGColor
            button.frame = CGRectMake(xOrigin, -1, width, self.frame.height + 2)
            button.setTitle(emoji, forState: UIControlState.Normal)
            button.addTarget(self, action: Selector("emojiSelected:"), forControlEvents: UIControlEvents.TouchUpInside);
            button.titleLabel?.font = button.titleLabel?.font.fontWithSize(22)
            
            xOrigin += width + 1
            
            self.scrollView.addSubview(button)
            
            lastButton = button
        }
        self.scrollView.contentSize.width = lastButton.frame.origin.x + lastButton.frame.width
        self.scrollView.contentSize.height = self.frame.height

        self.afterScrollView.frame = CGRectMake( self.scrollView.contentSize.width - 1, 0, self.frame.width, self.frame.height)
    }
}
