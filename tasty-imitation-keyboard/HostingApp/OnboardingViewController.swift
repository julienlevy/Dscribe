//
//  OnboardingViewController.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 03/02/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var iphoneImageTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var videoContainerView: UIView!

    @IBOutlet var trialTextField: UITextField!


    @IBOutlet var doneButton: UIButton!

    @IBOutlet var doneButtonBottomConstraint: NSLayoutConstraint!

    let defaultText: String = "Try it."

    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        self.trialTextField.delegate = self
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touches began")
        print(event)
        self.view.endEditing(true)
    }

    @IBAction func doneClicked(sender: AnyObject) {
        print("Appears and keyboard activated an has seeeen onboarding")
        let storyboard = UIStoryboard(name: "Dscribe", bundle: nil)
        let settingsViewController = storyboard.instantiateViewControllerWithIdentifier("SettingsNavigationController")
        self.showViewController(settingsViewController, sender: nil)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.trialTextField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == self.defaultText {
            textField.text = ""
        }
    }
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == "" {
            textField.text = self.defaultText
        }
    }

    func keyboardWillShow(notification: NSNotification) {
        if let info =  notification.userInfo {

            if let keyboardFrame = info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue {
                if let duration = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue {
                    self.iphoneImageTopConstraint.constant = -keyboardFrame.height
                    self.doneButtonBottomConstraint.constant = keyboardFrame.height
                    UIView.animateWithDuration(duration, animations: {
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        if let info =  notification.userInfo {

            if let duration = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue {
                self.iphoneImageTopConstraint.constant = 0
                self.doneButtonBottomConstraint.constant = 0
                UIView.animateWithDuration(duration, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
}
