//
//  OnboardingViewController.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 03/02/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import MediaPlayer

class OnboardingViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var iphoneImageTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var videoContainerView: UIView!

    @IBOutlet var trialTextField: UITextField!


    @IBOutlet var doneButton: UIButton!

    @IBOutlet var doneButtonBottomConstraint: NSLayoutConstraint!

    let defaultText: String = "Try it."

    var moviePlayer : MPMoviePlayerController!

    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
        
        self.trialTextField.delegate = self

        if let videoPath = NSBundle.mainBundle().pathForResource("OpenKeyboard", ofType: "mov") {
            let videoURL = NSURL.fileURLWithPath(videoPath)
            self.moviePlayer = MPMoviePlayerController(contentURL: videoURL)
            if let player = self.moviePlayer {
                player.view.frame = self.videoContainerView.frame
                player.scalingMode = MPMovieScalingMode.AspectFill
                player.fullscreen = true
                player.controlStyle = MPMovieControlStyle.None
                player.movieSourceType = MPMovieSourceType.File
                player.repeatMode = MPMovieRepeatMode.One
                player.play()
                self.view.addSubview(player.view)

                self.setPlayerConstraints()
            }
        }

        self.view.layer.insertSublayer(backgroungLayerWithFrame(self.view.bounds), atIndex: 0)
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touches began")
        print(event)
        self.view.endEditing(true)
    }
    func setPlayerConstraints() {
        self.moviePlayer.view.translatesAutoresizingMaskIntoConstraints = false
        let centerY: NSLayoutConstraint = NSLayoutConstraint(item: self.moviePlayer.view, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.videoContainerView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        let centerX: NSLayoutConstraint = NSLayoutConstraint(item: self.moviePlayer.view, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.videoContainerView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        let width: NSLayoutConstraint = NSLayoutConstraint(item: self.moviePlayer.view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.videoContainerView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0)
        let height: NSLayoutConstraint = NSLayoutConstraint(item: self.moviePlayer.view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.videoContainerView, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0)

        self.view.addConstraints([centerX, centerY, width, height])
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
