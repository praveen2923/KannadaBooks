//
//  AboutUsViewController.swift
//  kannada
//
//  Created by PraveenH on 26/05/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet weak var ibCommentTextview: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ನಮ್ಮ ಬಗ್ಗೆ"
        ibCommentTextview.delegate = self
        ibCommentTextview.text = "ನಿಮ್ಮ ಕಾಮೆಂಟ್‌ ಅನ್ನು ನಮೂದಿಸಿ..."
        ibCommentTextview.textColor = UIColor.lightGray
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
