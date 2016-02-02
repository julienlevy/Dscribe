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
        
        if let videoPath = NSBundle.mainBundle().pathForResource("InstallKeyboard", ofType: "mov") {
            let videoURL = NSURL.fileURLWithPath(videoPath)
            self.moviePlayer = MPMoviePlayerController(contentURL: videoURL)
            if let player = self.moviePlayer {
                player.view.frame = self.videoFrameView.frame
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
    }

    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear")
        
    }
    
    func setPlayerConstraints() {
        let centerY: NSLayoutConstraint = NSLayoutConstraint(item: self.moviePlayer.view, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.videoFrameView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0)
        let centerX: NSLayoutConstraint = NSLayoutConstraint(item: self.moviePlayer.view, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.videoFrameView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0)
        let width: NSLayoutConstraint = NSLayoutConstraint(item: self.moviePlayer.view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.videoFrameView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0)
        let height: NSLayoutConstraint = NSLayoutConstraint(item: self.moviePlayer.view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.videoFrameView, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0)

        self.view.addConstraints([centerX, centerY, width, height])
    }

    @IBAction func installKeyboardPressed(sender: AnyObject) {
        if let settingsURL = NSURL(string: "prefs:root=General&path=Keyboard/KEYBOARDS") {
            UIApplication.sharedApplication().openURL(settingsURL)
        }
    }
}
