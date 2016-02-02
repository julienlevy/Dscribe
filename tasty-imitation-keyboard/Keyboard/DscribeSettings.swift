//
//  DscribeSettings.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 08/01/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

let kInformation: String = "kInformation"
let kLanguagePicker: String = "kLanguagePicker"
let kKeyboardPicker: String = "kKeyboardPicker"

class DscribeSettings: DefaultSettings, PickerDelegate {
    var hasFullAccess: Bool

    var availableLanguages: [String] = [String]()
    var availableLanguagesCodes: [String] = [String]()
    var currentPickerLanguage: String = ""

    let keyboardTypes: [String] = [kQWERTY, kAZERTY]
    var currentPickerType: String = ""

    var displayLanguagePicker: Bool = false
    var displayTypePicker: Bool = false

    override var settingsList: [(String, [String])] {
        get {
            return
                (hasFullAccess ? [] : [("Information", [kInformation])])
                + [
                    ("General Settings", [kAutoCapitalization, kPeriodShortcut, kKeyboardClicks]),
                    ("Display Settings", [kSmallLowercase, kKeyboardType, kKeyboardPicker]),
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
                kAutocorrectLanguage: "Language",
                kKeyboardType: "Keyboard Type",
                kInformation: "Saving Settings"
            ]
        }
    }
    override var settingsNotes: [String: String] {
        get {
            return [
                kKeyboardClicks: "Please note that keyboard clicks will work only if “Allow Full Access” is enabled in the keyboard settings. Unfortunately, this is a limitation of the operating system.",
                kSmallLowercase: "Changes your key caps to lowercase when Shift is off, making it easier to tell what mode you are in.",
                kAutoReplace: "The suggested word will be automatically replaced on pressing space if there is a spelling mistake.",
                kInformation: "Unfortunately settings won't be saved properly unless “Allow Full Access is enabled“.\nYou may do so in Settings > General > Dscribe, or you may use the Dscribe app for the keyboard settings."
            ]
        }
    }

