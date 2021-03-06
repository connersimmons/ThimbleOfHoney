//
//  AppDelegate.swift
//  ThimbleOfHoney
//
//  Created by Conner Simmons on 2/24/15.
//  Copyright (c) 2015 CWS. All rights reserved.
//

import UIKit
import Parse
import MAThemeKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    var pushNotificationController: PushNotificationController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        //register push notifications
        registerPushNotifications(application)
        
        //gets version information for settings page
        versionInformation()
        
        // Override point for customization after application launch.
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        MAThemeKit.customizeNavigationBarColor(UIColor(rgb: 0x499AC7), textColor: UIColor.whiteColor(), buttonColor: UIColor.whiteColor())
        
        let navigationBarAppearance = UINavigationBar.appearance()
        //navigationBarAppearance.barTintColor = UIColor(rgb: 0x499AC7)
        //navigationBarAppearance.tintColor = UIColor(rgb: 0xF4EFE6)
        
        let font = UIFont(name: "RougeScript-Regular", size: 30)
        if let font = font {
            navigationBarAppearance.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.whiteColor()]
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("didRegisterForRemoteNotificationsWithDeviceToken: \(deviceToken)")
        
        let currentInstallation = PFInstallation.currentInstallation()
        
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.saveInBackground()
        
        /*
        currentInstallation.saveInBackgroundWithBlock { (succeeded, e) -> Void in
            //code
        }
        */
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("failed to register for remote notifications:  \(error)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("didReceiveRemoteNotification")
        PFPush.handlePush(userInfo)
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
    
    func registerPushNotifications(application: UIApplication) {
        self.pushNotificationController = PushNotificationController()
        
        // Register for Push Notitications, if running iOS 8
        if application.respondsToSelector("registerUserNotificationSettings:") {
            
            let types:UIUserNotificationType = ([.Alert, .Badge, .Sound])
            let settings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: nil)
            
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            
        } else {
            // Register for Push Notifications before iOS 8
            //application.registerForRemoteNotificationTypes(.Alert | .Badge | .Sound)
            application.registerForRemoteNotifications()
        }
    }
    
    func versionInformation() {
        let appInfo = NSBundle.mainBundle().infoDictionary! as Dictionary<String,AnyObject>
        let shortVersionString = appInfo["CFBundleShortVersionString"] as! String
        //let bundleVersion      = appInfo["CFBundleVersion"] as! String
        //let applicationVersion = shortVersionString + "." + bundleVersion
        let applicationVersion = shortVersionString
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(applicationVersion, forKey: "application_version")
        defaults.synchronize()
    }
}

