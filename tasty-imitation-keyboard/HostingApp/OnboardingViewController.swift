//
//  OnboardingViewController.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 03/02/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import MediaPlayer
import Mixpanel

class OnboardingViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    @IBOutlet var iphoneImageTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var iphoneImage: UIImageView!
    @IBOutlet var videoContainerView: UIView!

    @IBOutlet var trialTextField: UITextField!

    @IBOutlet var scrollView: UIScrollView!

    @IBOutlet var pageControl: UIPageControl!

    @IBOutlet var doneButton: UIButton!
    @IBOutlet var doneButtonCenterX: NSLayoutConstraint!
    @IBOutlet var doneButtonBottomConstraint: NSLayoutConstraint!

    let videoNames: [String] = ["OpenKeyboard", "UseKeyboard"]
    let defaultText: String = "Try it."

    var moviePlayer : MPMoviePlayerController!

    var currentPage: Int = 0

    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(OnboardingViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OnboardingViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

        if let videoPath = Bundle.main.path(forResource: "OpenKeyboard", ofType: "mov") {
            let videoURL = URL(fileURLWithPath: videoPath)

            self.moviePlayer = MPMoviePlayerController(contentURL: videoURL)
            if let player = self.moviePlayer {
                player.view.frame = self.videoContainerView.frame
                player.scalingMode = MPMovieScalingMode.aspectFill
                player.isFullscreen = true
                player.controlStyle = MPMovieControlStyle.none
                player.repeatMode = MPMovieRepeatMode.one
                player.play()
                self.view.insertSubview(player.view, belowSubview: self.videoContainerView)
                self.videoContainerView.alpha = 0
                self.videoContainerView.backgroundColor = UIColor.dscribeDarkOrange()

                self.setPlayerConstraints()
            }
            NotificationCenter.default.addObserver(self, selector: #selector(OnboardingViewController.movieDidChange(_:)), name: NSNotification.Name.MPMoviePlayerPlaybackStateDidChange, object: nil)
        }

        self.trialTextField.delegate = self
        self.scrollView.delegate = self

        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(OnboardingViewController.dismissKeyboard))
        swipe.direction = .down
        self.scrollView.addGestureRecognizer(swipe)

        self.doneButton.setTitleColor(UIColor.dscribeLightOrange(), for: UIControlState())
        self.doneButton.alpha = 0

        self.view.layer.insertSublayer(backgroungLayerWithFrame(self.view.bounds), at: 0)

        self.setScrollViewContent()
    }
    override var prefersStatusBarHidden : Bool {
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func setPlayerConstraints() {
        self.moviePlayer.view.translatesAutoresizingMaskIntoConstraints = false
        let centerY: NSLayoutConstraint = NSLayoutConstraint(item: self.moviePlayer.view, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.videoContainerView, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0)
        let centerX: NSLayoutConstraint = NSLayoutConstraint(item: self.moviePlayer.view, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.videoContainerView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0)
        let width: NSLayoutConstraint = NSLayoutConstraint(item: self.moviePlayer.view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.videoContainerView, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0)
        let height: NSLayoutConstraint = NSLayoutConstraint(item: self.moviePlayer.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.videoContainerView, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0)

        self.view.addConstraints([centerX, centerY, width, height])
    }
    func setScrollViewContent() {
        let width: CGFloat = self.scrollView.bounds.width
        let inset: CGFloat = self.trialTextField.frame.origin.x

        let yOrigin: CGFloat = self.pageControl.frame.origin.y + self.pageControl.frame.height + 30
        let height: CGFloat = self.trialTextField.frame.origin.y - yOrigin

        let openKeyboardView = OpenKeyboardTutorialView()
        openKeyboardView.frame = CGRect(x: inset, y: yOrigin, width: width - 2 * inset, height: height)

        self.scrollView.addSubview(openKeyboardView)

        let useKeyboardView = UseKeyboardTutorialView()
        useKeyboardView.frame = CGRect(x: inset + width, y: yOrigin, width: width - 2 * inset, height: height)
        
        self.scrollView.addSubview(useKeyboardView)

        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width * 2, height: self.scrollView.frame.height)
    }

    @IBAction func doneClicked(_ sender: AnyObject) {
        print("Appears and keyboard activated an has seeeen onboarding")
        let storyboard = UIStoryboard(name: "Dscribe", bundle: nil)
        let settingsViewController = storyboard.instantiateViewController(withIdentifier: "SettingsNavigationController")
        self.show(settingsViewController, sender: nil)

        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")

        Mixpanel.sharedInstance().track("Finish Onboarding", properties: ["trial text": (self.trialTextField.text != nil ? self.trialTextField.text! : "")])
    }

    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let percentage = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.frame.width)
        self.doneButton.alpha = percentage
        self.doneButtonCenterX.constant = scrollView.frame.width - scrollView.contentOffset.x

        let width = scrollView.frame.width
        let side = 1 - 2 * (scrollView.contentOffset.x.truncatingRemainder(dividingBy: width)) / width

        let offetPage: Int = Int(self.scrollView.contentOffset.x / self.scrollView.frame.width)
        let toPage: Int = (side > 0 ? offetPage : offetPage + 1)

        if toPage == self.currentPage {
            self.videoContainerView.alpha = 1 - fabs(side)
        } else {
            self.videoContainerView.alpha = 1
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage: Int = Int(self.scrollView.contentOffset.x / self.scrollView.frame.width)
        self.pageControl.currentPage = currentPage

        if self.currentPage != currentPage {
            if let videoPath = Bundle.main.path(forResource: self.videoNames[currentPage], ofType: "mov") {
                let videoURL = URL(fileURLWithPath: videoPath)
                self.moviePlayer.contentURL = videoURL
                self.moviePlayer.play()
            }
            self.currentPage = currentPage
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.trialTextField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == self.defaultText {
            textField.text = ""
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        Mixpanel.sharedInstance().track("Text field onboarding", properties: ["text": (textField.text != nil ? textField.text! : "")])

        if textField.text == "" {
            textField.text = self.defaultText
        }
    }

    func keyboardWillShow(_ notification: Notification) {
        if let info =  notification.userInfo {

            if let keyboardFrame = (info[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
                if let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
                    self.iphoneImageTopConstraint.constant = -keyboardFrame.height
                    self.doneButtonBottomConstraint.constant = keyboardFrame.height
                    UIView.animate(withDuration: duration, animations: {
                        self.view.layoutIfNeeded()
                    })
                }
            }
        }
    }
    func keyboardWillHide(_ notification: Notification) {
        if let info =  notification.userInfo {

            if let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue {
                self.iphoneImageTopConstraint.constant = 0
                self.doneButtonBottomConstraint.constant = 0
                UIView.animate(withDuration: duration, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }

    func movieDidChange(_ notification: Notification) {
        if self.moviePlayer.playbackState == MPMoviePlaybackState.playing {
            self.delay(0.2, closure: {
                UIView.animate(withDuration: 0.2, animations: {
                    self.videoContainerView.alpha = 0
                })
            })
        }
    }

    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
