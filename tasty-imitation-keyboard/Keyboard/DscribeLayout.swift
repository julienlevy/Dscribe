//
//  DscribeLayout.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 03/01/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class DscribeLayout: KeyboardLayout {
    var inSearchMode: Bool = false

    override func updateKeyCap(_ key: KeyboardKey, model: Key, fullReset: Bool, uppercase: Bool, characterUppercase: Bool, shiftState: ShiftState) {

        self.updateKeyCapText(key, model: model, uppercase: uppercase, characterUppercase: characterUppercase)

        // font size
        switch model.type {
        case
        Key.KeyType.modeChange,
        Key.KeyType.space,
        Key.KeyType.return:
            key.label.adjustsFontSizeToFitWidth = true
            key.label.font = key.label.font.withSize(16)
        default:
            key.label.font = fontForKeyWithText(key.text, keytype: model.type)
        }

        if fullReset {
            // label inset
            switch model.type {
            case
            Key.KeyType.modeChange:
                key.labelInset = 3
            default:
                key.labelInset = 0
            }

            // shapes
            switch model.type {
            case Key.KeyType.shift:
                if key.shape == nil {
                    let shiftShape = self.getShape(ShiftShape.self)
                    key.shape = shiftShape
                }
            case Key.KeyType.backspace:
                if key.shape == nil {
                    let backspaceShape = self.getShape(BackspaceShape.self)
                    key.shape = backspaceShape
                }
            case Key.KeyType.keyboardChange:
                if key.shape == nil {
                    let globeShape = self.getShape(GlobeShape.self)
                    key.shape = globeShape
                }
            default:
                break
            }

            // images
            if model.type == Key.KeyType.settings {
                if let imageKey = key as? DscribeImageKey {
                    if imageKey.image == nil {
                        imageKey.bigImage = false
                        let gearImage = UIImage(named: "gear")
                        let settingsImageView = UIImageView(image: gearImage)
                        imageKey.image = settingsImageView
                    }
                }
            }
            if model.type == Key.KeyType.searchEmoji {
                if let imageKey = key as? DscribeImageKey {
                    if true { //imageKey.image == nil {
                        imageKey.bigImage = true
                        let keyIcon = UIImage(named: (self.inSearchMode ? "IconWhite" : "Icon"))
                        let emojiImageView = UIImageView(image: keyIcon)
                        imageKey.image = emojiImageView
                    }
                }
            }
        }

        if model.type == Key.KeyType.shift {
            if key.shape == nil {
                let shiftShape = self.getShape(ShiftShape.self)
                key.shape = shiftShape
            }

            switch shiftState {
            case .disabled:
                key.isHighlighted = false
            case .enabled:
                key.isHighlighted = true
            case .locked:
                key.isHighlighted = true
            }

            (key.shape as? ShiftShape)?.withLock = (shiftState == .locked)
        }
    }

    override func generateKeyFrames(_ model: Keyboard, bounds: CGRect, page pageToLayout: Int) -> [Key:CGRect]? {
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

//        let flexibleEndRowM = (isLandscape ? self.layoutConstants.flexibleEndRowTotalWidthToKeyWidthMLandscape : self.layoutConstants.flexibleEndRowTotalWidthToKeyWidthMPortrait)
//        let flexibleEndRowC = (isLandscape ? self.layoutConstants.flexibleEndRowTotalWidthToKeyWidthCLandscape : self.layoutConstants.flexibleEndRowTotalWidthToKeyWidthCPortrait)

        let lastRowLeftSideRatio = (isLandscape ? self.layoutConstants.lastRowLandscapeFirstTwoButtonAreaWidthToKeyboardAreaWidth : self.layoutConstants.lastRowPortraitFirstTwoButtonAreaWidthToKeyboardAreaWidth)
        let lastRowRightSideRatio = (isLandscape ? self.layoutConstants.lastRowLandscapeLastButtonAreaWidthToKeyboardAreaWidth : self.layoutConstants.lastRowPortraitLastButtonAreaWidthToKeyboardAreaWidth)
        let lastRowKeyGap = (isLandscape ? self.layoutConstants.lastRowKeyGapLandscape(bounds.width) : self.layoutConstants.lastRowKeyGapPortrait)

        for (p, page) in model.pages.enumerated() {
            if p != pageToLayout {
                continue
            }

            let numRows = page.rows.count

            let mostKeysInRow: Int = {
                var currentMax: Int = 0
                for (_, row) in page.rows.enumerated() {
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

            let processRow = { (row: [Key], frames: [CGRect], map: inout [Key:CGRect]) -> Void in
                assert(row.count == frames.count, "row and frames don't match")
                for (k, key) in row.enumerated() {
                    map[key] = frames[k]
                }
            }

            for (r, row) in page.rows.enumerated() {
                let rowGapCurrentTotal = (r == page.rows.count - 1 ? rowGapTotal : CGFloat(r) * rowGap)
                let frame = CGRect(x: rounded(sideEdges), y: rounded(topEdge + (CGFloat(r) * keyHeight) + rowGapCurrentTotal), width: rounded(bounds.width - CGFloat(2) * sideEdges), height: rounded(keyHeight))

                var frames: [CGRect]!

                // basic character row: only typable characters
                if self.characterRowHeuristic(row) {
                    frames = self.layoutCharacterRow(row, keyWidth: letterKeyWidth, gapWidth: keyGap, frame: frame)
                } else if self.doubleSidedRowHeuristic(row) { // character row with side buttons: shift, backspace, etc.
                    //DIFFERENCE with superclass method
                    frames = (p == 0 ? self.layoutCharacterWithSidesRowNonFlexibleKeys : self.layoutCharacterWithSidesRow)(row, frame, isLandscape, letterKeyWidth, keyGap)
                } else { // bottom row with things like space, return, etc.
                    frames = self.layoutSpecialKeysRow(row, keyWidth: letterKeyWidth, gapWidth: lastRowKeyGap, leftSideRatio: lastRowLeftSideRatio, rightSideRatio: lastRowRightSideRatio, micButtonRatio: self.layoutConstants.micButtonPortraitWidthRatioToOtherSpecialButtons, isLandscape: isLandscape, frame: frame)
                }

                processRow(row, frames, &keyMap)
            }
        }

        return keyMap
    }

    func layoutCharacterWithSidesRowNonFlexibleKeys(_ row: [Key], frame: CGRect, isLandscape: Bool, keyWidth: CGFloat, keyGap: CGFloat) -> [CGRect] {
        var frames = [CGRect]()

        let standardFullKeyCount = Int(self.layoutConstants.keyCompressedThreshhold) - 1
        let standardGap = (isLandscape ? self.layoutConstants.keyGapLandscape : self.layoutConstants.keyGapPortrait)(frame.width, standardFullKeyCount)
        let sideEdges = (isLandscape ? self.layoutConstants.sideEdgesLandscape : self.layoutConstants.sideEdgesPortrait(frame.width))
        var standardKeyWidth = (frame.width - sideEdges - (standardGap * CGFloat(standardFullKeyCount - 1)) - sideEdges)
        standardKeyWidth /= CGFloat(standardFullKeyCount)
        let standardKeyCount = self.layoutConstants.flexibleEndRowMinimumStandardCharacterWidth

        let standardWidth = CGFloat(standardKeyWidth * standardKeyCount + standardGap * (standardKeyCount - 1))
        let currentWidth = CGFloat(row.count - 2) * keyWidth + CGFloat(row.count - 3) * keyGap

        let isStandardWidth = (currentWidth < standardWidth)
        let actualWidth = currentWidth // (isStandardWidth ? standardWidth : currentWidth)
        let actualGap = (isStandardWidth ? standardGap : keyGap)
        let actualKeyWidth = (actualWidth - CGFloat(row.count - 3) * actualGap) / CGFloat(row.count - 2)

        let sideSpace = (frame.width - actualWidth) / CGFloat(2)

        let m = (isLandscape ? self.layoutConstants.flexibleEndRowTotalWidthToKeyWidthMLandscape : self.layoutConstants.flexibleEndRowTotalWidthToKeyWidthMPortrait)
        let c = (isLandscape ? self.layoutConstants.flexibleEndRowTotalWidthToKeyWidthCLandscape : self.layoutConstants.flexibleEndRowTotalWidthToKeyWidthCPortrait)

        var specialCharacterWidth = sideSpace * m + c
        specialCharacterWidth = ((frame.width - standardWidth) / CGFloat(2)) * m + c
        specialCharacterWidth = max(specialCharacterWidth, keyWidth)
        specialCharacterWidth = rounded(specialCharacterWidth)
        let specialCharacterGap = sideSpace - specialCharacterWidth

        var currentOrigin = frame.origin.x
        for (k, _) in row.enumerated() {
            if k == 0 {
                frames.append(CGRect(x: rounded(currentOrigin), y: frame.origin.y, width: specialCharacterWidth, height: frame.height))
                currentOrigin += (specialCharacterWidth + specialCharacterGap)
            } else if k == row.count - 1 {
                currentOrigin += specialCharacterGap
                frames.append(CGRect(x: rounded(currentOrigin), y: frame.origin.y, width: specialCharacterWidth, height: frame.height))
                currentOrigin += specialCharacterWidth
            } else {
                frames.append(CGRect(x: rounded(currentOrigin), y: frame.origin.y, width: actualKeyWidth, height: frame.height))
                if k == row.count - 2 {
                    currentOrigin += (actualKeyWidth)
                } else {
                    currentOrigin += (actualKeyWidth + keyGap)
                }
            }
        }

        return frames
    }
    override func layoutSpecialKeysRow(_ row: [Key], keyWidth: CGFloat, gapWidth: CGFloat, leftSideRatio: CGFloat, rightSideRatio: CGFloat, micButtonRatio: CGFloat, isLandscape: Bool, frame: CGRect) -> [CGRect] {
        var frames = [CGRect]()

        var keysBeforeSpace = 0
        var keysAfterSpace = 0
        var reachedSpace = false
        for (_, key) in row.enumerated() {
            if key.type == Key.KeyType.space {
                reachedSpace = true
            } else {
                if !reachedSpace {
                    keysBeforeSpace += 1
                } else {
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
        for (k, key) in row.enumerated() {
            if key.type == Key.KeyType.space {
                frames.append(CGRect(x: rounded(currentOrigin), y: frame.origin.y, width: spaceWidth, height: frame.height))
                currentOrigin += (spaceWidth + gapWidth)
                beforeSpace = false
            } else if beforeSpace {
                if hasButtonInMicButtonPosition && k == 2 { //mic button position
                    frames.append(CGRect(x: rounded(currentOrigin), y: frame.origin.y, width: micButtonWidth, height: frame.height))
                    currentOrigin += (micButtonWidth + gapWidth)
                } else {
                    frames.append(CGRect(x: rounded(currentOrigin), y: frame.origin.y, width: leftButtonWidth, height: frame.height))
                    currentOrigin += (leftButtonWidth + gapWidth)
                }
            } else {
                frames.append(CGRect(x: rounded(currentOrigin), y: frame.origin.y, width: rightButtonWidth, height: frame.height))
                currentOrigin += (rightButtonWidth + gapWidth)
            }
        }

        return frames
    }

    override func setAppearanceForKey(_ key: KeyboardKey, model: Key, darkMode: Bool, solidColorMode: Bool) {
        if model.type == Key.KeyType.searchEmoji {
            // TODO:  use this function "setAppearanceForOtherKey" and type Other and type instead of overriding this function
            key.color = (self.inSearchMode ? UIColor(red: 250.0/255, green: 193.0/255, blue: 62.0/255, alpha: 1.0) : self.globalColors.regularKey(darkMode, solidColorMode: solidColorMode))
            key.downColor = self.globalColors.specialKey(darkMode, solidColorMode: solidColorMode)
        } else if model.type == Key.KeyType.accentCharacter {
            //Same as Character and SpecialCharacter
            key.color = self.self.globalColors.regularKey(darkMode, solidColorMode: solidColorMode)
            if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                key.downColor = self.globalColors.specialKey(darkMode, solidColorMode: solidColorMode)
            }
            else {
                key.downColor = nil
            }
            key.textColor = (darkMode ? self.globalColors.darkModeTextColor : self.globalColors.lightModeTextColor)
            key.downTextColor = nil
        }
        super.setAppearanceForKey(key, model: model, darkMode: darkMode, solidColorMode: solidColorMode)
    }

    override func createNewKey() -> KeyboardKey {
        return DscribeImageKey(vibrancy: nil)
    }
}
