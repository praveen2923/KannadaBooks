//
//  APIList.swift
//  kannada
//
//  Created by PraveenH on 17/04/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit

// let unitKey : String = "ca-app-pub-9743507528822263/3383415195"
//  let unitKey : String = "ca-app-pub-9743507528822263/5962117707"

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
    
    static var userRegistor : String {
        get {
            return "registor.php"
        }
    }
    
//    static var userLogin : String {
//        get {
//            return "login.php"
//        }
//    }
    
    static var categorylist : String {
        get {
            return "categorylist.php"
        }
    }
    
    static var authors : String {
        get {
            return "authors.php"
        }
    }
    
    static var booklist : String {
        get {
            return "books.php"
        }
    }
    
    static var otherInfo : String {
        get {
            return "history.php"
        }
    }
    
    static var menuList : String {
        get {
            return "menulist.php"
        }
    }
    static var getFeedById : String {
        get {
            return "getFeedById.php"
        }
    }
}

extension String {
    func getConstructedUrl() -> String {
        return  APIList.BOOKBaseUrl + self
    }
}