    required init(globalColors: GlobalColors.Type?, darkMode: Bool, solidColorMode: Bool) {
        self.hasFullAccess = false

        super.init(globalColors: globalColors, darkMode: darkMode, solidColorMode: solidColorMode)

        getAvailableLanguages()
        self.hasFullAccess = UIPasteboard.generalPasteboard().isKindOfClass(UIPasteboard)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadNib() {
        super.loadNib()
        self.tableView?.registerClass(StaticSettingCell.self, forCellReuseIdentifier: "staticCell")
        self.tableView?.registerClass(PickerViewCell.self, forCellReuseIdentifier: "pickerCell")
        self.tableView?.registerClass(InformationWithButtonCell.self, forCellReuseIdentifier: "informationCell")

        self.hasFullAccess = UIPasteboard.generalPasteboard().isKindOfClass(UIPasteboard)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows: Int = self.settingsList[section].1.count
        for row in 0...(rows-1) {
            // TODO: make this condition with an array when we might have more than one picker
            if (!displayLanguagePicker && self.settingsList[section].1[row] == kLanguagePicker) || (!displayTypePicker && self.settingsList[section].1[row] == kKeyboardPicker) {
                return self.settingsList[section].1.count - 1
            }
        }
        return self.settingsList[section].1.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let key = self.settingsList[indexPath.section].1[indexPath.row]

        if key == kAutocorrectLanguage || key == kKeyboardType {
            if let languageCell = tableView.dequeueReusableCellWithIdentifier("staticCell") as? StaticSettingCell {

                languageCell.label.text = self.settingsNames[key]
                languageCell.longLabel.text = self.settingsNotes[key]
                if key == kAutocorrectLanguage {
                    languageCell.labelDisplay.text = (currentPickerLanguage != "" ? currentPickerLanguage : self.availableLanguages[self.indexOfCurrentLanguage()!])
                } else {
                    languageCell.labelDisplay.text = (currentPickerType != "" ? currentPickerType : NSUserDefaults(suiteName: "group.dscribekeyboard")!.objectForKey(kKeyboardType) as? String)
                }
                languageCell.labelDisplay.textColor = UIColor.blackColor()

                languageCell.backgroundColor = (self.darkMode ? cellBackgroundColorDark : cellBackgroundColorLight)
                languageCell.label.textColor = (self.darkMode ? cellLabelColorDark : cellLabelColorLight)
                languageCell.longLabel.textColor = (self.darkMode ? cellLongLabelColorDark : cellLongLabelColorLight)

                languageCell.changeConstraints()

                return languageCell
            } else {
                assert(false, "this is a bad thing that just happened dscribe")
                return UITableViewCell()
            }
        }
        if key == kLanguagePicker || key == kKeyboardPicker {
            if let pickerCell = tableView.dequeueReusableCellWithIdentifier("pickerCell") as? PickerViewCell {
                pickerCell.data = (key == kLanguagePicker ? availableLanguages : keyboardTypes)
                pickerCell.pickerView.reloadAllComponents()
                let indexToSelect: Int = (key == kLanguagePicker ?
                    self.indexOfCurrentLanguage()!
                    : self.keyboardTypes.indexOf(
                        currentPickerType != "" ? currentPickerType :
                            NSUserDefaults(suiteName: "group.dscribekeyboard")!.objectForKey(kKeyboardType) as! String
                        )!)
                pickerCell.pickerView.selectRow(indexToSelect, inComponent: 0, animated: false)

                pickerCell.key = (key == kLanguagePicker ? kAutocorrectLanguage : kKeyboardType)
                pickerCell.indexPath = indexPath
                pickerCell.delegate = self

                return pickerCell
            } else {
                assert(false, "this is a bad thing that just happened dscribe")
                return UITableViewCell()
            }
        }
        if key == kInformation {
            if let informationCell = tableView.dequeueReusableCellWithIdentifier("informationCell") as? InformationWithButtonCell {

                informationCell.label.text = self.settingsNames[key]
                informationCell.longLabel.text = self.settingsNotes[key]
                informationCell.button.setTitle("Open App", forState: .Normal)

                informationCell.backgroundColor = (self.darkMode ? cellBackgroundColorDark : cellBackgroundColorLight)
                informationCell.label.textColor = (self.darkMode ? cellLabelColorDark : cellLabelColorLight)
                informationCell.longLabel.textColor = (self.darkMode ? cellLabelColorDark : cellLabelColorLight)
                informationCell.button.setTitleColor(self.tintColor, forState: .Normal)

                informationCell.button.addTarget(self, action: Selector("openApp"), forControlEvents: UIControlEvents.TouchUpInside)

                informationCell.changeConstraints()

                return informationCell
            } else {
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
        } else {
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
        print("Keyboard is allowed full Access: " + String(self.hasFullAccess))
        self.tableView?.deselectRowAtIndexPath(indexPath, animated: true)
        if self.settingsList[indexPath.section].1[indexPath.row] == kAutocorrectLanguage {
            displayLanguagePicker = !displayLanguagePicker
            if !displayLanguagePicker {
                if currentPickerLanguage != "" {
                    saveLanguage(currentPickerLanguage)
                }
            }
            self.tableView?.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
            if displayLanguagePicker {
                self.tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section), atScrollPosition: UITableViewScrollPosition.None, animated: true)
            } else {
                self.tableView?.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.None, animated: true)
            }
        } else if self.settingsList[indexPath.section].1[indexPath.row] == kKeyboardType {
            displayTypePicker = !displayTypePicker
            if !displayTypePicker {
                if currentPickerType != "" {
                    saveKeyboardType(currentPickerType)
                }
            }
            self.tableView?.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
            if displayTypePicker {
                self.tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section), atScrollPosition: UITableViewScrollPosition.None, animated: true)
            } else {
                self.tableView?.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.None, animated: true)
            }
        }
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
        let defaultLanguage: String? = (currentPickerLanguage != "" ? currentPickerLanguage : (NSUserDefaults(suiteName: "group.dscribekeyboard")!.objectForKey(kAutocorrectLanguage) as? String))
        if defaultLanguage == nil {
            return 0
        }
        let index: Int? = availableLanguagesCodes.indexOf({ $0 == defaultLanguage! })
        if index == nil {
            return 0
        }
        return index
    }
    func saveLanguage(language: String) {
        let index: Int? = availableLanguages.indexOf({ $0 == language })
        if index == nil {
            return
        }
        NSUserDefaults(suiteName: "group.dscribekeyboard")!.setObject(availableLanguagesCodes[index!], forKey: kAutocorrectLanguage)
    }
    func saveKeyboardType(type: String) {
        NSUserDefaults(suiteName: "group.dscribekeyboard")!.setObject(type, forKey: kKeyboardType)
    }
    func updateValue(value: AnyObject, key: String, indexPath: NSIndexPath) {
        if key == kAutocorrectLanguage {
            if let language: String = value as? String {
                (self.tableView!.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)) as? StaticSettingCell)?.labelDisplay.text = language
                currentPickerLanguage = language
            }
        }
        if key == kKeyboardType {
            if let type: String = value as? String {
                (self.tableView!.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)) as? StaticSettingCell)?.labelDisplay.text = type
                currentPickerType = type
            }
        }
    }
    func openApp() {
//        let myAppUrl = NSURL(string: "dscribe://")!
        let myAppUrl = NSURL(string: "prefs:root=General&path=Keyboard/KEYBOARDS")!
        var myResponder: UIResponder? = self
        while myResponder != nil {
            if myResponder!.respondsToSelector(Selector("openURL:")) {
                print("responder responding to selector")
                print(myResponder)
                myResponder!.performSelector("openURL:", withObject: myAppUrl)
            }
            myResponder = myResponder?.nextResponder()
        }
    }
}

class InformationWithButtonCell: DefaultSettingsTableViewCell {
    var button: UIButton

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        button = UIButton()

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        sw.hidden = true
        self.addSubview(button)

        self.addButtonConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addButtonConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        let top: NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: sw, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
        let right: NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: sw, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        let bottom: NSLayoutConstraint = NSLayoutConstraint(item: button, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: sw, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)

        self.addConstraints([top, right, bottom])
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

        let left = NSLayoutConstraint(item: pickerView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 2 * sideMargin)
        let right = NSLayoutConstraint(item: pickerView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -2 * sideMargin)
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