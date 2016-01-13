//
//  DscribeSettings.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 08/01/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

let kLanguagePicker: String = "kLanguagePicker"

class DscribeSettings: DefaultSettings, PickerDelegate {
    var availableLanguages: [String] = [String]()
    var availableLanguagesCodes: [String] = [String]()

    var displayLanguagePicker: Bool = false

    override var settingsList: [(String, [String])] {
        get {
            return super.settingsList + [
                ("Autocorrect Settings", [kAutoReplace, kAutocorrectLanguage, kLanguagePicker])
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
                kAutoReplace: "Replace Automatically",
                kAutocorrectLanguage: "Language"
            ]
        }
    }
    override var settingsNotes: [String: String] {
        get {
            return [
                kKeyboardClicks: "Please note that keyboard clicks will work only if “Allow Full Access” is enabled in the keyboard settings. Unfortunately, this is a limitation of the operating system.",
                kSmallLowercase: "Changes your key caps to lowercase when Shift is off, making it easier to tell what mode you are in.",
                kAutoReplace: "The suggested word will be automatically replaced on pressing space if there is a spelling mistake."
            ]
        }
    }

    required init(globalColors: GlobalColors.Type?, darkMode: Bool, solidColorMode: Bool) {
        super.init(globalColors: globalColors, darkMode: darkMode, solidColorMode: solidColorMode)

        getAvailableLanguages()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadNib() {
        super.loadNib()
        self.tableView?.registerClass(LanguageSettingCell.self, forCellReuseIdentifier: "languageCell")
        self.tableView?.registerClass(PickerViewCell.self, forCellReuseIdentifier: "languagePicker")
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !displayLanguagePicker && self.settingsList[section].0 == "Language Settings" {
            return self.settingsList[section].1.count - 1
        }
        return self.settingsList[section].1.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let key = self.settingsList[indexPath.section].1[indexPath.row]

        if key == kAutocorrectLanguage {
            if let languageCell = tableView.dequeueReusableCellWithIdentifier("languageCell") as? LanguageSettingCell {

                languageCell.label.text = self.settingsNames[key]
                languageCell.longLabel.text = self.settingsNotes[key]
                languageCell.labelDisplay.setTitle(self.availableLanguages[self.indexOfCurrentLanguage()!], forState: UIControlState.Normal)
                languageCell.labelDisplay.setTitleColor((self.darkMode ? cellLabelColorDark : cellLabelColorLight), forState: UIControlState.Normal)

                languageCell.labelDisplay.addTarget(self, action: Selector("toggleLanguagePicker"), forControlEvents: UIControlEvents.TouchUpInside)

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
        if key == kLanguagePicker {
            if let pickerCell = tableView.dequeueReusableCellWithIdentifier("languagePicker") as? PickerViewCell {
                pickerCell.data = availableLanguages
                pickerCell.pickerView.reloadAllComponents()
                pickerCell.pickerView.selectRow(self.indexOfCurrentLanguage()!, inComponent: 0, animated: false)

                pickerCell.key = kAutocorrectLanguage
                pickerCell.indexPath = indexPath
                pickerCell.delegate = self

                return pickerCell
            }
            else {
                assert(false, "this is a bad thing that just happened dscribe")
                return UITableViewCell()
            }
        }
        if let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? DefaultSettingsTableViewCell {

            if cell.sw.allTargets().count == 0 {
                cell.sw.addTarget(self, action: Selector("toggleSetting:"), forControlEvents: UIControlEvents.ValueChanged)
            }

            cell.sw.on = NSUserDefaults(suiteName: "group.dscribekeyboard")!.boolForKey(key)
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
    override func toggleSetting(sender: UISwitch) {
        if let cell = sender.superview as? UITableViewCell {
            if let indexPath = self.tableView?.indexPathForCell(cell) {
                let key = self.settingsList[indexPath.section].1[indexPath.row]
                NSUserDefaults(suiteName: "group.dscribekeyboard")!.setBool(sender.on, forKey: key)
            }
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Selected row at index path")
        print(indexPath)
        if self.settingsList[indexPath.section].1[indexPath.row] == kAutocorrectLanguage {
            displayLanguagePicker = !displayLanguagePicker
//            self.tableView?.reloadData()
            self.tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    func toggleLanguagePicker() {
        print("Clicked lang button")
        displayLanguagePicker = !displayLanguagePicker
        self.tableView?.reloadData()
    }
    func getAvailableLanguages() {
        availableLanguagesCodes = (UITextChecker.availableLanguages() as! [String]).sort({ $0 < $1 })

        var languageDict: [String: String] = [String: String]()
        for language in availableLanguagesCodes {
            let codes: [String] = language.componentsSeparatedByString("_")
            var wholeString: String = NSLocale(localeIdentifier: "en").displayNameForKey(NSLocaleLanguageCode, value: codes[0])!
            if codes.count > 1 {
                wholeString += " - " + NSLocale(localeIdentifier: codes[0]).displayNameForKey(NSLocaleCountryCode, value: codes[1])!
            }
            languageDict[language] = wholeString
//            availableLanguages.append(wholeString)
        }

        //Proper sort
        let sorted = languageDict.sort({ $0.1 < $1.1 })
        availableLanguages = [String]()
        availableLanguagesCodes = [String]()
        for tuple in sorted {
            availableLanguagesCodes.append(tuple.0)
            availableLanguages.append(tuple.1)
        }
    }
    func indexOfCurrentLanguage() -> Int? {
        let defaultLanguage: String? = NSUserDefaults(suiteName: "group.dscribekeyboard")!.objectForKey(kAutocorrectLanguage) as? String
        print("Getting index " + String(NSUserDefaults(suiteName: "group.dscribekeyboard")!.objectForKey(kAutocorrectLanguage)))
        if defaultLanguage == nil {
            return 0
        }
        let index: Int? = availableLanguagesCodes.indexOf({ $0 == defaultLanguage! })
        if index == nil {
            return 0
        }
        return index
    }
    // PICKER DELEGATE
    func updateValue(value: AnyObject, key: String, indexPath: NSIndexPath) {
        if key == kAutocorrectLanguage {
            if let language: String = value as? String {
                let index: Int? = availableLanguages.indexOf({ $0 == language })
                if index == nil {
                    return
                }
                NSUserDefaults(suiteName: "group.dscribekeyboard")!.setObject(availableLanguagesCodes[index!], forKey: kAutocorrectLanguage)
                (self.tableView!.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)) as? LanguageSettingCell)?.labelDisplay.setTitle(language, forState: UIControlState.Normal)
            }
        }
    }
}

class LanguageSettingCell: DefaultSettingsTableViewCell {
    var labelDisplay: UIButton

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.labelDisplay = UIButton()

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