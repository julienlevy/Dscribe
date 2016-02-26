//
//  DscribeSettings.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 08/01/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
//import Mixpanel

let kInformation: String = "kInformation"
let kLanguagePicker: String = "kLanguagePicker"
let kKeyboardPicker: String = "kKeyboardPicker"

class DscribeSettings: DefaultSettings, PickerDelegate {
    var hasFullAccess: Bool

    var availableLanguages: [String] = [String]()
    var availableLanguagesCodes: [String] = [String]()
    var currentPickerLanguage: String = ""

    let keyboardTypes: [String] = [kQWERTY, kAZERTY, kAccentedAZERTY]
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
        self.tableView?.registerClass(NoAccessCell.self, forCellReuseIdentifier: "noAccessCell")

        self.hasFullAccess = UIPasteboard.generalPasteboard().isKindOfClass(UIPasteboard)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows: Int = self.settingsList[section].1.count
        for row in 0...(rows-1) {
            if (!displayLanguagePicker && self.settingsList[section].1[row] == kLanguagePicker) || (!displayTypePicker && self.settingsList[section].1[row] == kKeyboardPicker) {
                return self.settingsList[section].1.count - 1
            }
        }
        return self.settingsList[section].1.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let key = self.settingsList[indexPath.section].1[indexPath.row]

