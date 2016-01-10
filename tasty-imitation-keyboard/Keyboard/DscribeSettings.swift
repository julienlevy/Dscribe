//
//  DscribeSettings.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 08/01/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class DscribeSettings: DefaultSettings {
    override var settingsList: [(String, [String])] {
        get {
            return super.settingsList + [
                ("Language Settings", [kAutocorrectLanguage])
            ]
        }
    }
    override var settingsNames: [String:String] {
        get {
            return [
                kAutoCapitalization: "Auto-Capitalization",
                kPeriodShortcut:  "“.” Shortcut",
                kKeyboardClicks: "Keyboard Clicks",
                kSmallLowercase: "Allow Lowercase Key Caps",
                kAutocorrectLanguage: "Autocorrect"
            ]
        }
    }
    override var settingsNotes: [String: String] {
        get {
            return [
                kKeyboardClicks: "Please note that keyboard clicks will work only if “Allow Full Access” is enabled in the keyboard settings. Unfortunately, this is a limitation of the operating system.",
                kSmallLowercase: "Changes your key caps to lowercase when Shift is off, making it easier to tell what mode you are in."
            ]
        }
    }

    override func loadNib() {
        super.loadNib()
        self.tableView?.registerClass(LanguageSettingCell.self, forCellReuseIdentifier: "languageCell")
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == settingsList.count - 1 {
            if let languageCell = tableView.dequeueReusableCellWithIdentifier("languageCell") as? LanguageSettingCell {
                let key = self.settingsList[indexPath.section].1[indexPath.row]

                languageCell.label.text = self.settingsNames[key]
                languageCell.longLabel.text = self.settingsNotes[key]

                languageCell.backgroundColor = (self.darkMode ? cellBackgroundColorDark : cellBackgroundColorLight)
                languageCell.label.textColor = (self.darkMode ? cellLabelColorDark : cellLabelColorLight)
                languageCell.longLabel.textColor = (self.darkMode ? cellLongLabelColorDark : cellLongLabelColorLight)

                languageCell.changeConstraints()
                
                return languageCell
            }
            else {
                assert(false, "this is a bad thing that just happened dscribe")
                return UITableViewCell()
            }
        }
        if let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? DefaultSettingsTableViewCell {
            let key = self.settingsList[indexPath.section].1[indexPath.row]

            if cell.sw.allTargets().count == 0 {
                cell.sw.addTarget(self, action: Selector("toggleSetting:"), forControlEvents: UIControlEvents.ValueChanged)
            }

            cell.sw.on = NSUserDefaults.standardUserDefaults().boolForKey(key)
            cell.label.text = self.settingsNames[key]
            cell.longLabel.text = self.settingsNotes[key]

            cell.backgroundColor = (self.darkMode ? cellBackgroundColorDark : cellBackgroundColorLight)
            cell.label.textColor = (self.darkMode ? cellLabelColorDark : cellLabelColorLight)
            cell.longLabel.textColor = (self.darkMode ? cellLongLabelColorDark : cellLongLabelColorLight)

            cell.changeConstraints()

            return cell
        }
        else {
            assert(false, "this is a bad thing that just happened")
            return UITableViewCell()
        }
    }
}

