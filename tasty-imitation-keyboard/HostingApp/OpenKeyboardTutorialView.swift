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
        super.init(frame: CGRect.zero)

        self.beforeIconLabel.text = "Long press "
        self.secondLineLabel.text = "and select Dscribe."

        self.keyboardIcon.image = UIImage(named: "KeyboardIcon")

        self.beforeIconLabel.textColor = UIColor.white
        self.secondLineLabel.textColor = UIColor.white

        if #available(iOS 8.2, *) {
            self.beforeIconLabel.font = UIFont.systemFont(ofSize: 26, weight: UIFontWeightMedium)
            self.secondLineLabel.font = UIFont.systemFont(ofSize: 26, weight: UIFontWeightMedium)
        } else {
            self.beforeIconLabel.font = UIFont.systemFont(ofSize: 26)
            self.secondLineLabel.font = UIFont.systemFont(ofSize: 26)
        }

        self.beforeIconLabel.textAlignment = .center
        self.secondLineLabel.textAlignment = .center

        self.secondLineLabel.numberOfLines = 0

        self.keyboardIcon.contentMode = .scaleAspectFit

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
        let topFirst: NSLayoutConstraint = NSLayoutConstraint(item: self.keyboardIcon, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1.0, constant: 0)
        let leftFirst: NSLayoutConstraint = NSLayoutConstraint(item: self.beforeIconLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0)
        let centerFirst: NSLayoutConstraint = NSLayoutConstraint(item: self.beforeIconLabel, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: -onboardingIconWidth / 2)

        self.keyboardIcon.translatesAutoresizingMaskIntoConstraints = false
        let leftIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.keyboardIcon, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.beforeIconLabel, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 2)
        let bottomIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.keyboardIcon, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.beforeIconLabel, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 0)
        let heightIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.keyboardIcon, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: onboardingIconWidth)
        let widthIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.keyboardIcon, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: onboardingIconWidth)

        self.secondLineLabel.translatesAutoresizingMaskIntoConstraints = false
        let topSecond: NSLayoutConstraint = NSLayoutConstraint(item: self.secondLineLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.beforeIconLabel, attribute: NSLayoutAttribute.bottom, multiplier: 1.0, constant: 2)
        let leftSecond: NSLayoutConstraint = NSLayoutConstraint(item: self.secondLineLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1.0, constant: 0)
        let rightSecond: NSLayoutConstraint = NSLayoutConstraint(item: self.secondLineLabel, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1.0, constant: 0)
        

//        self.addConstraints([topFirst, leftFirst, leftIcon, bottomIcon, heightIcon, widthIcon, topSecond, leftSecond, rightSecond])
        self.addConstraints([topFirst, leftFirst, centerFirst, leftIcon, bottomIcon, heightIcon, widthIcon, topSecond, leftSecond, rightSecond])
    }
}
