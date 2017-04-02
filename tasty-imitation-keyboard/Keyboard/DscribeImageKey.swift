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
            let imageSize = (bigImage ? CGSize(width: 25, height: 25) : CGSize(width: 20, height: 20))
            let imageOrigin = CGPoint(
                x: (self.bounds.width - imageSize.width) / CGFloat(2),
                y: (self.bounds.height - imageSize.height) / CGFloat(2))
            var imageFrame = CGRect.zero
            imageFrame.origin = imageOrigin
            imageFrame.size = imageSize

            image.frame = imageFrame
        }
    }
}
