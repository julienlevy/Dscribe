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
    var color: UIColor = UIColor(red: 250.0/255, green: 193.0/255, blue: 62.0/255, alpha: 1.0)
    
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
        print("Should have added the custom view")
        print(leftLabel.frame)
        print(rightLabel.frame)
        print(icon.frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setConstraints() {
        let horCenter: NSLayoutConstraint = NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let verCenter: NSLayoutConstraint = NSLayoutConstraint(item: icon, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)

        let left: NSLayoutConstraint = NSLayoutConstraint(item: leftLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: icon, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: -8)
        let leftCenter: NSLayoutConstraint = NSLayoutConstraint(item: leftLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: icon, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let right: NSLayoutConstraint = NSLayoutConstraint(item: rightLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: icon, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 8)
        let rightCenter: NSLayoutConstraint = NSLayoutConstraint(item: rightLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: icon, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)

        self.addConstraints([horCenter, verCenter, left, leftCenter, right, rightCenter])
    }
}
