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
                
                if languageCell.sw.allTargets().count == 0 {
                    languageCell.sw.addTarget(self, action: Selector("toggleSetting:"), forControlEvents: UIControlEvents.ValueChanged)
                }
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
    var availableLanguages: [String] = [String]()
    var availableLanguagesCodes: [AnyObject] = [AnyObject]()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.getAvailableLanguages()

        self.languagePicker = UIPickerView()
        print("After init of picker")
        self.languagePicker!.translatesAutoresizingMaskIntoConstraints = false
        self.languagePicker!.tag = 4
        self.languagePicker!.delegate = self
        self.addSubview(self.languagePicker!)

        self.languagePicker!.addConstraints(self.sw.constraints)
        let centerPicker = NSLayoutConstraint(item: languagePicker!, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: sw, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let rightPicker: NSLayoutConstraint = NSLayoutConstraint(item: languagePicker!, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: sw, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let heigthPicker: NSLayoutConstraint = NSLayoutConstraint(item: languagePicker!, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        let leftPicker: NSLayoutConstraint = NSLayoutConstraint(item: languagePicker!, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        self.addConstraint(centerPicker)
        self.addConstraint(rightPicker)
        self.addConstraint(heigthPicker)
        self.addConstraint(leftPicker)

        self.sw.hidden = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.availableLanguages.count
    }
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        var labelView: UILabel? = view as? UILabel
        if labelView == nil {
            labelView = UILabel()
            labelView!.font = UIFont.systemFontOfSize(16.0)
        }
        labelView!.text = availableLanguages[row]
        return labelView!
    }
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(self.availableLanguages[row])
        print(self.availableLanguagesCodes[row])
        let code: String? = availableLanguagesCodes[row] as? String
        if code == nil {
            return
        }
        NSUserDefaults.standardUserDefaults().setObject(code!, forKey: kAutocorrectLanguage)
    }

    func getAvailableLanguages() {
        availableLanguagesCodes = UITextChecker.availableLanguages()

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
}










