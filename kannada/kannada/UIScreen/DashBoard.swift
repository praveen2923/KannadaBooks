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
import StoreKit

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
    @IBAction func didTapOnRightMenuBtn(_ sender: Any) {
        let showoption = UIAlertController(title: "ಕನ್ನಡ ಪ್ರೇಮಿ", message: "ನಮ್ಮ ಅಪ್ಲಿಕೇಶನ್ ಅನ್ನು ಸುಧಾರಿಸಲು ನಮಗೆ ಬೆಂಬಲ ನೀಡಿ", preferredStyle: UIAlertController.Style.actionSheet)

        let reviewbtn = UIAlertAction(title: "ಆಪ್ ಸ್ಟೋರ್‌ನಲ್ಲಿ ವಿಮರ್ಶೆ ಮಾಡಿ", style: .default) { (action: UIAlertAction) in
            self.reviewAppStore()
        }

        let emailbtn = UIAlertAction(title: "ನಿಮ್ಮ ಫೀಡ್‌ಬ್ಯಾಕ ಇಮೇಲ್ ಮಾಡಿ", style: .default) { (action: UIAlertAction) in
            self.sendFeedbackEmail()
        }

        let cancelAction = UIAlertAction(title: "ರದ್ದುಮಾಡಿ", style: .destructive, handler: nil)

        showoption.addAction(reviewbtn)
        showoption.addAction(emailbtn)
        showoption.addAction(cancelAction)
        self.present(showoption, animated: true, completion: nil)
        
    }
    
    @IBAction func didTapOnMoreButton(_ sender: Any) {
        
        let showoption = UIAlertController(title: "ಕನ್ನಡ ಪ್ರೇಮಿ", message: "", preferredStyle: UIAlertController.Style.actionSheet)

        let news = UIAlertAction(title: "ಸುದ್ದಿ-ಸಮಾಚಾರ", style: .default) { (action: UIAlertAction) in
            self.moveController()
        }
        let peoples = UIAlertAction(title: "ಪ್ರಸಿದ್ದ ವ್ಯಕ್ತಿಗಳು", style: .default) { (action: UIAlertAction) in
            self.moveController()
        }
        let sahiti = UIAlertAction(title: "ಸಾಹಿತಿಗಳು", style: .default) { (action: UIAlertAction) in
            self.moveController()
        }
        let other = UIAlertAction(title: "ಆಧ್ಯಾತ್ಮ", style: .default) { (action: UIAlertAction) in
            self.moveController()
        }

        let cancelAction = UIAlertAction(title: "ರದ್ದುಮಾಡಿ", style: .destructive, handler: nil)

        showoption.addAction(news)
        showoption.addAction(peoples)
        showoption.addAction(sahiti)
        showoption.addAction(other)
        showoption.addAction(cancelAction)
        self.present(showoption, animated: true, completion: nil)
    }
    
    func sendFeedbackEmail() {
        let supportEmail = "prin17.sh@gmail.com"
        if let emailURL = URL(string: "mailto:\(supportEmail)"), UIApplication.shared.canOpenURL(emailURL)
        {
            UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
        }
    }
    
    func moveController() {
        
    }
    
    func reviewAppStore()  {
        self.showeLoading()
        let parameter : Dictionary<String, Any> = [SKStoreProductParameterITunesItemIdentifier : NSNumber(value: 1509189571)]
        let storeViewController : SKStoreProductViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        storeViewController.loadProduct(withParameters: parameter) { (success, error) in
            if success == true {
                self.hideLoading()
                self.present(storeViewController, animated: true, completion: nil)
            } else {
                self.hideLoading()
                print("NO SUCCESS LOADING PRODUCT SCREEN")
                print("Error ? : \(String(describing: error?.localizedDescription))")
            }
        }
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

extension DashBoard : SKStoreProductViewControllerDelegate {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        print("RECEIVED a FINISH-Message from SKStoreProduktViewController")
        viewController.dismiss(animated: true, completion: nil)
    }
}



