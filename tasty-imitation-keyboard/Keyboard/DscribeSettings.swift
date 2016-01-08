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
        else if let languageCell = tableView.dequeueReusableCellWithIdentifier("languageCell") as? LanguageSettingCell {
            let key = self.settingsList[indexPath.section].1[indexPath.row]
            print(key)

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
            assert(false, "this is a bad thing that just happened")
            return UITableViewCell()
        }
    }
}

class LanguageSettingCell: DefaultSettingsTableViewCell {

}