//
//  DscribeLayout.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 03/01/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class DscribeLayout: KeyboardLayout {
    override func updateKeyCap(key: KeyboardKey, model: Key, fullReset: Bool, uppercase: Bool, characterUppercase: Bool, shiftState: ShiftState) {

        self.updateKeyCapText(key, model: model, uppercase: uppercase, characterUppercase: characterUppercase)

        // font size
        switch model.type {
        case
        Key.KeyType.ModeChange,
        Key.KeyType.Space,
        Key.KeyType.Return:
            key.label.adjustsFontSizeToFitWidth = true
            key.label.font = key.label.font.fontWithSize(16)
        default:
            key.label.font = fontForKeyWithText(key.text, keytype: model.type)
        }

        if fullReset {
            // label inset
            switch model.type {
            case
            Key.KeyType.ModeChange:
                key.labelInset = 3
            default:
                key.labelInset = 0
            }

            // shapes
            switch model.type {
            case Key.KeyType.Shift:
                if key.shape == nil {
                    let shiftShape = self.getShape(ShiftShape)
                    key.shape = shiftShape
                }
            case Key.KeyType.Backspace:
                if key.shape == nil {
                    let backspaceShape = self.getShape(BackspaceShape)
                    key.shape = backspaceShape
                }
            case Key.KeyType.KeyboardChange:
                if key.shape == nil {
                    let globeShape = self.getShape(GlobeShape)
                    key.shape = globeShape
                }
            default:
                break
            }

            // images
            if model.type == Key.KeyType.Settings {
                if let imageKey = key as? ImageKey {
                    if imageKey.image == nil {
                        let gearImage = UIImage(named: "gear")
                        let settingsImageView = UIImageView(image: gearImage)
                        imageKey.image = settingsImageView
                    }
                }
            }
            if model.type == Key.KeyType.SearchEmoji {
                if let imageKey = key as? DscribeImageKey {
                    if imageKey.image == nil {
                        imageKey.bigImage = true
                        let keyIcon = UIImage(named: "Icon")
                        let emojiImageView = UIImageView(image: keyIcon)
                        imageKey.image = emojiImageView
                    }
                }
            }
        }

        if model.type == Key.KeyType.Shift {
            if key.shape == nil {
                let shiftShape = self.getShape(ShiftShape)
                key.shape = shiftShape
            }

            switch shiftState {
            case .Disabled:
                key.highlighted = false
            case .Enabled:
                key.highlighted = true
            case .Locked:
                key.highlighted = true
            }

            (key.shape as? ShiftShape)?.withLock = (shiftState == .Locked)
        }
    }

    override     func generateKeyFrames(model: Keyboard, bounds: CGRect, page pageToLayout: Int) -> [Key:CGRect]? {
        if bounds.height == 0 || bounds.width == 0 {
            return nil
        }
        
        var keyMap = [Key:CGRect]()
        
        let isLandscape: Bool = {
            let boundsRatio = bounds.width / bounds.height
            return (boundsRatio >= self.layoutConstants.landscapeRatio)
        }()
        
        var sideEdges = (isLandscape ? self.layoutConstants.sideEdgesLandscape : self.layoutConstants.sideEdgesPortrait(bounds.width))
        let bottomEdge = sideEdges
        
        let normalKeyboardSize = bounds.width - CGFloat(2) * sideEdges
        let shrunkKeyboardSize = self.layoutConstants.keyboardShrunkSize(normalKeyboardSize)
        
        sideEdges += ((normalKeyboardSize - shrunkKeyboardSize) / CGFloat(2))
        
        let topEdge: CGFloat = (isLandscape ? self.layoutConstants.topEdgeLandscape : self.layoutConstants.topEdgePortrait(bounds.width))
        
        let rowGap: CGFloat = (isLandscape ? self.layoutConstants.rowGapLandscape : self.layoutConstants.rowGapPortrait(bounds.width))
        let lastRowGap: CGFloat = (isLandscape ? rowGap : self.layoutConstants.rowGapPortraitLastRow(bounds.width))
        
        let flexibleEndRowM = (isLandscape ? self.layoutConstants.flexibleEndRowTotalWidthToKeyWidthMLandscape : self.layoutConstants.flexibleEndRowTotalWidthToKeyWidthMPortrait)
        let flexibleEndRowC = (isLandscape ? self.layoutConstants.flexibleEndRowTotalWidthToKeyWidthCLandscape : self.layoutConstants.flexibleEndRowTotalWidthToKeyWidthCPortrait)
        
        let lastRowLeftSideRatio = (isLandscape ? self.layoutConstants.lastRowLandscapeFirstTwoButtonAreaWidthToKeyboardAreaWidth : self.layoutConstants.lastRowPortraitFirstTwoButtonAreaWidthToKeyboardAreaWidth)
        let lastRowRightSideRatio = (isLandscape ? self.layoutConstants.lastRowLandscapeLastButtonAreaWidthToKeyboardAreaWidth : self.layoutConstants.lastRowPortraitLastButtonAreaWidthToKeyboardAreaWidth)
        let lastRowKeyGap = (isLandscape ? self.layoutConstants.lastRowKeyGapLandscape(bounds.width) : self.layoutConstants.lastRowKeyGapPortrait)
        
        for (p, page) in model.pages.enumerate() {
            if p != pageToLayout {
                continue
            }
            
            let numRows = page.rows.count
            
            let mostKeysInRow: Int = {
                var currentMax: Int = 0
                for (i, row) in page.rows.enumerate() {
                    currentMax = max(currentMax, row.count)
                }
                return currentMax
            }()
            
            let rowGapTotal = CGFloat(numRows - 1 - 1) * rowGap + lastRowGap
            
            let keyGap: CGFloat = (isLandscape ? self.layoutConstants.keyGapLandscape(bounds.width, rowCharacterCount: mostKeysInRow) : self.layoutConstants.keyGapPortrait(bounds.width, rowCharacterCount: mostKeysInRow))
            
            let keyHeight: CGFloat = {
                let totalGaps = bottomEdge + topEdge + rowGapTotal
                let returnHeight = (bounds.height - totalGaps) / CGFloat(numRows)
                return self.rounded(returnHeight)
            }()
            
            let letterKeyWidth: CGFloat = {
                let totalGaps = (sideEdges * CGFloat(2)) + (keyGap * CGFloat(mostKeysInRow - 1))
                let returnWidth = (bounds.width - totalGaps) / CGFloat(mostKeysInRow)
                return self.rounded(returnWidth)
            }()
            
            let processRow = { (row: [Key], frames: [CGRect], inout map: [Key:CGRect]) -> Void in
                assert(row.count == frames.count, "row and frames don't match")
                for (k, key) in row.enumerate() {
                    map[key] = frames[k]
                }
            }
            
            for (r, row) in page.rows.enumerate() {
                let rowGapCurrentTotal = (r == page.rows.count - 1 ? rowGapTotal : CGFloat(r) * rowGap)
                let frame = CGRectMake(rounded(sideEdges), rounded(topEdge + (CGFloat(r) * keyHeight) + rowGapCurrentTotal), rounded(bounds.width - CGFloat(2) * sideEdges), rounded(keyHeight))
                
                var frames: [CGRect]!
                
                // basic character row: only typable characters
                if self.characterRowHeuristic(row) {
                    frames = self.layoutCharacterRow(row, keyWidth: letterKeyWidth, gapWidth: keyGap, frame: frame)
                }
                    
                    // character row with side buttons: shift, backspace, etc.
                else if self.doubleSidedRowHeuristic(row) {
                    //DIFFERENCE with superclass method
                    frames = (p == 0 ? self.layoutCharacterWithSidesRowNonFlexibleKeys : self.layoutCharacterWithSidesRow)(row, frame: frame, isLandscape: isLandscape, keyWidth: letterKeyWidth, keyGap: keyGap)
                }
                    
                    // bottom row with things like space, return, etc.
                else {
                    frames = self.layoutSpecialKeysRow(row, keyWidth: letterKeyWidth, gapWidth: lastRowKeyGap, leftSideRatio: lastRowLeftSideRatio, rightSideRatio: lastRowRightSideRatio, micButtonRatio: self.layoutConstants.micButtonPortraitWidthRatioToOtherSpecialButtons, isLandscape: isLandscape, frame: frame)
                }
                
                processRow(row, frames, &keyMap)
            }
        }
        
        return keyMap
    }

    func layoutCharacterWithSidesRowNonFlexibleKeys(row: [Key], frame: CGRect, isLandscape: Bool, keyWidth: CGFloat, keyGap: CGFloat) -> [CGRect] {
        var frames = [CGRect]()
        
        let standardFullKeyCount = Int(self.layoutConstants.keyCompressedThreshhold) - 1
        print("standardFullKeyCount : " + String(standardFullKeyCount))
        let standardGap = (isLandscape ? self.layoutConstants.keyGapLandscape : self.layoutConstants.keyGapPortrait)(frame.width, rowCharacterCount: standardFullKeyCount)
        print("standardGap : " + String(standardGap))
        let sideEdges = (isLandscape ? self.layoutConstants.sideEdgesLandscape : self.layoutConstants.sideEdgesPortrait(frame.width))
        print("sideEdges : " + String(sideEdges))
        var standardKeyWidth = (frame.width - sideEdges - (standardGap * CGFloat(standardFullKeyCount - 1)) - sideEdges)
        print("standardKeyWidth : " + String(standardKeyWidth))
        standardKeyWidth /= CGFloat(standardFullKeyCount)
        print("standardKeyWidth : " + String(standardKeyWidth))
        let standardKeyCount = self.layoutConstants.flexibleEndRowMinimumStandardCharacterWidth
        print("standardKeyCount : " + String(standardKeyCount))
        
        let standardWidth = CGFloat(standardKeyWidth * standardKeyCount + standardGap * (standardKeyCount - 1))
        print("standardWidth : " + String(standardWidth))
        let currentWidth = CGFloat(row.count - 2) * keyWidth + CGFloat(row.count - 3) * keyGap
        print("currentWidth : " + String(currentWidth))
        
        let isStandardWidth = (currentWidth < standardWidth)
        print("isStandardWidth : " + String(isStandardWidth))
        let actualWidth = currentWidth // (isStandardWidth ? standardWidth : currentWidth)
        print("actualWidth : " + String(actualWidth))
        let actualGap = (isStandardWidth ? standardGap : keyGap)
        print("actualGap : " + String(actualGap))
        let actualKeyWidth = (actualWidth - CGFloat(row.count - 3) * actualGap) / CGFloat(row.count - 2)
        print("actualKeyWidth : " + String(actualKeyWidth))
        
        let sideSpace = (frame.width - actualWidth) / CGFloat(2)
        print("sideSpace : " + String(sideSpace))
        
        let m = (isLandscape ? self.layoutConstants.flexibleEndRowTotalWidthToKeyWidthMLandscape : self.layoutConstants.flexibleEndRowTotalWidthToKeyWidthMPortrait)
        print("m : " + String(m))
        let c = (isLandscape ? self.layoutConstants.flexibleEndRowTotalWidthToKeyWidthCLandscape : self.layoutConstants.flexibleEndRowTotalWidthToKeyWidthCPortrait)
        print("c : " + String(c))
        
        var specialCharacterWidth = sideSpace * m + c
        specialCharacterWidth = ((frame.width - standardWidth) / CGFloat(2)) * m + c
        print("specialCharacterWidth : " + String(specialCharacterWidth))
        specialCharacterWidth = max(specialCharacterWidth, keyWidth)
        print("specialCharacterWidth : " + String(specialCharacterWidth))
        specialCharacterWidth = rounded(specialCharacterWidth)
        print("specialCharacterWidth : " + String(specialCharacterWidth))
        let specialCharacterGap = sideSpace - specialCharacterWidth
        print("specialCharacterGap : " + String(specialCharacterGap))
        
        var currentOrigin = frame.origin.x
        for (k, key) in row.enumerate() {
            if k == 0 {
                frames.append(CGRectMake(rounded(currentOrigin), frame.origin.y, specialCharacterWidth, frame.height))
                currentOrigin += (specialCharacterWidth + specialCharacterGap)
            }
            else if k == row.count - 1 {
                currentOrigin += specialCharacterGap
                frames.append(CGRectMake(rounded(currentOrigin), frame.origin.y, specialCharacterWidth, frame.height))
                currentOrigin += specialCharacterWidth
            }
            else {
                frames.append(CGRectMake(rounded(currentOrigin), frame.origin.y, actualKeyWidth, frame.height))
                if k == row.count - 2 {
                    currentOrigin += (actualKeyWidth)
                }
                else {
                    currentOrigin += (actualKeyWidth + keyGap)
                }
            }
        }
        
        return frames
    }
    override func layoutSpecialKeysRow(row: [Key], keyWidth: CGFloat, gapWidth: CGFloat, leftSideRatio: CGFloat, rightSideRatio: CGFloat, micButtonRatio: CGFloat, isLandscape: Bool, frame: CGRect) -> [CGRect] {
        var frames = [CGRect]()

        var keysBeforeSpace = 0
        var keysAfterSpace = 0
        var reachedSpace = false
        for (k, key) in row.enumerate() {
            if key.type == Key.KeyType.Space {
                reachedSpace = true
            }
            else {
                if !reachedSpace {
                    keysBeforeSpace += 1
                }
                else {
                    keysAfterSpace += 1
                }
            }
        }

        assert(keysBeforeSpace <= 3, "invalid number of keys before space (only max 3 currently supported)")
        assert(keysAfterSpace == 1, "invalid number of keys after space (only default 1 currently supported)")

        let hasButtonInMicButtonPosition = (keysBeforeSpace == 3)

        var leftSideAreaWidth = frame.width * leftSideRatio
        let rightSideAreaWidth = frame.width * rightSideRatio
        var leftButtonWidth = (leftSideAreaWidth - (gapWidth * CGFloat(2 - 1))) / CGFloat(2)
        leftButtonWidth = rounded(leftButtonWidth)
        var rightButtonWidth = (rightSideAreaWidth - (gapWidth * CGFloat(keysAfterSpace - 1))) / CGFloat(keysAfterSpace)
        rightButtonWidth = rounded(rightButtonWidth)

        let micButtonWidth = (isLandscape ? leftButtonWidth : leftButtonWidth )//* micButtonRatio)

        // special case for mic button
        if hasButtonInMicButtonPosition {
            leftSideAreaWidth = leftSideAreaWidth + gapWidth + micButtonWidth
        }

        var spaceWidth = frame.width - leftSideAreaWidth - rightSideAreaWidth - gapWidth * CGFloat(2)
        spaceWidth = rounded(spaceWidth)

        var currentOrigin = frame.origin.x
        var beforeSpace: Bool = true
        for (k, key) in row.enumerate() {
            if key.type == Key.KeyType.Space {
                frames.append(CGRectMake(rounded(currentOrigin), frame.origin.y, spaceWidth, frame.height))
                currentOrigin += (spaceWidth + gapWidth)
                beforeSpace = false
            }
            else if beforeSpace {
                if hasButtonInMicButtonPosition && k == 2 { //mic button position
                    frames.append(CGRectMake(rounded(currentOrigin), frame.origin.y, micButtonWidth, frame.height))
                    currentOrigin += (micButtonWidth + gapWidth)
                }
                else {
                    frames.append(CGRectMake(rounded(currentOrigin), frame.origin.y, leftButtonWidth, frame.height))
                    currentOrigin += (leftButtonWidth + gapWidth)
                }
            }
            else {
                frames.append(CGRectMake(rounded(currentOrigin), frame.origin.y, rightButtonWidth, frame.height))
                currentOrigin += (rightButtonWidth + gapWidth)
            }
        }

        return frames
    }

    override func setAppearanceForKey(key: KeyboardKey, model: Key, darkMode: Bool, solidColorMode: Bool) {
        if model.type == Key.KeyType.SearchEmoji {
            // TODO:  use this function "setAppearanceForOtherKey" and type Other and type instead of overriding this function
            key.color = self.self.globalColors.regularKey(darkMode, solidColorMode: solidColorMode)
            key.downColor = self.globalColors.specialKey(darkMode, solidColorMode: solidColorMode)
        }
        super.setAppearanceForKey(key, model: model, darkMode: darkMode, solidColorMode: solidColorMode)
    }

    override func createNewKey() -> KeyboardKey {
        return DscribeImageKey(vibrancy: nil)
    }
}
