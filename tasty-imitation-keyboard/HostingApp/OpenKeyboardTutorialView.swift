//
//  OpenKeyboardTutorialView.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 03/02/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class OpenKeyboardTutorialView: UIView {

    var beforeIconLabel: UILabel = UILabel()
    var keyboardIcon: UIImageView = UIImageView()
    var secondLineLabel: UILabel = UILabel()

    init() {
        super.init(frame: CGRectZero)

        self.beforeIconLabel.text = "Long press "
        self.secondLineLabel.text = "and select Dscribe."

        self.keyboardIcon.image = UIImage(named: "KeyboardIcon")

        self.beforeIconLabel.textColor = UIColor.whiteColor()
        self.secondLineLabel.textColor = UIColor.whiteColor()

        self.beforeIconLabel.font = UIFont.systemFontOfSize(26)
        self.secondLineLabel.font = UIFont.systemFontOfSize(26.0)

        self.secondLineLabel.numberOfLines = 0

        self.keyboardIcon.contentMode = .ScaleAspectFit

        self.addSubview(self.beforeIconLabel)
        self.addSubview(self.keyboardIcon)
        self.addSubview(self.secondLineLabel)

        self.setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {
        self.beforeIconLabel.translatesAutoresizingMaskIntoConstraints = false
        let topFirst: NSLayoutConstraint = NSLayoutConstraint(item: self.keyboardIcon, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
        let leftFirst: NSLayoutConstraint = NSLayoutConstraint(item: self.beforeIconLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0)

        self.keyboardIcon.translatesAutoresizingMaskIntoConstraints = false
        let leftIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.keyboardIcon, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.beforeIconLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 2)
        let bottomIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.keyboardIcon, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.beforeIconLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        let heightIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.keyboardIcon, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: onboardingIconWidth)
        let widthIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.keyboardIcon, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: onboardingIconWidth)

        self.secondLineLabel.translatesAutoresizingMaskIntoConstraints = false
        let topSecond: NSLayoutConstraint = NSLayoutConstraint(item: self.secondLineLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.beforeIconLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 2)
        let leftSecond: NSLayoutConstraint = NSLayoutConstraint(item: self.secondLineLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.beforeIconLabel, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0)
        let rightSecond: NSLayoutConstraint = NSLayoutConstraint(item: self.secondLineLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0)
        

        self.addConstraints([topFirst, leftFirst, leftIcon, bottomIcon, heightIcon, widthIcon, topSecond, leftSecond, rightSecond])
    }
}
