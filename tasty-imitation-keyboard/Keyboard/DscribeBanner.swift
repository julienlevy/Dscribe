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
    
    var catSwitch: UISwitch = UISwitch()
    var catLabel: UILabel = UILabel()
    var firstEmojiButton: UIButton = UIButton()
    
    var scrollView: UIScrollView = UIScrollView()
    var buttons: NSMutableArray = NSMutableArray()
    var wbefore: CGFloat = CGFloat()
    var wAfter: CGFloat = CGFloat()
    
    required init(globalColors: GlobalColors.Type?, darkMode: Bool, solidColorMode: Bool) {
        super.init(globalColors: globalColors, darkMode: darkMode, solidColorMode: solidColorMode)
        
        self.addSubview(self.catSwitch)
        self.addSubview(self.catLabel)
        self.addSubview(self.firstEmojiButton)
        
        self.catSwitch.on = NSUserDefaults.standardUserDefaults().boolForKey(kCatTypeEnabled)
        self.catSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75)
        self.catSwitch.addTarget(self, action: Selector("respondToSwitch"), forControlEvents: UIControlEvents.ValueChanged)
        
        self.firstEmojiButton.frame = CGRectMake(10, 10, 40, 40)
        self.firstEmojiButton.setTitle("😈", forState: UIControlState.Normal)
        self.firstEmojiButton.sizeToFit()
        self.firstEmojiButton.addTarget(self, action: Selector("emojiSelected:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.updateAppearance()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.catSwitch.center = self.center
        self.catLabel.center = self.center
        self.catLabel.frame.origin = CGPointMake(self.catSwitch.frame.origin.x + self.catSwitch.frame.width + 8, self.catLabel.frame.origin.y)
        
        self.firstEmojiButton.frame.origin = CGPointMake(self.catSwitch.frame.origin.x - 50, self.catSwitch.frame.origin.y)
        
        
        // ––––––––––––––––––––––––––
        self.scrollView.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        self.scrollView.contentSize = CGSizeMake(80, 600)
        self.scrollView.scrollEnabled = true
        self.addSubview(self.scrollView)
        
        var xOrigin: CGFloat = 0
        var width: CGFloat = 20
        var lastButton:UIButton = UIButton()
        for  emoji in emojiArray {
            let button: UIButton = UIButton()
            button.frame = CGRectMake(xOrigin, 0, width, self.frame.height)
            button.setTitle(emoji, forState: UIControlState.Normal)
            button.sizeToFit()
            button.addTarget(self, action: Selector("emojiSelected:"), forControlEvents: UIControlEvents.TouchUpInside);
            
            width = button.frame.width
            
            xOrigin += width + 20
            
            self.scrollView.addSubview(button)
            
            lastButton = button
        }
        self.scrollView.contentSize.width = lastButton.frame.origin.x + lastButton.frame.width
        self.scrollView.contentSize.height = self.frame.height
    }
    
    func emojiSelected(sender: UIButton!) {
        NSLog("NSLog emoji button clicked")

        delegate?.appendEmoji((sender.titleLabel?.text)!)
    }
    
    func respondToSwitch() {
        NSUserDefaults.standardUserDefaults().setBool(self.catSwitch.on, forKey: kCatTypeEnabled)
        self.updateAppearance()
    }
    
    func updateAppearance() {
        if self.catSwitch.on {
            self.catLabel.text = "😺"
            self.catLabel.alpha = 1
            self.firstEmojiButton.setTitle("😈", forState: UIControlState.Normal)
        }
        else {
            self.catLabel.text = "🐱"
            self.catLabel.alpha = 0.5
            self.firstEmojiButton.setTitle("🐱", forState: UIControlState.Normal)
            
        }
        
        self.catLabel.sizeToFit()
    }
}
