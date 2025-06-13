//
//  UD.swift
//  kannada
//
//  Created by PraveenH on 17/04/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit
 
class UserDefaultsKeys {
    
    class var processCompletedCountKey: String {
        return "processCompletedCount"
    }
    
    class var lastVersionPromptedForReviewKey: String {
        return "lastVersionPromptedForReview"
    }
    
}
class UD {

static let shared = UD()

    let kUserLogedIn = "kUserLoginkeytest"
    let kDeviceToken = "kDeviceToken"
    let kFeedbackmessage = "kFeedbackmessage"
    
    private init() {

    }
    
    func setUserLogedIn(_ value : Bool) {
        UserDefaults.standard.set(value, forKey: kUserLogedIn)
        self.save()
    }
    
    func getUserLogedIn() -> Bool {
        let value = UserDefaults.standard.bool(forKey: kUserLogedIn)
        return value
    }
    
    func setDevicetoken(_ value : String)  {
       UserDefaults.standard.set(value, forKey: kDeviceToken)
       self.save()
    }
    
    func getUDevicetoken() -> String? {
        let value = UserDefaults.standard.string(forKey: kDeviceToken)
        return value
    }
    
    func setFeedbackMessageSent(_ value : Bool)  {
        UserDefaults.standard.set(value, forKey: kFeedbackmessage)
        self.save()
    }
    
    func getFeedbackMessageSent() -> Bool {
        let value = UserDefaults.standard.bool(forKey: kFeedbackmessage)
        return value
    }
    
    func save() {
        UserDefaults.standard.synchronize()
    }
}
