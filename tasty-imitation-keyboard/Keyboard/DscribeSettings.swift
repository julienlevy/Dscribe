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
        self.hasFullAccess = UIPasteboard.general.isKind(of: UIPasteboard.self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadNib() {
        super.loadNib()
        self.tableView?.register(StaticSettingCell.self, forCellReuseIdentifier: "staticCell")
        self.tableView?.register(PickerViewCell.self, forCellReuseIdentifier: "pickerCell")
        self.tableView?.register(NoAccessCell.self, forCellReuseIdentifier: "noAccessCell")

        self.hasFullAccess = UIPasteboard.general.isKind(of: UIPasteboard.self)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows: Int = self.settingsList[section].1.count
        for row in 0...(rows-1) {
            if (!displayLanguagePicker && self.settingsList[section].1[row] == kLanguagePicker) || (!displayTypePicker && self.settingsList[section].1[row] == kKeyboardPicker) {
                return self.settingsList[section].1.count - 1
            }
        }
        return self.settingsList[section].1.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let key = self.settingsList[indexPath.section].1[indexPath.row]

        if key == kAutocorrectLanguage || key == kKeyboardType {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "staticCell") as? StaticSettingCell {

                cell.label.text = self.settingsNames[key]
                cell.longLabel.text = self.settingsNotes[key]
                if key == kAutocorrectLanguage {
                    cell.labelDisplay.text = (currentPickerLanguage != "" ? currentPickerLanguage : self.availableLanguages[self.indexOfCurrentLanguage()!])
                } else {
                    cell.labelDisplay.text = (currentPickerType != "" ? currentPickerType : UserDefaults(suiteName: "group.dscribekeyboard")!.object(forKey: kKeyboardType) as? String)
                }
                cell.labelDisplay.textColor = UIColor.black

                cell.backgroundColor = (self.darkMode ? cellBackgroundColorDark : cellBackgroundColorLight)
                cell.label.textColor = (self.darkMode ? cellLabelColorDark : cellLabelColorLight)
                cell.longLabel.textColor = (self.darkMode ? cellLongLabelColorDark : cellLongLabelColorLight)

                cell.isUserInteractionEnabled = self.hasFullAccess
                cell.label.isEnabled = self.hasFullAccess
                cell.labelDisplay.isEnabled = self.hasFullAccess

                cell.changeConstraints()

                return cell
            } else {
                assert(false, "this is a bad thing that just happened dscribe")
                return UITableViewCell()
            }
        }
        if key == kLanguagePicker || key == kKeyboardPicker {
            if let pickerCell = tableView.dequeueReusableCell(withIdentifier: "pickerCell") as? PickerViewCell {
                pickerCell.data = (key == kLanguagePicker ? availableLanguages : keyboardTypes)
                pickerCell.pickerView.reloadAllComponents()
                let indexToSelect: Int = (key == kLanguagePicker ?
                    self.indexOfCurrentLanguage()!
                    : self.keyboardTypes.index(
                        of: currentPickerType != "" ? currentPickerType :
                            UserDefaults(suiteName: "group.dscribekeyboard")!.object(forKey: kKeyboardType) as! String
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: "noAccessCell") as? NoAccessCell {
                cell.backgroundColor = (self.darkMode ? cellBackgroundColorDark : cellBackgroundColorLight)
                cell.label.textColor = (self.darkMode ? cellLabelColorDark : cellLabelColorLight)
                cell.descriptionLabel.textColor = (self.darkMode ? cellLabelColorDark : cellLabelColorLight)

                cell.appButton.setTitleColor(self.tintColor, for: UIControlState())
                cell.settingsButton.setTitleColor(self.tintColor, for: UIControlState())

                cell.appButton.addTarget(self, action: #selector(DscribeSettings.openApp), for: UIControlEvents.touchUpInside)
                cell.settingsButton.addTarget(self, action: #selector(DscribeSettings.openSettings), for: UIControlEvents.touchUpInside)

                return cell
            } else {
                assert(false, "this is a bad thing that just happened dscribe")
                return UITableViewCell()
            }
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? DefaultSettingsTableViewCell {

            if cell.sw.allTargets.count == 0 {
                cell.sw.addTarget(self, action: #selector(DefaultSettings.toggleSetting(_:)), for: UIControlEvents.valueChanged)
            }

            cell.sw.isOn = UserDefaults(suiteName: "group.dscribekeyboard")!.bool(forKey: key)
            cell.label.text = self.settingsNames[key]
            cell.longLabel.text = self.settingsNotes[key]

            cell.backgroundColor = (self.darkMode ? cellBackgroundColorDark : cellBackgroundColorLight)
            cell.label.textColor = (self.darkMode ? cellLabelColorDark : cellLabelColorLight)
            cell.longLabel.textColor = (self.darkMode ? cellLongLabelColorDark : cellLongLabelColorLight)

            cell.isUserInteractionEnabled = !self.hasFullAccess
            cell.sw.isEnabled = self.hasFullAccess
            cell.label.isEnabled = self.hasFullAccess

            cell.changeConstraints()

            return cell
        } else {
            assert(false, "this is a bad thing that just happened")
            return UITableViewCell()
        }
    }
    override func toggleSetting(_ sender: UISwitch) {
        if let cell = sender.superview as? UITableViewCell {
            if let indexPath = self.tableView?.indexPath(for: cell) {
                let key = self.settingsList[indexPath.section].1[indexPath.row]
                UserDefaults(suiteName: "group.dscribekeyboard")!.set(sender.isOn, forKey: key)

//                Mixpanel.sharedInstance().track("Keyboard modify setting", properties:[key: sender.on])
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        self.tableView?.deselectRow(at: indexPath, animated: true)
        if self.settingsList[indexPath.section].1[indexPath.row] == kAutocorrectLanguage {
            displayLanguagePicker = !displayLanguagePicker
            if !displayLanguagePicker {
                if currentPickerLanguage != "" {
                    saveLanguage(currentPickerLanguage)
                }
            }
            self.tableView?.reloadSections(IndexSet(integer: indexPath.section), with: UITableViewRowAnimation.fade)
            if displayLanguagePicker {
                self.tableView?.scrollToRow(at: IndexPath(row: indexPath.row + 1, section: indexPath.section), at: UITableViewScrollPosition.none, animated: true)
            } else {
                self.tableView?.scrollToRow(at: indexPath, at: UITableViewScrollPosition.none, animated: true)
            }
        } else if self.settingsList[indexPath.section].1[indexPath.row] == kKeyboardType {
            displayTypePicker = !displayTypePicker
            if !displayTypePicker {
                if currentPickerType != "" {
                    saveKeyboardType(currentPickerType)
                }
            }
            self.tableView?.reloadSections(IndexSet(integer: indexPath.section), with: UITableViewRowAnimation.fade)
            if displayTypePicker {
                self.tableView?.scrollToRow(at: IndexPath(row: indexPath.row + 1, section: indexPath.section), at: UITableViewScrollPosition.none, animated: true)
            } else {
                self.tableView?.scrollToRow(at: indexPath, at: UITableViewScrollPosition.none, animated: true)
            }
        }
    }
    func getAvailableLanguages() {
        availableLanguagesCodes = (UITextChecker.availableLanguages ).sorted(by: { $0 < $1 })

        var languageDict: [String: String] = [String: String]()
        for language in availableLanguagesCodes {
            let codes: [String] = language.components(separatedBy: "_")
            var wholeString: String = (Locale(identifier: "en") as NSLocale).displayName(forKey: NSLocale.Key.languageCode, value: codes[0])!
            if codes.count > 1 {
                wholeString += " - " + (Locale(identifier: codes[0]) as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value: codes[1])!
            }
            languageDict[language] = wholeString
        }

        //Proper sort
        let sorted = languageDict.sorted(by: { $0.1 < $1.1 })
        availableLanguages = [String]()
        availableLanguagesCodes = [String]()
        for tuple in sorted {
            availableLanguagesCodes.append(tuple.0)
            availableLanguages.append(tuple.1)
        }
    }
    func indexOfCurrentLanguage() -> Int? {
        let defaultLanguage: String? = (currentPickerLanguage != "" ? currentPickerLanguage : (UserDefaults(suiteName: "group.dscribekeyboard")!.object(forKey: kAutocorrectLanguage) as? String))
        if defaultLanguage == nil {
            return 0
        }
        let index: Int? = availableLanguagesCodes.index(where: { $0 == defaultLanguage! })
        if index == nil {
            return 0
        }
        return index
    }
    func saveLanguage(_ language: String) {
        let index: Int? = availableLanguages.index(where: { $0 == language })
        if index == nil {
            return
        }
        UserDefaults(suiteName: "group.dscribekeyboard")!.set(availableLanguagesCodes[index!], forKey: kAutocorrectLanguage)
    }
    func saveKeyboardType(_ type: String) {
        UserDefaults(suiteName: "group.dscribekeyboard")!.set(type, forKey: kKeyboardType)
    }
    func updateValue(_ value: AnyObject, key: String, indexPath: IndexPath) {
        if key == kAutocorrectLanguage {
            if let language: String = value as? String {
                (self.tableView!.cellForRow(at: IndexPath(row: indexPath.row - 1, section: indexPath.section)) as? StaticSettingCell)?.labelDisplay.text = language
                currentPickerLanguage = language

//                Mixpanel.sharedInstance().track("Keyboard modify setting", properties:[key: language])
            }
        }
        if key == kKeyboardType {
            if let type: String = value as? String {
                (self.tableView!.cellForRow(at: IndexPath(row: indexPath.row - 1, section: indexPath.section)) as? StaticSettingCell)?.labelDisplay.text = type
                currentPickerType = type

//                Mixpanel.sharedInstance().track("Keyboard modify setting", properties:[key: type])
            }
        }
    }
    func openApp() {
        let myAppUrl = URL(string: "dscribe://")!
        
        // FIXME replace with correct code
//        var myResponder: UIResponder? = self
//        while myResponder != nil {
//            print("trying a resp")
//            if myResponder!.responds(to: #selector(UIApplication.openURL(_:))) {
//                print("responder responding to selector")
//                print(myResponder)
//                myResponder!.perform(#selector(UIApplication.openURL(_:)), with: myAppUrl)
//            }
//            myResponder = myResponder?.next
//        }
    }
    func openSettings() {
        // FIXME replace with correct code
        let myAppUrl = URL(string: "prefs:root=General&path=Keyboard/KEYBOARDS")!
//        var myResponder: UIResponder? = self
//        while myResponder != nil {
//            print("Trying a responder \(myResponder!.description)")
//            if myResponder!.responds(to: #selector(UIApplication.openURL(_:))) {
//                print("responder responding to selector")
//                print(myResponder)
//                myResponder!.perform(#selector(UIApplication.openURL(_:)), with: myAppUrl)
//            }
//            myResponder = myResponder?.next
//        }
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

        self.settingsButton.setTitle("Open Settings", for: UIControlState())
        self.appButton.setTitle("Open App", for: UIControlState())

        self.settingsIcon.contentMode = .scaleAspectFit
        self.appIcon.contentMode = .scaleAspectFit

        self.descriptionLabel.font = UIFont.systemFont(ofSize: 12.0)
        self.descriptionLabel.numberOfLines = 0

        self.appIcon.layer.cornerRadius = 4
        self.appIcon.layer.borderWidth = 1
        self.appIcon.layer.borderColor = UIColor.gray.cgColor

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
        let topLabel: NSLayoutConstraint = NSLayoutConstraint(item: self.label, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.top, multiplier: 1, constant: margin)
        let leftLabel: NSLayoutConstraint = NSLayoutConstraint(item: self.label, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: sideMargin)

        self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        let topDescription: NSLayoutConstraint = NSLayoutConstraint(item: self.descriptionLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.label, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: insideVerticalMargin)
        let leftDescription: NSLayoutConstraint = NSLayoutConstraint(item: self.descriptionLabel, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: sideMargin)
        let rightDescription: NSLayoutConstraint = NSLayoutConstraint(item: self.descriptionLabel, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -sideMargin)

        self.settingsIcon.translatesAutoresizingMaskIntoConstraints = false
        let topSettingsIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.settingsIcon, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.descriptionLabel, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: insideVerticalMargin)
        let leftSettingsIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.settingsIcon, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: sideMargin)
        let widthSettings: NSLayoutConstraint = NSLayoutConstraint(item: self.settingsIcon, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 30)
        let heightSettings: NSLayoutConstraint = NSLayoutConstraint(item: self.settingsIcon, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 30)

        self.settingsButton.translatesAutoresizingMaskIntoConstraints = false
        let centerSettings: NSLayoutConstraint = NSLayoutConstraint(item: self.settingsButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.settingsIcon, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        let leftSettings: NSLayoutConstraint = NSLayoutConstraint(item: self.settingsButton, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.settingsIcon, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 2)

        self.appIcon.translatesAutoresizingMaskIntoConstraints = false
        let topAppIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.appIcon, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.descriptionLabel, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: insideVerticalMargin)
        let leftAppIcon: NSLayoutConstraint = NSLayoutConstraint(item: self.appIcon, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let widthApp: NSLayoutConstraint = NSLayoutConstraint(item: self.appIcon, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 30)
        let heightApp: NSLayoutConstraint = NSLayoutConstraint(item: self.appIcon, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 30)

        self.appButton.translatesAutoresizingMaskIntoConstraints = false
        let centerApp: NSLayoutConstraint = NSLayoutConstraint(item: self.appButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.appIcon, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        let leftApp: NSLayoutConstraint = NSLayoutConstraint(item: self.appButton, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self.appIcon, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 2)

        let bottom: NSLayoutConstraint = NSLayoutConstraint(item: self.settingsIcon, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: -margin)

        self.addConstraints([topLabel, leftLabel, topDescription, leftDescription, rightDescription, topSettingsIcon, leftSettingsIcon, widthSettings, heightSettings, centerSettings, leftSettings, topAppIcon, leftAppIcon, widthApp, heightApp, centerApp, leftApp, bottom])
    }
}

class StaticSettingCell: DefaultSettingsTableViewCell {
    var labelDisplay: UILabel

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.labelDisplay = UILabel()

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.sw.isHidden = true

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
        let topLabel: NSLayoutConstraint = NSLayoutConstraint(item: labelDisplay, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: sw, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let rightLabel: NSLayoutConstraint = NSLayoutConstraint(item: labelDisplay, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: sw, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0)
        let bottomLabel: NSLayoutConstraint = NSLayoutConstraint(item: labelDisplay, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: sw, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
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

        let left = NSLayoutConstraint(item: pickerView, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 2 * sideMargin)
        let right = NSLayoutConstraint(item: pickerView, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.right, multiplier: 1, constant: -2 * sideMargin)
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