        if key == kAutocorrectLanguage || key == kKeyboardType {
            if let cell = tableView.dequeueReusableCellWithIdentifier("staticCell") as? StaticSettingCell {

                cell.label.text = self.settingsNames[key]
                cell.longLabel.text = self.settingsNotes[key]
                if key == kAutocorrectLanguage {
                    cell.labelDisplay.text = (currentPickerLanguage != "" ? currentPickerLanguage : self.availableLanguages[self.indexOfCurrentLanguage()!])
                } else {
                    cell.labelDisplay.text = (currentPickerType != "" ? currentPickerType : NSUserDefaults(suiteName: "group.dscribekeyboard")!.objectForKey(kKeyboardType) as? String)
                }
                cell.labelDisplay.textColor = UIColor.blackColor()

                cell.backgroundColor = (self.darkMode ? cellBackgroundColorDark : cellBackgroundColorLight)
                cell.label.textColor = (self.darkMode ? cellLabelColorDark : cellLabelColorLight)
                cell.longLabel.textColor = (self.darkMode ? cellLongLabelColorDark : cellLongLabelColorLight)

                cell.userInteractionEnabled = self.hasFullAccess
                cell.label.enabled = self.hasFullAccess
                cell.labelDisplay.enabled = self.hasFullAccess

                cell.changeConstraints()

                return cell
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
            if let cell = tableView.dequeueReusableCellWithIdentifier("noAccessCell") as? NoAccessCell {
                cell.backgroundColor = (self.darkMode ? cellBackgroundColorDark : cellBackgroundColorLight)
                cell.label.textColor = (self.darkMode ? cellLabelColorDark : cellLabelColorLight)
                cell.descriptionLabel.textColor = (self.darkMode ? cellLabelColorDark : cellLabelColorLight)

                cell.appButton.setTitleColor(self.tintColor, forState: .Normal)
                cell.settingsButton.setTitleColor(self.tintColor, forState: .Normal)

                cell.appButton.addTarget(self, action: Selector("openApp"), forControlEvents: UIControlEvents.TouchUpInside)
                cell.settingsButton.addTarget(self, action: Selector("openSettings"), forControlEvents: UIControlEvents.TouchUpInside)

                return cell
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

            cell.userInteractionEnabled = !self.hasFullAccess
            cell.sw.enabled = self.hasFullAccess
            cell.label.enabled = self.hasFullAccess

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

//                Mixpanel.sharedInstance().track("Keyboard modify setting", properties:[key: sender.on])
            }
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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

//                Mixpanel.sharedInstance().track("Keyboard modify setting", properties:[key: language])
            }
        }
        if key == kKeyboardType {
            if let type: String = value as? String {
                (self.tableView!.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)) as? StaticSettingCell)?.labelDisplay.text = type
                currentPickerType = type

//                Mixpanel.sharedInstance().track("Keyboard modify setting", properties:[key: type])
            }
        }
    }
    func openApp() {
        let myAppUrl = NSURL(string: "dscribe://")!
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
    func openSettings() {
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

class NoAccessCell: UITableViewCell {
    var label: UILabel
    var descriptionLabel: UILabel
    var settingsIcon: UIImageView
    var settingsButton: UIButton
    var appIcon: UIImageView
    var appButton: UIButton
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.label = UILabel()
        self.descriptionLabel = UILabel()

        self.settingsIcon = UIImageView(image: UIImage(named: "settingsIcon"))
        self.settingsButton = UIButton()

        self.appIcon = UIImageView(image: UIImage(named: "DscribeIconWithBorder"))
        self.appButton = UIButton()

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.label.text = "Saving"
        self.descriptionLabel.text = "Unfortunately settings won't be saved properly unless “Allow Full Access“ is enabled for Dscribe in iOS Settings. Otherwise, you may use the settings in the main app."

        self.settingsButton.setTitle("Open Settings", forState: .Normal)
        self.appButton.setTitle("Open App", forState: .Normal)

        self.settingsIcon.contentMode = .ScaleAspectFit
        self.appIcon.contentMode = .ScaleAspectFit

        self.descriptionLabel.font = UIFont.systemFontOfSize(12.0)
        self.descriptionLabel.numberOfLines = 0

        self.appIcon.layer.cornerRadius = 4
        self.appIcon.layer.borderWidth = 1
        self.appIcon.layer.borderColor = UIColor.grayColor().CGColor

        self.addSubview(self.label)
        self.addSubview(self.descriptionLabel)
        self.addSubview(self.settingsIcon)
        self.addSubview(self.settingsButton)
        self.addSubview(self.appIcon)
        self.addSubview(self.appButton)

        self.setupConstraints()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        let margin: CGFloat = 8
        let sideMargin = margin * 2
        let insideVerticalMargin: CGFloat = 4

        self.label.translatesAutoresizingMaskIntoConstraints = false
        let topLabel: NSLayoutConstraint = NSLayoutConstraint(item: self.label, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: margin)
        let leftLabel: NSLayoutConstraint = NSLayoutConstraint(item: self.label, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: sideMargin)

        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        let topDescription: NSLayoutConstraint = NSLayoutConstraint(item: self.descriptionLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.label, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: insideVerticalMargin)
        let leftDescription: NSLayoutConstraint = NSLayoutConstraint(item: self.descriptionLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: sideMargin)
        let rightDescription: NSLayoutConstraint = NSLayoutConstraint(item: self.descriptionLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -sideMargin)

        self.settingsIcon.translatesAutoresizingMaskIntoConstraints = false
        let topSettingsIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.settingsIcon, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.descriptionLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: insideVerticalMargin)
        let leftSettingsIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.settingsIcon, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: sideMargin)
        let widthSettings: NSLayoutConstraint = NSLayoutConstraint(item: self.settingsIcon, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 30)
        let heightSettings: NSLayoutConstraint = NSLayoutConstraint(item: self.settingsIcon, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 30)

        self.settingsButton.translatesAutoresizingMaskIntoConstraints = false
        let centerSettings: NSLayoutConstraint = NSLayoutConstraint(item: self.settingsButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsIcon, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let leftSettings: NSLayoutConstraint = NSLayoutConstraint(item: self.settingsButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.settingsIcon, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 2)

        self.appIcon.translatesAutoresizingMaskIntoConstraints = false
        let topAppIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.appIcon, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.descriptionLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: insideVerticalMargin)
        let leftAppIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.appIcon, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let widthApp: NSLayoutConstraint = NSLayoutConstraint(item: self.appIcon, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 30)
        let heightApp: NSLayoutConstraint = NSLayoutConstraint(item: self.appIcon, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 30)

        self.appButton.translatesAutoresizingMaskIntoConstraints = false
        let centerApp: NSLayoutConstraint = NSLayoutConstraint(item: self.appButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.appIcon, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let leftApp: NSLayoutConstraint = NSLayoutConstraint(item: self.appButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.appIcon, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 2)

        let bottom: NSLayoutConstraint = NSLayoutConstraint(item: self.settingsIcon, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -margin)

        self.addConstraints([topLabel, leftLabel, topDescription, leftDescription, rightDescription, topSettingsIcon, leftSettingsIcon, widthSettings, heightSettings, centerSettings, leftSettings, topAppIcon, leftAppIcon, widthApp, heightApp, centerApp, leftApp, bottom])
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