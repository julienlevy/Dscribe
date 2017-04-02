//
//  NavigationTitle.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 14/01/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class NavigationTitle: UIView {
    var leftLabel: UILabel = UILabel()
    var rightLabel: UILabel = UILabel()
    var icon: UIImageView = UIImageView()
    var color: UIColor = UIColor.dscribeOrangeText()
    init(frame: CGRect, leftText: String, rightText: String) {
        super.init(frame: frame)

        icon = UIImageView(image: UIImage(named: "Icon"))

        self.addSubview(leftLabel)
        self.addSubview(rightLabel)
        self.addSubview(icon)

        leftLabel.text = leftText
        rightLabel.text = rightText

        leftLabel.textColor = color
        rightLabel.textColor = color

        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        icon.translatesAutoresizingMaskIntoConstraints = false

        self.setConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setConstraints() {
        let horCenter: NSLayoutConstraint = NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let verCenter: NSLayoutConstraint = NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)

        let left: NSLayoutConstraint = NSLayoutConstraint(item: leftLabel, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: icon, attribute: NSLayoutAttribute.left, multiplier: 1, constant: -8)
        let leftCenter: NSLayoutConstraint = NSLayoutConstraint(item: leftLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: icon, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        let right: NSLayoutConstraint = NSLayoutConstraint(item: rightLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: icon, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 8)
        let rightCenter: NSLayoutConstraint = NSLayoutConstraint(item: rightLabel, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: icon, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)

        self.addConstraints([horCenter, verCenter, left, leftCenter, right, rightCenter])
    }
}
