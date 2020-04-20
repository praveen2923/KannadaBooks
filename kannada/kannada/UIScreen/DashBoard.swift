//
//  DashBoard.swift
//  kannada
//
//  Created by PraveenH on 14/04/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit
import CarbonKit
import GoogleMobileAds

class DashBoard: UIViewController  {

    var values = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       if #available(iOS 13.0, *) {
            navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
       } else {
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.systemBlue]
       }
       self.getCategoryList()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
    }
    

    
    func getCategoryList()  {
        self.showeLoading()
        APIManager.categoryList(nil) { (error, result) in
            self.hideLoading()
            if let array = result as? NSArray {
                for element in array {
                    self.values.append((element as? NSDictionary)?.object(forKey: "categoryname") as! String)
                }
            }else{
                self.showeErorMsg("ದಯವಿಟ್ಟು ಪುನಃ ಪ್ರಯತ್ನಿಸಿ")
            }
            if self.values.count != 0 {
                self.setCarbonframe()
            }
        }
    }
    
    func setCarbonframe()  {
     
        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: self.values, delegate: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        
        carbonTabSwipeNavigation.toolbar.setBackgroundImage(UIImage(),
                                                            forToolbarPosition: UIBarPosition.any,
                                                            barMetrics: UIBarMetrics.default)
        carbonTabSwipeNavigation.toolbar.setShadowImage(UIImage(),
                                                        forToolbarPosition: UIBarPosition.any)
        carbonTabSwipeNavigation.setTabExtraWidth(25)
        carbonTabSwipeNavigation.setTabBarHeight(55)
        carbonTabSwipeNavigation.setSelectedColor(UIColor.systemGreen)
        carbonTabSwipeNavigation.setIndicatorColor(UIColor.systemGreen)
    }

}

extension DashBoard: CarbonTabSwipeNavigationDelegate {
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        if index == 0 {
            let controller = getAuthorListVc()
            return controller
        }else{
            let controller = getBookListVc()
            controller.categoryid =  "\(index + 2)"
            return controller
        }

    }
    
    func getBookListVc() -> Books {
           let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
           let controller = storyBoard.instantiateViewController(withIdentifier: "Books") as! Books
           return controller
       }
    
    func getAuthorListVc() -> AuthorView {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyBoard.instantiateViewController(withIdentifier: "AuthorView") as! AuthorView
        return controller
    }
}



