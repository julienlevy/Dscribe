//
//  DscribeAppViewController.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 11/01/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Mixpanel

let kAutocorrectLanguage = "kAutocorrectLanguage"
let kAutoCapitalization = "kAutoCapitalization"
let kPeriodShortcut = "kPeriodShortcut"
let kKeyboardClicks = "kKeyboardClicks"
let kSmallLowercase = "kSmallLowercase"
let kAutoReplace = "kAutoReplace"
let kKeyboardType = "kKeyboardType"

let kUseInformation: String = "kUseInformation"
let kSettingsInformation: String = "kSettingsInformation"
let kLanguagePicker: String = "kLanguagePicker"
let kKeyboardPicker: String = "kKeyboardPicker"

let kAZERTY = "AZERTY"
let kQWERTY = "QWERTY"
let kAccentedAZERTY = "Accented AZERTY"

class DscribeAppViewController: UITableViewController, PickerDelegate {
    var availableLanguages: [String] = [String]()
    var availableLanguagesCodes: [String] = [String]()
    var currentPickerLanguage: String = ""

    let keyboardTypes: [String] = [kQWERTY, kAZERTY, kAccentedAZERTY]
    var currentPickerType: String = ""

    var displayLanguagePicker: Bool = false
    var displayTypePicker: Bool = false

    var settingsList: [(String, [String])] {
        get {
            return [
                ("About", [kUseInformation]),
                ("General Settings", [kAutoCapitalization, kPeriodShortcut, kKeyboardClicks]),
                ("Display Settings", [kSmallLowercase, kKeyboardType, kKeyboardPicker]),
                ("Autocorrect Settings", [kAutoReplace, kAutocorrectLanguage, kLanguagePicker])
            ]
        }
    }
    var settingsNames: [String:String] {
        get {
            return [
                kAutoCapitalization: "Auto-Capitalization",
                kPeriodShortcut:  "“.” Shortcut",
                kKeyboardClicks: "Keyboard Clicks",
                kSmallLowercase: "Allow Lowercase Key Caps",
                kAutoReplace: "Replace Automatically",
                kAutocorrectLanguage: "Language",
                kKeyboardType: "Keyboard Type",
                kUseInformation: "Information",
                kSettingsInformation: "Settings"
            ]
        }
    }
    var settingsNotes: [String: String] {
        get {
            return [
                kKeyboardClicks: "Please note that keyboard clicks will work only if “Allow Full Access” is enabled in the keyboard settings. Unfortunately, this is a limitation of the operating system.",
                kSmallLowercase: "Changes your key caps to lowercase when Shift is off, making it easier to tell what mode you are in.",
                kAutoReplace: "The suggested word will be automatically replaced on pressing space if there is a spelling mistake.",
                kUseInformation: "Dscribe allows you to type and search for Emojis, just press the Dscribe icon and type your search after the | symbol.",
                kSettingsInformation: "There is a settings page inside the keyboard, unfortunately it will work properly only if “Allow Full Access“ is enabled in the keyboard settings, this is an iOS limitation."
            ]
        }
    }

