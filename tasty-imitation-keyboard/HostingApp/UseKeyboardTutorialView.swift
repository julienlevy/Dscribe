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

        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
