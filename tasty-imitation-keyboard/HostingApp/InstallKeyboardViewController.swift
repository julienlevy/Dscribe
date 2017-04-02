//
//  InstallKeyboardViewController.swift
//  TastyImitationKeyboard
//
//  Created by Julien Levy on 02/02/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import MediaPlayer

class InstallKeyboardViewController: UIViewController {
    @IBOutlet var videoFrameView: UIView!

    @IBOutlet var installButton: UIButton!
    var moviePlayer : MPMoviePlayerController!

    override func viewDidLoad() {
        self.installButton.layer.cornerRadius = self.installButton.bounds.height / 2

        if let videoPath = Bundle.main.path(forResource: "InstallKeyboard", ofType: "mov") {
            let videoURL = URL(fileURLWithPath: videoPath)
            self.moviePlayer = MPMoviePlayerController(contentURL: videoURL)
            if let player = self.moviePlayer {
                player.view.frame = self.videoFrameView.frame
                player.scalingMode = MPMovieScalingMode.aspectFill
                player.isFullscreen = true
                player.controlStyle = MPMovieControlStyle.none
                player.movieSourceType = MPMovieSourceType.file
                player.repeatMode = MPMovieRepeatMode.one
                player.play()
                self.view.addSubview(player.view)

                self.setPlayerConstraints()
            }
        }

        self.view.layer.insertSublayer(backgroungLayerWithFrame(self.view.bounds), at: 0)

        self.installButton.setTitleColor(UIColor.dscribeOrangeText(), for: UIControlState())
    }
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        
    }
    override func viewDidAppear(_ animated: Bool) {
        print("viewDidAppear")
    }
    override var prefersStatusBarHidden : Bool {
        return true
    }

    func setPlayerConstraints() {
        self.moviePlayer.view.translatesAutoresizingMaskIntoConstraints = false
        let centerY: NSLayoutConstraint = NSLayoutConstraint(item: self.moviePlayer.view, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.videoFrameView, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0)
        let centerX: NSLayoutConstraint = NSLayoutConstraint(item: self.moviePlayer.view, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.videoFrameView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0)
        let width: NSLayoutConstraint = NSLayoutConstraint(item: self.moviePlayer.view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.videoFrameView, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0)
        let height: NSLayoutConstraint = NSLayoutConstraint(item: self.moviePlayer.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.videoFrameView, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0)

        self.view.addConstraints([centerX, centerY, width, height])
    }

    @IBAction func installKeyboardPressed(_ sender: AnyObject) {
        if let settingsURL = URL(string: "prefs:root=General&path=Keyboard/KEYBOARDS") {
            if !UIApplication.shared.openURL(settingsURL) {
                //TODO: Open regular settings not from keyboard page
                if let mainSettingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.openURL(mainSettingsURL)
                }
            }
        }
    }
}
