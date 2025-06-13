//
//  APIList.swift
//  kannada
//
//  Created by PraveenH on 17/04/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit

let unitKey : String = "ca-app-pub-9743507528822263/1646412253"

 enum API: String {
     case baseurl = "http://softwaresolutionpvt.com/"
 }

struct APIList {
    // Book API
    static var BOOKBaseUrl: String  {
        get {
            return API.baseurl.rawValue
        }
    }
    
    static var userRegistor : String { // registor push notification
        get {
            return "registor.php"
        }
    }
    
    static var categorylist : String {
        get {
            return "categorylist.php"
        }
    }
    
    static var otherInfo : String {
        get {
            return "history.php"
        }
    }
    
    static var getBookCatalogue : String {
        get {
            return "newapi/getbookcatalogue.php"
        }
    }
    
    static var menuList : String {
        get {
            return "newapi/getsidemanulist.php"
        }
    }
 
    static var getAudiobooks : String {
         get {
             return "getaudiobooks.php"
         }
     }
    
    static var savefeedback : String {
         get {
             return "newapi/savefeedback.php"
         }
     }
}

extension String {
    func getConstructedUrl() -> String {
        return  APIList.BOOKBaseUrl + self
    }
}

