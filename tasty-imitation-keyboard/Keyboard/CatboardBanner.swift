//
//  CatboardBanner.swift
//  TastyImitationKeyboard
//
//  Created by Alexei Baboulevitch on 10/5/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

import UIKit

/*
This is the demo banner. The banner is needed so that the top row popups have somewhere to go. Might as well fill it
with something (or leave it blank if you like.)
*/

protocol CatboardBannerDelegate {
    func appendEmoji(emoji: String)
}

class CatboardBanner: ExtraView {
    var delegate: CatboardBannerDelegate?
    
//    var emoji : String?
    
    var catSwitch: UISwitch = UISwitch()
    var catLabel: UILabel = UILabel()
    var firstEmojiButton: UIButton = UIButton()
    var testLabel:UILabel = UILabel()
    
    required init(globalColors: GlobalColors.Type?, darkMode: Bool, solidColorMode: Bool) {
        super.init(globalColors: globalColors, darkMode: darkMode, solidColorMode: solidColorMode)
        
        self.addSubview(self.catSwitch)
        self.addSubview(self.catLabel)
        self.addSubview(self.firstEmojiButton)
        self.addSubview(self.testLabel)
        
        self.firstEmojiButton.setTitle("B", forState: UIControlState.Normal)
        
        self.catSwitch.on = NSUserDefaults.standardUserDefaults().boolForKey(kCatTypeEnabled)
        self.catSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75)
        self.catSwitch.addTarget(self, action: Selector("respondToSwitch"), forControlEvents: UIControlEvents.ValueChanged)
        
        self.firstEmojiButton.frame = CGRectMake(10, 10, 40, 40)
        self.firstEmojiButton.setTitle("😈", forState: UIControlState.Normal)
        self.firstEmojiButton.sizeToFit()
//        self.firstEmojiButton.enabled = true
        self.firstEmojiButton.backgroundColor = UIColor.blueColor()
        self.firstEmojiButton.setTitle("H", forState: UIControlState.Highlighted)
        self.firstEmojiButton.addTarget(self, action: Selector("emojiSelected:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.testLabel.frame = CGRectMake(260, 10, 80, 30)
        self.testLabel.backgroundColor = UIColor.redColor()
        self.testLabel.text = "not clicked"
        self.testLabel.font = self.testLabel.font.fontWithSize(10.0)

        
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
        print(self.firstEmojiButton.frame);

    }
    
    func emojiSelected(sender: UIButton!) {
        self.testLabel.text = self.firstEmojiButton.titleLabel?.text
        print("emoji button clicked")
        
        NSLog("nslog emoji button clicked")
        
        
        delegate?.appendEmoji((self.firstEmojiButton.titleLabel?.text)!)
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
