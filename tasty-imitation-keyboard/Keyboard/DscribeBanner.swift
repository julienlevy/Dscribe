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
        
        self.scrollView.frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        self.scrollView.contentSize = CGSizeMake(140, 600)
        self.scrollView.scrollEnabled = true
        self.addSubview(self.scrollView)
        
        self.displayEmojis(emojiArray)
    }
    
    func emojiSelected(sender: UIButton!) {
        NSLog("NSLog emoji button clicked")

        delegate?.appendEmoji((sender.titleLabel?.text)!)
    }
    
    func displayEmojis(emojiList: [String], stringToSearch: String = "") {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        
        var xOrigin: CGFloat = 0
        var width: CGFloat = 80
        var lastButton:UIButton = UIButton()
        
//        let label:UILabel = UILabel(frame: CGRectMake(0, 0, 10, self.frame.height))
//        label.text = stringToSearch
//        label.sizeToFit()
//        xOrigin = label.frame.width
//        self.scrollView.addSubview(label)
        
        for  emoji in emojiList {
            let button: UIButton = UIButton()
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor.whiteColor().CGColor
            button.frame = CGRectMake(xOrigin, -1, width, self.frame.height + 1)
            button.setTitle(emoji, forState: UIControlState.Normal)
            button.addTarget(self, action: Selector("emojiSelected:"), forControlEvents: UIControlEvents.TouchUpInside);
            
            width = button.frame.width
            
            xOrigin += width
            
            self.scrollView.addSubview(button)
            
            lastButton = button
        }
        self.scrollView.contentSize.width = lastButton.frame.origin.x + lastButton.frame.width
        self.scrollView.contentSize.height = self.frame.height
    }
}