    override func viewDidLoad() {
        UserDefaults(suiteName: "group.dscribekeyboard")!.register(defaults: [
            kAutoCapitalization: true,
            kPeriodShortcut: true,
            kKeyboardClicks: false,
            kSmallLowercase: true,
            kAutocorrectLanguage: "en_US",
            kKeyboardType: kQWERTY
            ])

        self.tableView?.register(DefaultSettingsTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView?.register(StaticSettingCell.self, forCellReuseIdentifier: "staticCell")
        self.tableView?.register(PickerViewCell.self, forCellReuseIdentifier: "picker")
        self.tableView?.register(InformationCell.self, forCellReuseIdentifier: "informationCell")
        self.tableView?.estimatedRowHeight = 44
        self.tableView?.rowHeight = UITableViewAutomaticDimension

        self.tableView?.backgroundColor = UIColor.groupTableViewBackground

        self.navigationItem.titleView = NavigationTitle(frame: self.view.bounds, leftText: "Dscribe", rightText: "Keyboard")

        getAvailableLanguages()

        NotificationCenter.default.addObserver(self, selector: #selector(DscribeAppViewController.becameActive(_:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        if currentPickerLanguage != "" {
            saveLanguage(currentPickerLanguage)
        }
    }

    func becameActive(_ notification: Notification) {
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.settingsList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows: Int = self.settingsList[section].1.count
        for row in 0...(rows-1) {
            // TODO: make this condition with an array when we might have more than one picker
            if (!displayLanguagePicker && self.settingsList[section].1[row] == kLanguagePicker) || (!displayTypePicker && self.settingsList[section].1[row] == kKeyboardPicker) {
                return self.settingsList[section].1.count - 1
            }
        }
        return self.settingsList[section].1.count
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 35 + 20
        }
        return 35
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == self.settingsList.count - 1 {
            return 50
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.settingsList[section].0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let key = self.settingsList[indexPath.section].1[indexPath.row]

        if key == kAutocorrectLanguage || key == kKeyboardType {
            if let languageCell = tableView.dequeueReusableCell(withIdentifier: "staticCell") as? StaticSettingCell {

                languageCell.label.text = self.settingsNames[key]
                languageCell.longLabel.text = self.settingsNotes[key]
                if key == kAutocorrectLanguage {
                    languageCell.labelDisplay.text = (currentPickerLanguage != "" ? currentPickerLanguage : self.availableLanguages[self.indexOfCurrentLanguage()!])
                } else {
                    languageCell.labelDisplay.text = (currentPickerType != "" ? currentPickerType : UserDefaults(suiteName: "group.dscribekeyboard")!.object(forKey: kKeyboardType) as? String)
                }
                languageCell.labelDisplay.textColor = UIColor.black

                languageCell.backgroundColor = UIColor.white
                languageCell.label.textColor = UIColor.black
                languageCell.longLabel.textColor =  UIColor.gray

                languageCell.changeConstraints()

                return languageCell
            } else {
                assert(false, "this is a bad thing that just happened dscribe")
                return UITableViewCell()
            }
        }
        if key == kLanguagePicker || key == kKeyboardPicker {
            if let pickerCell = tableView.dequeueReusableCell(withIdentifier: "picker") as? PickerViewCell {
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
        if key == kUseInformation || key == kSettingsInformation {
            if let informationCell = tableView.dequeueReusableCell(withIdentifier: "informationCell") as? InformationCell {

                informationCell.label.text = self.settingsNames[key]
                informationCell.longLabel.text = self.settingsNotes[key]

                informationCell.backgroundColor = UIColor.white
                informationCell.label.textColor = UIColor.black
                informationCell.longLabel.textColor =  UIColor.black

                informationCell.changeConstraints()

                return informationCell
            } else {
                assert(false, "this is a bad thing that just happened dscribe")
                return UITableViewCell()
            }
        }
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? DefaultSettingsTableViewCell {

            if cell.switchItem.allTargets.count == 0 {
                cell.switchItem.addTarget(self, action: #selector(DscribeAppViewController.toggleSetting(_:)), for: UIControlEvents.valueChanged)
            }

            cell.switchItem.isOn = UserDefaults(suiteName: "group.dscribekeyboard")!.bool(forKey: key)
            cell.label.text = self.settingsNames[key]
            cell.longLabel.text = self.settingsNotes[key]

            cell.backgroundColor = UIColor.white
            cell.label.textColor = UIColor.black
            cell.longLabel.textColor =  UIColor.gray

            cell.changeConstraints()

            return cell
        } else {
            assert(false, "this is a bad thing that just happened")
            return UITableViewCell()
        }
    }
    func toggleSetting(_ sender: UISwitch) {
        if let cell = sender.superview as? UITableViewCell {
            if let indexPath = self.tableView?.indexPath(for: cell) {
                let key = self.settingsList[indexPath.section].1[indexPath.row]
                UserDefaults(suiteName: "group.dscribekeyboard")!.set(sender.isOn, forKey: key)

                Mixpanel.sharedInstance().track("Modify setting", properties:[key: sender.isOn])
            }
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        if self.settingsList[indexPath.section].1[indexPath.row] == kAutocorrectLanguage {
            displayLanguagePicker = !displayLanguagePicker
            if !displayLanguagePicker {
                if currentPickerLanguage != "" {
                    saveLanguage(currentPickerLanguage)
                }
            }
            self.tableView.reloadSections(IndexSet(integer: indexPath.section), with: UITableViewRowAnimation.fade)
            if displayLanguagePicker {
                self.tableView.scrollToRow(at: IndexPath(row: indexPath.row + 1, section: indexPath.section), at: UITableViewScrollPosition.none, animated: true)
            } else {
                self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.none, animated: true)
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
            //            availableLanguages.append(wholeString)
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
    // PICKER DELEGATE
    func updateValue(_ value: AnyObject, key: String, indexPath: IndexPath) {
        if key == kAutocorrectLanguage {
            if let language: String = value as? String {
                (self.tableView!.cellForRow(at: IndexPath(row: indexPath.row - 1, section: indexPath.section)) as? StaticSettingCell)?.labelDisplay.text = language
                currentPickerLanguage = language

                Mixpanel.sharedInstance().track("Modify setting", properties:[key: language])
            }
        }
        if key == kKeyboardType {
            if let type: String = value as? String {
                (self.tableView!.cellForRow(at: IndexPath(row: indexPath.row - 1, section: indexPath.section)) as? StaticSettingCell)?.labelDisplay.text = type
                currentPickerType = type

                Mixpanel.sharedInstance().track("Modify setting", properties:[key: type])
            }
        }
    }
}
