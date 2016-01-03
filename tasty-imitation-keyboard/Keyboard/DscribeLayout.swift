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
        if fullReset {
            // font size
            switch model.type {
            case
            Key.KeyType.ModeChange,
            Key.KeyType.Space,
            Key.KeyType.Return:
                key.label.adjustsFontSizeToFitWidth = true
                key.label.font = key.label.font.fontWithSize(16)
            default:
                key.label.font = key.label.font.fontWithSize(24)
                if #available(iOSApplicationExtension 8.2, *) {
                    key.label.font = UIFont.systemFontOfSize(24, weight: UIFontWeightLight)
                }
            }

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
            case Key.KeyType.SearchEmoji:
                if key.shape == nil {
                    let emojiShape = self.getShape(EmojiShape)
                    key.shape = emojiShape
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
        
        self.updateKeyCapText(key, model: model, uppercase: uppercase, characterUppercase: characterUppercase)
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
}
