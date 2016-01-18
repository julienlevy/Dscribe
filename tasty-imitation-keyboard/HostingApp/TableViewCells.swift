//
//  TableViewCells.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 12/01/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class DefaultSettingsTableViewCell: UITableViewCell {
    
    var sw: UISwitch
    var label: UILabel
    var longLabel: UITextView
    var constraintsSetForLongLabel: Bool
    var cellConstraints: [NSLayoutConstraint]
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.sw = UISwitch()
        self.label = UILabel()
        self.longLabel = UITextView()
        self.cellConstraints = []

        self.constraintsSetForLongLabel = false

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.sw.translatesAutoresizingMaskIntoConstraints = false
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.longLabel.translatesAutoresizingMaskIntoConstraints = false

        self.longLabel.text = nil
        self.longLabel.scrollEnabled = false
        self.longLabel.selectable = false
        self.longLabel.backgroundColor = UIColor.clearColor()

        self.sw.tag = 1
        self.label.tag = 2
        self.longLabel.tag = 3

        self.addSubview(self.sw)
        self.addSubview(self.label)
        self.addSubview(self.longLabel)

        self.addConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addConstraints() {
        let margin: CGFloat = 8
        let sideMargin = margin * 2

        let hasLongText = self.longLabel.text != nil && !self.longLabel.text.isEmpty
        if hasLongText {
            let switchSide = NSLayoutConstraint(item: sw, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -sideMargin)
            let switchTop = NSLayoutConstraint(item: sw, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: margin)
            let labelSide = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: sideMargin)
            let labelCenter = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: sw, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)

            self.addConstraint(switchSide)
            self.addConstraint(switchTop)
            self.addConstraint(labelSide)
            self.addConstraint(labelCenter)

            let left = NSLayoutConstraint(item: longLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: sideMargin)
            let right = NSLayoutConstraint(item: longLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -sideMargin)
            let top = NSLayoutConstraint(item: longLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: sw, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: margin)
            let bottom = NSLayoutConstraint(item: longLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -margin)

            self.addConstraint(left)
            self.addConstraint(right)
            self.addConstraint(top)
            self.addConstraint(bottom)

            self.cellConstraints += [switchSide, switchTop, labelSide, labelCenter, left, right, top, bottom]

            self.constraintsSetForLongLabel = true
        }
        else {
            let switchSide = NSLayoutConstraint(item: sw, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -sideMargin)
            let switchTop = NSLayoutConstraint(item: sw, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: margin)
            let switchBottom = NSLayoutConstraint(item: sw, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -margin)
            let labelSide = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: sideMargin)
            let labelCenter = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: sw, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)

            self.addConstraint(switchSide)
            self.addConstraint(switchTop)
            self.addConstraint(switchBottom)
            self.addConstraint(labelSide)
            self.addConstraint(labelCenter)

            self.cellConstraints += [switchSide, switchTop, switchBottom, labelSide, labelCenter]

            self.constraintsSetForLongLabel = false
        }
    }

    // XXX: not in updateConstraints because it doesn't play nice with UITableViewAutomaticDimension for some reason
    func changeConstraints() {
        let hasLongText = self.longLabel.text != nil && !self.longLabel.text.isEmpty
        if hasLongText != self.constraintsSetForLongLabel {
            self.removeConstraints(self.cellConstraints)
            self.cellConstraints.removeAll()
            self.addConstraints()
        }
    }
}

class InformationCell: DefaultSettingsTableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.sw.hidden = true
        self.longLabel.font = UIFont.systemFontOfSize(12.0)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addConstraints() {
        let margin: CGFloat = 8
        let sideMargin = margin * 2

        let switchSide = NSLayoutConstraint(item: sw, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -sideMargin)
        let switchTop = NSLayoutConstraint(item: sw, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: margin)
        let labelSide = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: sideMargin)
        let labelCenter = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: sw, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        
        self.addConstraint(switchSide)
        self.addConstraint(switchTop)
        self.addConstraint(labelSide)
        self.addConstraint(labelCenter)
        
        let left = NSLayoutConstraint(item: longLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: sideMargin)
        let right = NSLayoutConstraint(item: longLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -sideMargin)
        let top = NSLayoutConstraint(item: longLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: label, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: margin)
        let bottom = NSLayoutConstraint(item: longLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -margin)
        
        self.addConstraint(left)
        self.addConstraint(right)
        self.addConstraint(top)
        self.addConstraint(bottom)
        
        self.cellConstraints += [switchSide, switchTop, labelSide, labelCenter, left, right, top, bottom]
        
        self.constraintsSetForLongLabel = true
    }
}
class StaticSettingCell: DefaultSettingsTableViewCell {
    var labelDisplay: UILabel

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.labelDisplay = UILabel()

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.sw.hidden = true

        labelDisplay.tag = 4

        self.addSubview(labelDisplay)

        self.labelDisplay.translatesAutoresizingMaskIntoConstraints = false

        self.addConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addConstraints() {
        super.addConstraints()
        if labelDisplay.superview == nil {
            return
        }
        let topLabel: NSLayoutConstraint = NSLayoutConstraint(item: labelDisplay, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: sw, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let rightLabel: NSLayoutConstraint = NSLayoutConstraint(item: labelDisplay, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: sw, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let bottomLabel: NSLayoutConstraint = NSLayoutConstraint(item: labelDisplay, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: sw, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.addConstraints([topLabel, rightLabel, bottomLabel])
    }
}

protocol PickerDelegate {
    func updateValue(value: AnyObject, key: String, indexPath: NSIndexPath)
}
class PickerViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    var pickerView: UIPickerView
    var data: [String] = [String]()

    var key: String = ""
    var indexPath: NSIndexPath?
    var delegate: PickerDelegate?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.pickerView = UIPickerView()

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.addSubview(self.pickerView)
        self.pickerView.delegate = self

        self.pickerView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addConstraints() {
        let margin: CGFloat = 8
        let sideMargin = margin * 2

        let left = NSLayoutConstraint(item: pickerView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: sideMargin)
        let right = NSLayoutConstraint(item: pickerView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -sideMargin)
        let top = NSLayoutConstraint(item: pickerView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: margin)
        let bottom = NSLayoutConstraint(item: pickerView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -margin)

        self.addConstraint(left)
        self.addConstraint(right)
        self.addConstraint(top)
        self.addConstraint(bottom)
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.delegate?.updateValue(data[row], key: key, indexPath: indexPath!)
    }
    func selectCurrentLanguage(language: String) {
        let index: Int? = data.indexOf({ $0 == language })
        if index == nil {
            return
        }
        pickerView.selectRow(index!, inComponent: 0, animated: false)
    }
}