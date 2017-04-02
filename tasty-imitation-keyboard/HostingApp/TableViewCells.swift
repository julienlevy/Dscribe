//
//  TableViewCells.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 12/01/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class DefaultSettingsTableViewCell: UITableViewCell {
    var switchItem: UISwitch
    var label: UILabel
    var longLabel: UITextView
    var constraintsSetForLongLabel: Bool
    var cellConstraints: [NSLayoutConstraint]

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.switchItem = UISwitch()
        self.label = UILabel()
        self.longLabel = UITextView()
        self.cellConstraints = []

        self.constraintsSetForLongLabel = false

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.switchItem.translatesAutoresizingMaskIntoConstraints = false
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.longLabel.translatesAutoresizingMaskIntoConstraints = false

        self.longLabel.text = nil
        self.longLabel.isScrollEnabled = false
        self.longLabel.isSelectable = false
        self.longLabel.backgroundColor = UIColor.clear

        self.switchItem.tag = 1
        self.label.tag = 2
        self.longLabel.tag = 3

        self.addSubview(self.switchItem)
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
            let switchSide = NSLayoutConstraint(item: switchItem, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -sideMargin)
            let switchTop = NSLayoutConstraint(item: switchItem, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: margin)
            let labelSide = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: sideMargin)
            let labelCenter = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: switchItem, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)

            self.addConstraint(switchSide)
            self.addConstraint(switchTop)
            self.addConstraint(labelSide)
            self.addConstraint(labelCenter)

            let left = NSLayoutConstraint(item: longLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: sideMargin)
            let right = NSLayoutConstraint(item: longLabel, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -sideMargin)
            let top = NSLayoutConstraint(item: longLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: switchItem, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: margin)
            let bottom = NSLayoutConstraint(item: longLabel, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -margin)

            self.addConstraint(left)
            self.addConstraint(right)
            self.addConstraint(top)
            self.addConstraint(bottom)

            self.cellConstraints += [switchSide, switchTop, labelSide, labelCenter, left, right, top, bottom]

            self.constraintsSetForLongLabel = true
        } else {
            let switchSide = NSLayoutConstraint(item: switchItem, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -sideMargin)
            let switchTop = NSLayoutConstraint(item: switchItem, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: margin)
            let switchBottom = NSLayoutConstraint(item: switchItem, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -margin)
            let labelSide = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: sideMargin)
            let labelCenter = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: switchItem, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)

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

        self.switchItem.isHidden = true
        self.longLabel.font = UIFont.systemFont(ofSize: 12.0)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addConstraints() {
        let margin: CGFloat = 8
        let sideMargin = margin * 2

        let switchSide = NSLayoutConstraint(item: switchItem, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -sideMargin)
        let switchTop = NSLayoutConstraint(item: switchItem, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: margin)
        let labelSide = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: sideMargin)
        let labelCenter = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: switchItem, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)

        self.addConstraint(switchSide)
        self.addConstraint(switchTop)
        self.addConstraint(labelSide)
        self.addConstraint(labelCenter)

        let left = NSLayoutConstraint(item: longLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: sideMargin)
        let right = NSLayoutConstraint(item: longLabel, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -sideMargin)
        let top = NSLayoutConstraint(item: longLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: label, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: margin)
        let bottom = NSLayoutConstraint(item: longLabel, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -margin)

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

        self.switchItem.isHidden = true

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
        let topLabel: NSLayoutConstraint = NSLayoutConstraint(item: labelDisplay, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: switchItem, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let rightLabel: NSLayoutConstraint = NSLayoutConstraint(item: labelDisplay, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: switchItem, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let bottomLabel: NSLayoutConstraint = NSLayoutConstraint(item: labelDisplay, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: switchItem, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        self.addConstraints([topLabel, rightLabel, bottomLabel])
    }
}

protocol PickerDelegate {
    func updateValue(_ value: AnyObject, key: String, indexPath: IndexPath)
}
class PickerViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    var pickerView: UIPickerView
    var data: [String] = [String]()

    var key: String = ""
    var indexPath: IndexPath?
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

        let left = NSLayoutConstraint(item: pickerView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: sideMargin)
        let right = NSLayoutConstraint(item: pickerView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -sideMargin)
        let top = NSLayoutConstraint(item: pickerView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: margin)
        let bottom = NSLayoutConstraint(item: pickerView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -margin)

        self.addConstraint(left)
        self.addConstraint(right)
        self.addConstraint(top)
        self.addConstraint(bottom)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.delegate?.updateValue(data[row] as AnyObject, key: key, indexPath: indexPath!)
    }
    func selectCurrentLanguage(_ language: String) {
        let index: Int? = data.index(where: { $0 == language })
        if index == nil {
            return
        }
        pickerView.selectRow(index!, inComponent: 0, animated: false)
    }
}