class LanguageSettingCell: DefaultSettingsTableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    var languagePicker: UIPickerView?
    var languageDisplay: UIButton
    var showPicker: Bool = false
    var pickerIsShown: Bool = false

    var cellHeightConstraint: NSLayoutConstraint?
    var pickerHeightConstraint: NSLayoutConstraint?
    var pickerIsOpen: Bool = false

    var availableLanguages: [String] = [String]()
    var availableLanguagesCodes: [AnyObject] = [AnyObject]()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.languageDisplay = UIButton()
        self.languagePicker = UIPickerView()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.sw.hidden = true

        languageDisplay.tag = 4
        self.languagePicker!.tag = 5

        self.addSubview(self.languagePicker!)
        self.addSubview(languageDisplay)
        
        self.languageDisplay.translatesAutoresizingMaskIntoConstraints = false
        self.languagePicker!.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraints()

        self.getAvailableLanguages()
        self.languagePicker!.delegate = self
        self.selectCurrentLanguage()

        languageDisplay.addTarget(self, action: Selector("togglePickerView"), forControlEvents: UIControlEvents.TouchUpInside)
        languageDisplay.backgroundColor = UIColor.blueColor()
        languagePicker?.backgroundColor = UIColor.greenColor()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func addConstraints() {
        if self.languageDisplay.superview == nil {
            return
        }
        let margin: CGFloat = 8
        let sideMargin = margin * 2
        
        let hasLongText = self.longLabel.text != nil && !self.longLabel.text.isEmpty
        if hasLongText {
            let switchSide = NSLayoutConstraint(
                item: languageDisplay, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal,
                toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1,
                constant: -sideMargin)
            let switchTop = NSLayoutConstraint(
                item: languageDisplay, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
                toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1,
                constant: margin)
            let labelSide = NSLayoutConstraint(
                item: label, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal,
                toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1,
                constant: sideMargin)
            let labelCenter = NSLayoutConstraint(
                item: label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal,
                toItem: languageDisplay, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)

            let languageHeight: NSLayoutConstraint = NSLayoutConstraint(item: languageDisplay, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 25)
            let languageWidth: NSLayoutConstraint = NSLayoutConstraint(item: languageDisplay, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)

            self.addConstraint(switchSide)
            self.addConstraint(switchTop)
            self.addConstraint(labelSide)
            self.addConstraint(labelCenter)
            self.addConstraint(languageHeight)
            self.addConstraint(languageWidth)

            let topPicker: NSLayoutConstraint = NSLayoutConstraint(item: languagePicker!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: languageDisplay, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: margin/2)
            let rightPicker: NSLayoutConstraint = NSLayoutConstraint(item: languagePicker!, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -sideMargin)
            let leftPicker = NSLayoutConstraint(item: languagePicker!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: sideMargin)
            pickerHeightConstraint = NSLayoutConstraint(item: languagePicker!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 0)
            self.addConstraints([topPicker, rightPicker, leftPicker, pickerHeightConstraint!])
            
            let left = NSLayoutConstraint(item: longLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: sideMargin)
            let right = NSLayoutConstraint(item: longLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -sideMargin)
            let top = NSLayoutConstraint(item: longLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: languagePicker!, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: margin)
            let bottom = NSLayoutConstraint(item: longLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -margin)
            
            self.addConstraint(left)
            self.addConstraint(right)
            self.addConstraint(top)
            self.addConstraint(bottom)
            
            self.cellConstraints += [switchSide, switchTop, labelSide, labelCenter, left, right, top, bottom, topPicker, rightPicker, leftPicker, languageHeight, languageWidth, pickerHeightConstraint!]
            
            self.constraintsSetForLongLabel = true
        }
        else {
            let switchSide = NSLayoutConstraint(
                item: languageDisplay, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal,
                toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1,
                constant: -sideMargin)
            let switchTop = NSLayoutConstraint(
                item: languageDisplay, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
                toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1,
                constant: margin)
            let labelSide = NSLayoutConstraint(
                item: label, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal,
                toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1,
                constant: sideMargin)
            let labelCenter = NSLayoutConstraint(
                item: label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal,
                toItem: languageDisplay, attribute: NSLayoutAttribute.CenterY, multiplier: 1,
                constant: 0)

            let languageHeight: NSLayoutConstraint = NSLayoutConstraint(
                item: languageDisplay, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
                toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1,
                constant: 28)
            let languageWidth: NSLayoutConstraint = NSLayoutConstraint(item: languageDisplay, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)

            let topPicker: NSLayoutConstraint = NSLayoutConstraint(
                item: languagePicker!, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal,
                toItem: label, attribute: NSLayoutAttribute.Bottom, multiplier: 1,
                constant: margin)
            let rightPicker: NSLayoutConstraint = NSLayoutConstraint(
                item: languagePicker!, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal,
                toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1,
                constant: -sideMargin)
            let leftPicker = NSLayoutConstraint(
                item: languagePicker!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal,
                toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1,
                constant: sideMargin)
            let bottomPicker = NSLayoutConstraint(
                item: languagePicker!, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal,
                toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1,
                constant: 0)

            if showPicker {
                pickerHeightConstraint = NSLayoutConstraint(
                    item: languagePicker!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
                    toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 80)
                pickerIsShown = true
                print("picker height set to 80")
            }
            else {
                pickerHeightConstraint = NSLayoutConstraint(
                    item: languagePicker!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
                    toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 0)
                pickerIsShown = false
            }
            cellHeightConstraint = NSLayoutConstraint(
                item: self, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal,
                toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 2 * margin + 58)
            
//            self.addConstraints([switchSide, switchTop, switchBottom, labelSide, labelCenter, topPicker, rightPicker, leftPicker, languageHeight, languageWidth, pickerHeightConstraint!, cellHeightConstraint!])
//            self.addConstraints([switchSide, switchTop, labelSide, labelCenter, languageHeight, languageWidth, cellHeightConstraint!])
            self.addConstraints([switchSide, switchTop, labelSide, labelCenter, languageWidth, topPicker, rightPicker, leftPicker, bottomPicker, pickerHeightConstraint!])
            
//            self.cellConstraints += [switchSide, switchTop, switchBottom, labelSide, labelCenter, topPicker, rightPicker, leftPicker, languageHeight, languageWidth, pickerHeightConstraint!, cellHeightConstraint!]
            self.cellConstraints += [switchSide, switchTop, labelSide, labelCenter, languageWidth, topPicker, rightPicker, leftPicker, bottomPicker, pickerHeightConstraint!]

            self.constraintsSetForLongLabel = false
        }
    }
    override func changeConstraints() {
        let hasLongText = self.longLabel.text != nil && !self.longLabel.text.isEmpty
        if hasLongText != self.constraintsSetForLongLabel || showPicker != pickerIsShown {
            self.removeConstraints(self.cellConstraints)
            self.cellConstraints.removeAll()
            self.addConstraints()
        }
    }

    func togglePickerView() {
        print("Height constant before " + String(self.pickerHeightConstraint?.constant))
        pickerIsOpen = !pickerIsOpen
        if pickerIsOpen {
//            self.pickerHeightConstraint?.constant = 80
//            languagePicker?.hidden = false
            showPicker = true
        } else {
//            self.pickerHeightConstraint?.constant = 0
//            languagePicker?.hidden = true
            showPicker = false
        }
        print("Height constant after " + String(self.pickerHeightConstraint?.constant))
        self.changeConstraints()
//        self.layoutIfNeeded()
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.availableLanguages.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return availableLanguages[row]
    }
