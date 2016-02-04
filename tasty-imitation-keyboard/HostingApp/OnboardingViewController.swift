//
//  OnboardingViewController.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 03/02/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import MediaPlayer

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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)

        if let videoPath = NSBundle.mainBundle().pathForResource("OpenKeyboard", ofType: "mov") {
            let videoURL = NSURL.fileURLWithPath(videoPath)

            self.moviePlayer = MPMoviePlayerController(contentURL: videoURL)
            if let player = self.moviePlayer {
                player.view.frame = self.videoContainerView.frame
                player.scalingMode = MPMovieScalingMode.AspectFill
                player.fullscreen = true
                player.controlStyle = MPMovieControlStyle.None
                player.shouldAutoplay = true
                player.initialPlaybackTime = 2.0
                player.endPlaybackTime = 6.0
                player.currentPlaybackTime = 5.0
                player.repeatMode = MPMovieRepeatMode.One
                player.play()
                self.view.insertSubview(player.view, belowSubview: self.videoContainerView)
                self.videoContainerView.alpha = 0
                self.videoContainerView.backgroundColor = UIColor.dscribeDarkOrange()

                self.setPlayerConstraints()
            }
            NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("movieDidChange:"), name: MPMoviePlayerPlaybackStateDidChangeNotification, object: nil)
        }

        self.trialTextField.delegate = self
        self.scrollView.delegate = self

        let swipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
        swipe.direction = .Down
        self.scrollView.addGestureRecognizer(swipe)

        self.doneButton.setTitleColor(UIColor.dscribeOrangeText(), forState: .Normal)
        self.doneButton.alpha = 0

        self.view.layer.insertSublayer(backgroungLayerWithFrame(self.view.bounds), atIndex: 0)

        self.setScrollViewContent()
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
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

    @IBAction func doneClicked(sender: AnyObject) {
        print("Appears and keyboard activated an has seeeen onboarding")
        let storyboard = UIStoryboard(name: "Dscribe", bundle: nil)
        let settingsViewController = storyboard.instantiateViewControllerWithIdentifier("SettingsNavigationController")
        self.showViewController(settingsViewController, sender: nil)

        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasSeenOnboarding")
    }

    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let percentage = scrollView.contentOffset.x / (scrollView.contentSize.width - scrollView.frame.width)
        self.doneButton.alpha = percentage
        self.doneButtonCenterX.constant = scrollView.frame.width - scrollView.contentOffset.x

        let width = scrollView.frame.width
        let side = 1 - 2 * (scrollView.contentOffset.x % width) / width

        let offetPage: Int = Int(self.scrollView.contentOffset.x / self.scrollView.frame.width)
        let toPage: Int = (side > 0 ? offetPage : offetPage + 1)

        if toPage == self.currentPage {
            self.videoContainerView.alpha = 1 - fabs(side)
        } else {
            self.videoContainerView.alpha = 1
        }
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let currentPage: Int = Int(self.scrollView.contentOffset.x / self.scrollView.frame.width)
        self.pageControl.currentPage = currentPage

        if self.currentPage != currentPage {
            if let videoPath = NSBundle.mainBundle().pathForResource(self.videoNames[currentPage], ofType: "mov") {
                let videoURL = NSURL.fileURLWithPath(videoPath)
                self.moviePlayer.contentURL = videoURL
                self.moviePlayer.play()
            }
            self.currentPage = currentPage
        }
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

    func movieDidChange(notification: NSNotification) {
        if self.moviePlayer.playbackState == MPMoviePlaybackState.Playing {
            self.delay(0.2, closure: {
                UIView.animateWithDuration(0.2, animations: {
                    self.videoContainerView.alpha = 0
                })
            })
        }
    }

    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}
