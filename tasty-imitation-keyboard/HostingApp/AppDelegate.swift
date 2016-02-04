//
//  AppDelegate.swift
//  TransliteratingKeyboard
//
//  Created by Alexei Baboulevitch on 6/9/14.
//  Copyright (c) 2014 Apple. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        self.loadRightViewController()

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        print("Will resign active")
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        print("Did Enter Background")
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        print("Will Enter foreground")
        self.loadRightViewController()
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        print("Did Become Active")
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        print("Will Terminate")
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func loadRightViewController() {
        let storyboard = UIStoryboard(name: "Dscribe", bundle: nil)
        if keyboardWasActivated() {
            if NSUserDefaults.standardUserDefaults().boolForKey("hasSeenOnboarding") {
                print("Appears and keyboard activated an has seeeen onboarding")
                let settingsViewController = storyboard.instantiateViewControllerWithIdentifier("SettingsNavigationController")
                self.window?.rootViewController = settingsViewController
            } else {
                let onboardingViewController = storyboard.instantiateViewControllerWithIdentifier("OnboardingViewController")
                self.window?.rootViewController = onboardingViewController
            }
        } else {
            let installViewController = storyboard.instantiateViewControllerWithIdentifier("InstallKeyboardViewController")
            self.window?.rootViewController = installViewController
        }
    }
}