//    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
//        var labelView: UILabel? = view as? UILabel
//        if labelView == nil {
//            labelView = UILabel()
//            labelView!.font = UIFont.systemFontOfSize(16.0)
//        }
//        labelView!.text = availableLanguages[row]
//        return labelView!
//    }
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let code: String? = availableLanguagesCodes[row] as? String
        if code == nil {
            return
        }
        languageDisplay.setTitle(availableLanguages[row], forState: UIControlState.Normal)
        NSUserDefaults.standardUserDefaults().setObject(code!, forKey: kAutocorrectLanguage)
    }

    func getAvailableLanguages() {
        availableLanguagesCodes = UITextChecker.availableLanguages().sort({ ($0 as! String) < ($1 as! String) })

        for item in availableLanguagesCodes {
            let language: String? = item as? String
            if language == nil {
                continue
            }
            let codes: [String] = language!.componentsSeparatedByString("_")
            var wholeString: String = NSLocale(localeIdentifier: "en").displayNameForKey(NSLocaleLanguageCode, value: codes[0])!
            if codes.count > 1 {
                wholeString += " - " + NSLocale(localeIdentifier: codes[0]).displayNameForKey(NSLocaleCountryCode, value: codes[1])!
            }
            availableLanguages.append(wholeString)
        }
    }
    func selectCurrentLanguage() {
        let defaultLanguage: String? = NSUserDefaults.standardUserDefaults().objectForKey(kAutocorrectLanguage) as? String
        if defaultLanguage == nil {
            return
        }
        let index: Int? = availableLanguagesCodes.indexOf({ $0 as! String == defaultLanguage! })
        if index == nil {
            return
        }
        languageDisplay.setTitle(availableLanguages[index!], forState: UIControlState.Normal)
        languagePicker?.selectRow(index!, inComponent: 0, animated: false)
        self.layoutIfNeeded()
    }
}










