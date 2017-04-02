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
        super.init(frame: CGRect.zero)

        self.beforeIconLabel.text = "Tap "
        self.afterIconLabel.text = "and search emojis."
        self.detailsLabel.text = "You may use several keywords for precise emojis, but they must be in English."

        self.keyIcon.image = UIImage(named: "dscribeKey")

        self.beforeIconLabel.textColor =  UIColor.white
        self.afterIconLabel.textColor =  UIColor.white
        self.detailsLabel.textColor =  UIColor.white

        if #available(iOS 8.2, *) {
            self.beforeIconLabel.font = UIFont.systemFont(ofSize: 26, weight: UIFontWeightMedium)
            self.afterIconLabel.font = UIFont.systemFont(ofSize: 26, weight: UIFontWeightMedium)
        } else {
            self.beforeIconLabel.font = UIFont.systemFont(ofSize: 26)
            self.afterIconLabel.font = UIFont.systemFont(ofSize: 26)
        }
        self.detailsLabel.font = UIFont.systemFont(ofSize: 16)

        self.beforeIconLabel.textAlignment = .center
        self.afterIconLabel.textAlignment = .center
        self.detailsLabel.textAlignment = .center

        self.detailsLabel.numberOfLines = 0

        self.keyIcon.contentMode = .scaleAspectFit

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
        let topFirst: NSLayoutConstraint = NSLayoutConstraint(item: self.keyIcon, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0)
        let leftFirst: NSLayoutConstraint = NSLayoutConstraint(item: self.beforeIconLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0)
        let centerFirst: NSLayoutConstraint = NSLayoutConstraint(item: self.beforeIconLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: -onboardingIconWidth / 2)


        self.keyIcon.translatesAutoresizingMaskIntoConstraints = false
        let leftIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.keyIcon, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.beforeIconLabel, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 2)
        let bottomIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.keyIcon, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.beforeIconLabel, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0)
        let heightIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.keyIcon, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: onboardingIconWidth)
        let widthIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.keyIcon, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: onboardingIconWidth)

//        self.afterIconLabel.translatesAutoresizingMaskIntoConstraints = false
//        let bottomAfter: NSLayoutConstraint = NSLayoutConstraint(item: self.afterIconLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.keyIcon, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0)
//        let leftAfter: NSLayoutConstraint = NSLayoutConstraint(item: self.afterIconLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.keyIcon, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 2)

        self.afterIconLabel.translatesAutoresizingMaskIntoConstraints = false
        let bottomAfter: NSLayoutConstraint = NSLayoutConstraint(item: self.afterIconLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.beforeIconLabel, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 4)
        let leftAfter: NSLayoutConstraint = NSLayoutConstraint(item: self.afterIconLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.beforeIconLabel, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0)
        let centerAfter: NSLayoutConstraint = NSLayoutConstraint(item: self.afterIconLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0)


        self.detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        let topSecond: NSLayoutConstraint = NSLayoutConstraint(item: self.detailsLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.afterIconLabel, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 8)
        let leftSecond: NSLayoutConstraint = NSLayoutConstraint(item: self.detailsLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0)
        let rightSecond: NSLayoutConstraint = NSLayoutConstraint(item: self.detailsLabel, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 0)


//        self.addConstraints([topFirst, leftFirst, leftIcon, bottomIcon, heightIcon, widthIcon, bottomAfter, leftAfter, topSecond, leftSecond, rightSecond])
        self.addConstraints([topFirst, centerFirst, leftIcon, bottomIcon, heightIcon, widthIcon, bottomAfter, centerAfter, topSecond, leftSecond, rightSecond])
    }
}
