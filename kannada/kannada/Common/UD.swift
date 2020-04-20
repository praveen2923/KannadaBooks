//
//  UD.swift
//  kannada
//
//  Created by PraveenH on 17/04/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit

//class UD: NSObject {
//
//}


class UD {

static let shared = UD()

    let kUserLogedIn = "kUserLoginkey"

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
    
    func save() {
        UserDefaults.standard.synchronize()
    }
    
}
