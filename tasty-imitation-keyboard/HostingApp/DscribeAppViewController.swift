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

class DscribeAppViewController: UITableViewController {
    var userDefaults: NSUserDefaults = NSUserDefaults(suiteName: "group.dscribekeyboard")!

    var settingsList: [(String, [String])] {
        get {
            return [
                ("General Settings", [kAutoCapitalization, kPeriodShortcut, kKeyboardClicks]),
                ("Extra Settings", [kSmallLowercase])
            ]
        }
    }
    var settingsNames: [String:String] {
        get {
            return [
                kAutoCapitalization: "Auto-Capitalization",
                kPeriodShortcut:  "“.” Shortcut",
                kKeyboardClicks: "Keyboard Clicks",
                kSmallLowercase: "Allow Lowercase Key Caps"
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
        self.tableView?.estimatedRowHeight = 44;
        self.tableView?.rowHeight = UITableViewAutomaticDimension;

        self.tableView?.backgroundColor = UIColor.groupTableViewBackgroundColor()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.settingsList.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
}


class DefaultSettingsTableViewCell: UITableViewCell {
    
    var sw: UISwitch
    var label: UILabel
    var longLabel: UITextView
    var constraintsSetForLongLabel: Bool
    var cellConstraints: [NSLayoutConstraint]
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.sw = UISwitch()
        self.label = UILabel()
        self.longLabel = UITextView()
        self.cellConstraints = []
        
        self.constraintsSetForLongLabel = false
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.sw.translatesAutoresizingMaskIntoConstraints = false
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.longLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.longLabel.text = nil
        self.longLabel.scrollEnabled = false
        self.longLabel.selectable = false
        self.longLabel.backgroundColor = UIColor.clearColor()
        
        self.sw.tag = 1
        self.label.tag = 2
        self.longLabel.tag = 3
        
        self.addSubview(self.sw)
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
            let switchSide = NSLayoutConstraint(item: sw, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -sideMargin)
            let switchTop = NSLayoutConstraint(item: sw, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: margin)
            let labelSide = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: sideMargin)
            let labelCenter = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: sw, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
            
            self.addConstraint(switchSide)
            self.addConstraint(switchTop)
            self.addConstraint(labelSide)
            self.addConstraint(labelCenter)
            
            let left = NSLayoutConstraint(item: longLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: sideMargin)
            let right = NSLayoutConstraint(item: longLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -sideMargin)
            let top = NSLayoutConstraint(item: longLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: sw, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: margin)
            let bottom = NSLayoutConstraint(item: longLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -margin)
            
            self.addConstraint(left)
            self.addConstraint(right)
            self.addConstraint(top)
            self.addConstraint(bottom)
            
            self.cellConstraints += [switchSide, switchTop, labelSide, labelCenter, left, right, top, bottom]
            
            self.constraintsSetForLongLabel = true
        }
        else {
            let switchSide = NSLayoutConstraint(item: sw, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -sideMargin)
            let switchTop = NSLayoutConstraint(item: sw, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: margin)
            let switchBottom = NSLayoutConstraint(item: sw, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -margin)
            let labelSide = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: sideMargin)
            let labelCenter = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: sw, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
            
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
