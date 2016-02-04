//
//  UseKeyboardTutorialView.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 03/02/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class UseKeyboardTutorialView: UIView {
    var beforeIconLabel: UILabel = UILabel()
    var afterIconLabel: UILabel = UILabel()
    var detailsLabel: UILabel = UILabel()

    var keyIcon: UIImageView = UIImageView()

    init() {
        super.init(frame: CGRectZero)

        self.beforeIconLabel.text = "Tap "
        self.afterIconLabel.text = "and search for emojis."
        self.detailsLabel.text = "You may use several keywords for precise emojis, but they must be in English."

        self.keyIcon.image = UIImage(named: "dscribeKey")

        self.beforeIconLabel.textColor =  UIColor.whiteColor()
        self.afterIconLabel.textColor =  UIColor.whiteColor()
        self.detailsLabel.textColor =  UIColor.whiteColor()

        self.beforeIconLabel.font = UIFont.systemFontOfSize(24)
        self.afterIconLabel.font = UIFont.systemFontOfSize(24)
        self.detailsLabel.font = UIFont.systemFontOfSize(16)

        self.detailsLabel.numberOfLines = 0

        self.keyIcon.contentMode = .ScaleAspectFit

        self.addSubview(self.beforeIconLabel)
        self.addSubview(self.keyIcon)
        self.addSubview(self.afterIconLabel)
        self.addSubview(self.detailsLabel)

        self.setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupConstraints() {
        self.beforeIconLabel.translatesAutoresizingMaskIntoConstraints = false
        let topFirst: NSLayoutConstraint = NSLayoutConstraint(item: self.keyIcon, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
        let leftFirst: NSLayoutConstraint = NSLayoutConstraint(item: self.beforeIconLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0)

        self.keyIcon.translatesAutoresizingMaskIntoConstraints = false
        let leftIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.keyIcon, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.beforeIconLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 2)
        let bottomIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.keyIcon, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.beforeIconLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
        let heightIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.keyIcon, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: onboardingIconWidth)
        let widthIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.keyIcon, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: onboardingIconWidth)

//        self.afterIconLabel.translatesAutoresizingMaskIntoConstraints = false
//        let bottomAfter: NSLayoutConstraint = NSLayoutConstraint(item: self.afterIconLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.keyIcon, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
//        let leftAfter: NSLayoutConstraint = NSLayoutConstraint(item: self.afterIconLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.keyIcon, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 2)

        self.afterIconLabel.translatesAutoresizingMaskIntoConstraints = false
        let bottomAfter: NSLayoutConstraint = NSLayoutConstraint(item: self.afterIconLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.beforeIconLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 4)
        let leftAfter: NSLayoutConstraint = NSLayoutConstraint(item: self.afterIconLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.beforeIconLabel, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0)

        self.detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        let topSecond: NSLayoutConstraint = NSLayoutConstraint(item: self.detailsLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.afterIconLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 4)
        let leftSecond: NSLayoutConstraint = NSLayoutConstraint(item: self.detailsLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.beforeIconLabel, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0)
        let rightSecond: NSLayoutConstraint = NSLayoutConstraint(item: self.detailsLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0)


        self.addConstraints([topFirst, leftFirst, leftIcon, bottomIcon, heightIcon, widthIcon, bottomAfter, leftAfter, topSecond, leftSecond, rightSecond])
    }
}
