//
//  RegisterView.swift
//  kannada
//
//  Created by PraveenH on 16/04/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit
import SVProgressHUD
import GoogleMobileAds

class RegisterView: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var ibReenterPassword: UITextField!
    @IBOutlet weak var ibPasswordTextField: UITextField!
    @IBOutlet weak var ibPhoneTextField: UITextField!
    @IBOutlet weak var ibEmailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapOnCancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapOnRegisterBtn(_ sender: Any) {
        
       if let text = self.ibEmailTextField.text {
           if text == "" || !text.isEmail {
                self.showeErorMsg("ಸರಿಯಾದ ಇಮೇಲ್ ಐಡಿ ನಮೂದಿಸಿ")
                return
            }
        }
        if let text = self.ibPhoneTextField.text {
            if text == "" || !text.isPhoneNumber {
                self.showeErorMsg("ಸರಿಯಾದ ಫೋನ್ ಸಂಖ್ಯೆಯನ್ನು ನಮೂದಿಸಿ")
               return
            }
        }
        if let text = self.ibPasswordTextField.text {
            if text == "" || text.isBlank {
                self.showeErorMsg("ಸರಿಯಾದ ಪಾಸ್ವರ್ಡ್ ಅನ್ನು ನಮೂದಿಸಿ")
                return
            }
        }
        if let text = self.ibReenterPassword.text {
            if text == "" || text.isBlank  || text != self.ibPasswordTextField.text {
                self.showeErorMsg("ಮರು ನಮೂದಿಸಿದ್ದ ಪಾಸ್ವರ್ಡ್ ಪರಿಶೀಲಿಸಿ")
                return
            }
        }
        self.showeLoading()
        let param = ["email":self.ibEmailTextField.text, "password":self.ibPasswordTextField.text, "phone":self.ibPhoneTextField.text]
        
        APIManager.registorService(param as NSDictionary) { (error, result) in
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
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

extension UIViewController {
    func showeErorMsg(_ msg : String)  {
        DispatchQueue.main.async {
            SVProgressHUD.setDefaultStyle(.dark)
            SVProgressHUD.showError(withStatus: msg)
        }
    }
    func showeLoading()  {
        DispatchQueue.main.async {
          SVProgressHUD.setDefaultStyle(.dark)
          SVProgressHUD.setRingThickness(5.0)
         SVProgressHUD.show()
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


