//
//  AppDelegate.swift
//  kannada
//
//  Created by PraveenH on 14/04/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit
import Airship
import GoogleMobileAds
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         GADMobileAds.sharedInstance().start(completionHandler: nil)
         self.setNotification()
         IQKeyboardManager.shared.enable = true
         return true
    }
    
    func setNotification()  {
        let config = UAConfig.default()
        UAirship.takeOff(config)
        if (config.validate() != true) {
           print("error")
        }
        config.messageCenterStyleConfig = "UAMessageCenterDefaultStyle"
        UAirship.push()?.resetBadge()
        UAirship.push()?.enableUserPushNotifications({ (status) in
            if let _ = UAirship.channel()?.identifier {
                if UD.shared.getUserLogedIn() == false {
                    APIManager.registorService() { (error, result) in
                        if let _ = result {
                            UD.shared.setUserLogedIn(true)
                        }
                    }
                }
            }
        })
        UAirship.push().pushNotificationDelegate = self
        UAirship.push()?.registrationDelegate = self
        if let channelid = UAirship.channel()?.identifier {
            UD.shared.setDevicetoken(channelid)
        }
   
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
       
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }

}

extension AppDelegate : UAPushNotificationDelegate {
    
    func receivedBackgroundNotification(_ notificationContent: UANotificationContent, completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
           // Application received a background notification
           print("The application received a background notification");

           // Call the completion handler
           completionHandler(.noData)
       }

       func receivedForegroundNotification(_ notificationContent: UANotificationContent, completionHandler: @escaping () -> Swift.Void) {
           // Application received a foreground notification
           print("The application received a foreground notification");
           completionHandler()
       }

       func receivedNotificationResponse(_ notificationResponse: UANotificationResponse, completionHandler: @escaping () -> Swift.Void) {
           let notificationContent = notificationResponse.notificationContent
           NSLog("Received a notification response")
           NSLog("Alert Title:         \(notificationContent.alertTitle ?? "nil")")
           NSLog("Alert Body:          \(notificationContent.alertBody ?? "nil")")
           NSLog("Action Identifier:   \(notificationResponse.actionIdentifier)")
           NSLog("Category Identifier: \(notificationContent.categoryIdentifier ?? "nil")")
           NSLog("Response Text:       \(notificationResponse.responseText)")

           completionHandler()
       }

       func presentationOptions(for notification: UNNotification) -> UNNotificationPresentationOptions {
           return [.alert, .sound]
       }
}

extension AppDelegate : UARegistrationDelegate {
    func apnsRegistrationFailedWithError(_ error: Error) {
        print(error)
    }
    
    func apnsRegistrationSucceeded(withDeviceToken deviceToken: Data) {
        print("Device token:   \(deviceToken)")
    }
}



