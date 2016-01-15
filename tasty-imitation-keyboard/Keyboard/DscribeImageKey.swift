//
//  DscribeImageKey.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 15/01/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class DscribeImageKey: ImageKey {
    var bigImage: Bool = false

    override func redrawImage() {
        if let image = self.image {
            let imageSize = (bigImage ? CGSizeMake(25, 25) : CGSizeMake(20, 20))
            let imageOrigin = CGPointMake(
                (self.bounds.width - imageSize.width) / CGFloat(2),
                (self.bounds.height - imageSize.height) / CGFloat(2))
            var imageFrame = CGRectZero
            imageFrame.origin = imageOrigin
            imageFrame.size = imageSize

            image.frame = imageFrame
        }
    }
}
