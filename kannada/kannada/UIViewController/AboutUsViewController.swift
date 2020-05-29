//
//  AboutUsViewController.swift
//  kannada
//
//  Created by PraveenH on 26/05/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet weak var ibEmailTxt: UITextField!
    @IBOutlet weak var ibNameTxt: UITextField!
    @IBOutlet weak var ibCommentTextview: UITextView!
    @IBOutlet weak var ibSendMessageBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ನಮ್ಮ ಬಗ್ಗೆ"
        ibCommentTextview.delegate = self
        ibCommentTextview.text = "ನಿಮ್ಮ ಕಾಮೆಂಟ್‌ ಅನ್ನು ನಮೂದಿಸಿ..."
        ibCommentTextview.textColor = UIColor.lightGray
        self.ibSendMessageBtn.isEnabled = true
        if UD.shared.getFeedbackMessageSent()  {
             self.ibSendMessageBtn.isEnabled = false
            self.ibSendMessageBtn.setTitle("ಕಳುಹಿಸಲಾಗಿದೆ", for: .normal)
        }
    }
    
    @IBAction func didTapOnSendFeedbackBtn(_ sender: Any) {
        if let name = self.ibNameTxt.text {
            if name == "" || name.isBlank {
                self.showeErorMsg("ದಯವಿಟ್ಟು ಹೆಸರನ್ನು ನಮೂದಿಸಿ")
                return
            }
        }
    
        if let email = self.ibEmailTxt.text {
            if email == "" || email.isBlank || !email.isEmail {
                self.showeErorMsg("ದಯವಿಟ್ಟು ಇಮೇಲ್ ಐಡಿ ನಮೂದಿಸಿ")
                return
            }
        }
        if let feedback = self.ibCommentTextview.text {
            if feedback == "" || feedback.isBlank || feedback == "ನಿಮ್ಮ ಕಾಮೆಂಟ್‌ ಅನ್ನು ನಮೂದಿಸಿ..." {
                 self.showeErorMsg("ದಯವಿಟ್ಟು ಸಂದೇಶವನ್ನು ನಮೂದಿಸಿ")
                return
            }
        }
        self.showeLoading()
        APIManager.sendFeedMessage(self.ibNameTxt.text ?? "", self.ibEmailTxt.text ?? "", self.ibEmailTxt.text ?? "") { (error, message) in
            self.hideLoading()
            UD.shared.setFeedbackMessageSent(true)
            self.showeSucessMsg("ನಿಮ್ಮ ಕಾಮೆಂಟ್ ಅನ್ನು ನಾವು ಸ್ವೀಕರಿಸಿದ್ದೇವೆ")
        }
    }
}

extension AboutUsViewController : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if ibCommentTextview.textColor == UIColor.lightGray {
            ibCommentTextview.text = ""
            ibCommentTextview.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if ibCommentTextview.text == "" {
            ibCommentTextview.text = "ನಿಮ್ಮ ಕಾಮೆಂಟ್‌ ಅನ್ನು ನಮೂದಿಸಿ..."
            ibCommentTextview.textColor = UIColor.lightGray
        }
    }
}
