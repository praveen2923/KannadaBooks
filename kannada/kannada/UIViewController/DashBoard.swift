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
import SideMenuSwift
import SVProgressHUD
import StoreKit

class DashBoard: UIViewController  {

    var values = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        SideMenuController.preferences.basic.position = .sideBySide
        SideMenuController.preferences.basic.menuWidth = 250
        SideMenuController.preferences.basic.enableRubberEffectWhenPanning = false
        self.sideMenuController?.revealMenu()
        
    }
    
    func sendFeedbackEmail() {
        let supportEmail = "prin17.sh@gmail.com"
        if let emailURL = URL(string: "mailto:\(supportEmail)"), UIApplication.shared.canOpenURL(emailURL) {
            UIApplication.shared.open(emailURL, options: [:], completionHandler: nil)
        }
    }
    
    func reviewAppStore()  {
        var count = UserDefaults.standard.integer(forKey: UserDefaultsKeys.processCompletedCountKey)
        count += 1
        UserDefaults.standard.set(count, forKey: UserDefaultsKeys.processCompletedCountKey)

        print("Process completed \(count) time(s)")

        // Get the current bundle version for the app
        let infoDictionaryKey = kCFBundleVersionKey as String
        guard let currentVersion = Bundle.main.object(forInfoDictionaryKey: infoDictionaryKey) as? String
            else { fatalError("Expected to find a bundle version in the info dictionary") }

        let lastVersionPromptedForReview = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)

        // Has the process been completed several times and the user has not already been prompted for this version?
        if count >= 3 && currentVersion != lastVersionPromptedForReview {
            let twoSecondsFromNow = DispatchTime.now() + 2.0
            DispatchQueue.main.asyncAfter(deadline: twoSecondsFromNow) { [navigationController] in
                if navigationController?.topViewController is DashBoard {
                    SKStoreReviewController.requestReview()
                    UserDefaults.standard.set(currentVersion, forKey: UserDefaultsKeys.lastVersionPromptedForReviewKey)
                }
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
                self.values.insert("ಆಡಿಯೊಬುಕ್ಸ್", at: 1)
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
        carbonTabSwipeNavigation.pagesScrollView?.isScrollEnabled = false
    }

}

extension DashBoard: CarbonTabSwipeNavigationDelegate {
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        if index == 0 {
            let controller = getAuthorListVc()
            return controller
        } else if index == 1 {
             let controller = getAudioBookListVc()
            return controller
        } else {
            let controller = getOtherListVc()
            controller.categoryid =  "\(index + 1)"
            return controller
        }

    }
    
    func getAudioBookListVc() -> AudioBookViewController {
           let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
           let controller = storyBoard.instantiateViewController(withIdentifier: "AudioBookViewController") as! AudioBookViewController
           return controller
    }
    
    func getOtherListVc() -> OtherListViewController {
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let controller = storyBoard.instantiateViewController(withIdentifier: "OtherListViewController") as! OtherListViewController
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

extension UIViewController {
    func showeErorMsg(_ msg : String)  {
        DispatchQueue.main.async {
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.dismiss(withDelay: 1)
            SVProgressHUD.showError(withStatus: msg)
        }
    }
    
    func showeSucessMsg(_ msg : String)  {
           DispatchQueue.main.async {
               SVProgressHUD.setDefaultStyle(.dark)
               SVProgressHUD.dismiss(withDelay: 1)
                SVProgressHUD.showSuccess(withStatus: msg)
           }
       }
    
    func showeLoading()  {
        DispatchQueue.main.async {
          SVProgressHUD.setDefaultStyle(.dark)
          SVProgressHUD.setRingThickness(5.0)
          SVProgressHUD.show()
        }
    }
    
    func showeLoadingwithText(_ float :  Float)  {
        DispatchQueue.main.async {
          SVProgressHUD.setDefaultStyle(.dark)
          SVProgressHUD.setRingThickness(5.0)
            SVProgressHUD.showProgress(float, status: "ಪುಸ್ತಕ ಡೌನ್‌ಲೋಡ್ ಆಗುತ್ತಿದೆ, ದಯವಿಟ್ಟು ಕಾಯಿರಿ")
        }
    }
    
    func hideLoading()  {
        SVProgressHUD.dismiss()
    }
    
    func loadBannerAd(_ bannerView : GADBannerView) {
        bannerView.adUnitID = unitKey
        bannerView.rootViewController = self
        let frame = { () -> CGRect in
        if #available(iOS 11.0, *) {
            return view.frame.inset(by: view.safeAreaInsets)
        } else {
            return view.frame
        } }()
        let viewWidth = frame.size.width
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        bannerView.load(GADRequest())
    }
}

extension DashBoard : MenuToDashboard {
    func tapOnIndex(index: Int) {
        //
    }
    
    func tapOnValue(value: String) {
        //
    }
    
    func navigateToVC(vc: UIViewController) {
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
