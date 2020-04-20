//
//  LoginView.swift
//  kannada
//
//  Created by PraveenH on 17/04/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit
import GoogleMobileAds

class LoginView: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var ibPassword: UITextField!
    @IBOutlet weak var ibEmailIdTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ಲಾಗಿನ್ ಮಾಡಿ"
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
        self.loadBannerAd(self.bannerView)
    }
    
    override func viewWillTransition(
      to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator
    ) {
      coordinator.animate(alongsideTransition: { _ in
       // self.loadBannerAd(self.bannerView)
      })
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    
    @IBAction func didTapOnLogin(_ sender: Any) {

        if let text = self.ibEmailIdTextField.text {
            if text == "" || !text.isEmail {
                 self.showeErorMsg("ಸರಿಯಾದ ಇಮೇಲ್ ಐಡಿ ನಮೂದಿಸಿ")
                 return
             }
         }
        
        if let text = self.ibPassword.text {
            if text == "" || text.isBlank {
                self.showeErorMsg("ಸರಿಯಾದ ಪಾಸ್ವರ್ಡ್ ಅನ್ನು ನಮೂದಿಸಿ")
                return
            }
        }
        
        self.showeLoading()
        let param = ["email":self.ibEmailIdTextField.text, "password":self.ibPassword.text]
        
        APIManager.loginService(param as NSDictionary) { (error, result) in
            self.hideLoading()
            if let _ = result {
                UD.shared.setUserLogedIn(true)
                self.setRouteViewController()
            }else{
                self.showeErorMsg("ನೀವು ತಪ್ಪು ಮಾಹಿತಿಯನ್ನು ನಮೂದಿಸಿದ್ದೀರಿ ದಯವಿಟ್ಟು ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ")
            }
        }
    }
    
    func setRouteViewController()  {
        let rootVC:DashBoard = self.storyboard?.instantiateViewController(withIdentifier: "DashBoard") as! DashBoard
        let nvc:UINavigationController = self.storyboard?.instantiateViewController(withIdentifier: "RootNavigationController") as! UINavigationController
        nvc.viewControllers = [rootVC]
        if let keyWindow = UIWindow.key { keyWindow.rootViewController = nvc }
    }
}


extension LoginView : GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("recived add")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print(error)
    }
}
