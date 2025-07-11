//
//  APIManager.swift
//  kannada
//
//  Created by PraveenH on 17/04/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit
import Alamofire
import Airship

typealias CompletionHandler = (_ error: Any?, _ result: Any?) -> Void

class APIManager: NSObject {
    
    // Server
    class func serviceRequest(_ url: String, method: HTTPMethod, parms: Parameters, headers: HTTPHeaders, completion: @escaping CompletionHandler) {
        
        print("URL : \(url)")
        print("Header: \(String(describing: headers))")
        print("Parameters: \(String(describing: parms))")
         AF.request(url, method: method, parameters: parms, encoding: JSONEncoding.default, headers: headers).responseData { (response) in
            print("Response Code:\(String(describing: response.response?.statusCode))")
            if let data = response.data {
                let resStr = String(decoding: data, as: UTF8.self)
                print(resStr)
            }
            if response.response?.statusCode == 200 {
                completion(nil, response.data)
            } else {
                completion(response.data, nil)
            }
        }
    }
   
    // Get ALL List
    class func categoryList(_ parameters: NSDictionary?, completion: @escaping CompletionHandler) {
        APIManager.serviceRequest(APIList.categorylist.getConstructedUrl(), method: .post, parms: [:], headers: [:]) { (error, result) in
            APIManager.responseHandle(result) { (error, result) in
               completion(error, result)
            }
        }
    }
    
    // Get ALL Author
    class func authorList(_ parameters: NSDictionary?, completion: @escaping CompletionHandler) {
        APIManager.serviceRequest(APIList.authors.getConstructedUrl(), method: .post, parms: [:], headers: [:]) { (error, result) in
           APIManager.responseHandle(result) { (error, result) in
                completion(error, result)
            }
         }
     }
    
    // Get ALL Books For author id
    class func getAllBooksForAuthor(_ authorid: String?, completion: @escaping CompletionHandler) {
        let bParameters:Parameters = [  "author" : authorid ?? "", ]
        APIManager.serviceRequest(APIList.booklist.getConstructedUrl(), method: .post, parms: bParameters, headers: [:]) { (error, result) in
            APIManager.responseHandle(result) { (error, result) in
                completion(error, result)
            }
        }
    }
    
    // Get History information for category id categoryid
    class func getAllInformationforCategory(_ catid: String?, completion: @escaping CompletionHandler) {
        let bParameters:Parameters = ["categoryid" : catid ?? "", ]
           APIManager.serviceRequest(APIList.otherInfo.getConstructedUrl(), method: .post, parms: bParameters, headers: [:]) { (error, result) in
               APIManager.responseHandle(result) { (error, result) in
                   completion(error, result)
               }
        }
    }
    
    // Get Menu List
    class func getMenuList(_ parameters: NSDictionary?, completion: @escaping CompletionHandler) {
        APIManager.serviceRequest(APIList.menuList.getConstructedUrl(), method: .post, parms: [:], headers: [:]) { (error, result) in
            APIManager.responseHandle(result) { (error, result) in
               completion(error, result)
            }
        }
    }
    
    // Get Menu information for Menu id
    class func getFeedformationByMenuId(_ menuId: String?, completion: @escaping CompletionHandler) {
        let bParameters:Parameters = ["id" : menuId ?? "", ]
        APIManager.serviceRequest(APIList.getFeedById.getConstructedUrl(), method: .post, parms: bParameters, headers: [:]) { (error, result) in
               APIManager.responseHandle(result) { (error, result) in
                   completion(error, result)
               }
         }
    }
    
    
    
    // Handle NSArray json data from server
    class func responseHandle(_ result: Any?, completion: @escaping CompletionHandler) {
        if let data = result as? Data {
            do {
                if let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSArray {
                    completion(nil, result) // no Error
                } else{
                    completion(true, nil) // Parse error
                }
            } catch {
                completion(true, nil) // Some error
            }
        } else {
            completion(true, nil)  // No Data Response
        }
    }
    
       
    // Registor Response Handle Loin and Registor
    class func responseHandler(_ result: Any?, completion: @escaping CompletionHandler) {
        if let data = result as? Data {
            do {
                if let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary<String, Any> {
                    if result["message"] as? String == "success" { // # Bug: 1209
                        completion(nil, result) // no Error
                    } else {
                        completion(true, nil) // SQL error
                    }
                } else{
                    completion(true, nil) // Parse error
                }
            } catch {
                completion(true, nil) // Some error
            }
        } else {
           completion(true, nil)  // No Data Response
        }
    }
    
    
    
     
        // Login Service NOT USed
        class func loginService(_ parameters: NSDictionary, completion: @escaping CompletionHandler) {
    //        let bParameters:Parameters = [
    //              "email" : parameters["email"] as? String ?? "",
    //              "password": parameters["password"] as? String ?? ""
    //           ]
    //
    //        let bHTTPHeaders: HTTPHeaders = [
    //            "Content-Type" : "application/x-www-form-urlencoded",
    //            "Accept" : "application/json",
    //        ]
    //
            
    //        APIManager.serviceRequest(APIList.userLogin.getConstructedUrl(), method: .post, parms: bParameters, headers: bHTTPHeaders) { (error, result) in
    //            APIManager.responseHandler(result) { (error, result) in
    //                completion(error, result)
    //            }
    //        }
        }
        
         // Registor Service
        class func registorService(completion: @escaping CompletionHandler) {
            if let channelid = UAirship.channel()?.identifier {
                let bParameters:Parameters = [ "devicetoken" : channelid ]
                let bHTTPHeaders: HTTPHeaders = [
                   "Content-Type" : "application/x-www-form-urlencoded",
                   "Accept" : "application/json",
                ]
                APIManager.serviceRequest(APIList.userRegistor.getConstructedUrl(), method: .post, parms: bParameters, headers: bHTTPHeaders) { (error, result) in
                    APIManager.responseHandler(result) { (error, result) in
                       completion(error, result)
                    }
                }
            }else{
               completion(nil, nil)
            }
           
        }
        
}

