//
//  AppDelegate.swift
//  Transient Watch
//
//  Created by Cristoffer Fairweather on 4/11/15.
//  Copyright (c) 2015 C Fairweather. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit

let serverPrefix:String = "http://twatch.final-frontier.space"
let serverAPIKey:String = "5fca162b8b3a50d7c853ae6ebf494ba2"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Twitter.sharedInstance().startWithConsumerKey("MB0Xv3QLsFMbKmxziIV0qOwLl", consumerSecret: "iEXJ27K3rDWrHDu1rNFEqsngvKLI8nEn3LoFmCTs1cPMMBHJCz")
        Fabric.with([Twitter.sharedInstance()])
        Twitter.sharedInstance().logInGuestWithCompletion { guestSession, error in
            if (guestSession != nil) {
                // make API calls that do not require user auth
            } else {
                println("error: \(error.localizedDescription)");
            }
        }
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false);
        var types: UIUserNotificationType = UIUserNotificationType.Badge |
            UIUserNotificationType.Alert |
            UIUserNotificationType.Sound
        var settings: UIUserNotificationSettings = UIUserNotificationSettings( forTypes: types, categories: nil )
        
        application.registerUserNotificationSettings( settings )
        application.registerForRemoteNotifications()
        
                        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        var characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        
        var deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        
        println( deviceTokenString )
        notifyServerOfDeviceToken(deviceTokenString as String)
        
//        Send device token to server
    }
    
    func notifyServerOfDeviceToken(deviceToken:String){
        let url = NSURL(string: (serverPrefix as String)+"/api/v1/apn")
        
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"

        var params = ["deviceToken":(deviceToken as String)] as Dictionary<String, String>
        var err: NSError?
        
        let postString = "deviceToken="+deviceToken
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        request.addValue(serverAPIKey, forHTTPHeaderField: "X-API-Token")
        
        println(request.description)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
            
            if let resultError = error as NSError? {
                //Handle error!
                println("Device Token wasn't sent to server:")
            }else{
                println("Successfully sent deviceToken!")
                println(NSString(data:data, encoding:NSUTF8StringEncoding))
            }
        }
    }
    
    func application( application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError ) {
        
        println( error.localizedDescription )
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


}

