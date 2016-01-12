//
//  DscribeAppViewController.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 11/01/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

let kAutocorrectLanguage = "kAutocorrectLanguage"
let kAutoCapitalization = "kAutoCapitalization"
let kPeriodShortcut = "kPeriodShortcut"
let kKeyboardClicks = "kKeyboardClicks"
let kSmallLowercase = "kSmallLowercase"

let kLanguagePicker: String = "kLanguagePicker"

class DscribeAppViewController: UITableViewController, PickerDelegate {
    var userDefaults: NSUserDefaults = NSUserDefaults(suiteName: "group.dscribekeyboard")!

    var availableLanguages: [String] = [String]()
    var availableLanguagesCodes: [String] = [String]()

    var displayLanguagePicker: Bool = false

    var settingsList: [(String, [String])] {
        get {
            return [
                ("General Settings", [kAutoCapitalization, kPeriodShortcut, kKeyboardClicks]),
                ("Extra Settings", [kSmallLowercase]),
                ("Language Settings", [kAutocorrectLanguage, kLanguagePicker])
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
                kAutocorrectLanguage: "Autocorrect"
            ]
        }
    }
    var settingsNotes: [String: String] {
        get {
            return [
                kKeyboardClicks: "Please note that keyboard clicks will work only if “Allow Full Access” is enabled in the keyboard settings. Unfortunately, this is a limitation of the operating system.",
                kSmallLowercase: "Changes your key caps to lowercase when Shift is off, making it easier to tell what mode you are in."
            ]
        }
    }
    

    override func viewDidLoad() {
        self.tableView?.registerClass(DefaultSettingsTableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView?.registerClass(LanguageSettingCell.self, forCellReuseIdentifier: "languageCell")
        self.tableView?.registerClass(PickerViewCell.self, forCellReuseIdentifier: "languagePicker")
        self.tableView?.estimatedRowHeight = 44;
        self.tableView?.rowHeight = UITableViewAutomaticDimension;

        self.tableView?.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        getAvailableLanguages()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.settingsList.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !displayLanguagePicker && self.settingsList[section].0 == "Language Settings" {
            return self.settingsList[section].1.count - 1
        }
        return self.settingsList[section].1.count
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == self.settingsList.count - 1 {
            return 50
        }
        else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.settingsList[section].0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let key = self.settingsList[indexPath.section].1[indexPath.row]
        
        if key == kAutocorrectLanguage {
            if let languageCell = tableView.dequeueReusableCellWithIdentifier("languageCell") as? LanguageSettingCell {
                
                languageCell.label.text = self.settingsNames[key]
                languageCell.longLabel.text = self.settingsNotes[key]
                languageCell.labelDisplay.text = self.availableLanguages[self.indexOfCurrentLanguage()!]
                languageCell.labelDisplay.textColor = UIColor.blackColor()

                languageCell.backgroundColor = UIColor.whiteColor()
                languageCell.label.textColor = UIColor.blackColor()
                languageCell.longLabel.textColor =  UIColor.grayColor()
                
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
            
            cell.sw.on = NSUserDefaults.standardUserDefaults().boolForKey(key)
            cell.label.text = self.settingsNames[key]
            cell.longLabel.text = self.settingsNotes[key]
            
            cell.backgroundColor = UIColor.whiteColor()
            cell.label.textColor = UIColor.blackColor()
            cell.longLabel.textColor =  UIColor.grayColor()
            
            cell.changeConstraints()
            
            return cell
        }
        else {
            assert(false, "this is a bad thing that just happened")
            return UITableViewCell()
        }
        
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? DefaultSettingsTableViewCell {
            let key = self.settingsList[indexPath.section].1[indexPath.row]
            
            if cell.sw.allTargets().count == 0 {
                cell.sw.addTarget(self, action: Selector("toggleSetting:"), forControlEvents: UIControlEvents.ValueChanged)
            }
            
            cell.sw.on = userDefaults.boolForKey(key)
            cell.label.text = self.settingsNames[key]
            cell.longLabel.text = self.settingsNotes[key]
            
            cell.backgroundColor = UIColor.whiteColor()
            cell.label.textColor = UIColor.blackColor()
            cell.longLabel.textColor =  UIColor.grayColor()
            
            cell.changeConstraints()
            
            return cell
        }
        else {
            assert(false, "this is a bad thing that just happened")
            return UITableViewCell()
        }
    }
    func toggleSetting(sender: UISwitch) {
        if let cell = sender.superview as? UITableViewCell {
            if let indexPath = self.tableView?.indexPathForCell(cell) {
                let key = self.settingsList[indexPath.section].1[indexPath.row]
                userDefaults.setBool(sender.on, forKey: key)
            }
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if self.settingsList[indexPath.section].1[indexPath.row] == kAutocorrectLanguage {
            displayLanguagePicker = !displayLanguagePicker
            self.tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
            if displayLanguagePicker {
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section), atScrollPosition: UITableViewScrollPosition.None, animated: true)
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
        let defaultLanguage: String? = NSUserDefaults.standardUserDefaults().objectForKey(kAutocorrectLanguage) as? String
        print("Getting index " + String(NSUserDefaults.standardUserDefaults().objectForKey(kAutocorrectLanguage)))
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
                NSUserDefaults.standardUserDefaults().setObject(availableLanguagesCodes[index!], forKey: kAutocorrectLanguage)
                (self.tableView!.cellForRowAtIndexPath(NSIndexPath(forRow: indexPath.row - 1, inSection: indexPath.section)) as? LanguageSettingCell)?.labelDisplay.text = language
            }
        }
    }
}
