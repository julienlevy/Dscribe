//
//  DscribeShapes.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 02/01/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class EmojiShape: Shape {
    override func drawCall(color: UIColor) {
        drawEmoji(self.bounds, color: UIColor(red: 254.0/255, green: 203.0/255, blue: 73.0/255, alpha: 1.0))
    }
}

func drawEmoji(bounds: CGRect, color: UIColor) {
    let factors = getFactors(CGSizeMake(41, 40), toRect: bounds)
    let xScalingFactor = factors.xScalingFactor
    let yScalingFactor = factors.yScalingFactor

    centerShape(CGSizeMake(41 * xScalingFactor, 40 * yScalingFactor), toRect: bounds)

    //// Color Declarations
    let ovalPath = UIBezierPath(ovalInRect: CGRectMake(0 * xScalingFactor, 0 * yScalingFactor, 40 * xScalingFactor, 40 * yScalingFactor))
    color.setFill()
    ovalPath.fill()

    endCenter()
}