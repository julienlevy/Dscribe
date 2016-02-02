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
                player.scalingMode = MPMovieScalingMode.AspectFit
                player.fullscreen = true
                player.controlStyle = MPMovieControlStyle.None
                player.movieSourceType = MPMovieSourceType.File
                player.repeatMode = MPMovieRepeatMode.One
                player.play()
                self.view.addSubview(player.view)
            }
        }
    }

    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear")
        
    }

    @IBAction func installKeyboardPressed(sender: AnyObject) {
        if let settingsURL = NSURL(string: "prefs:root=General&path=Keyboard/KEYBOARDS") {
            UIApplication.sharedApplication().openURL(settingsURL)
        }
    }
}
