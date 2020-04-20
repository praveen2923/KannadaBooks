//
//  BookReader.swift
//  kannada
//
//  Created by PraveenH on 14/04/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit
import WebKit
import GoogleMobileAds

class BookReader: UIViewController {

    @IBOutlet weak var ibwebview: WKWebView!
    @IBOutlet weak var bannerView: GADBannerView!
    var bookInfo : Book?
    var bookpdfurl : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ibwebview!.isOpaque = false
        self.ibwebview!.backgroundColor = UIColor.clear
        self.ibwebview!.scrollView.backgroundColor = UIColor.clear
        
        self.navigationItem.title = bookInfo?.book_name
        if bookInfo?.book_pdf_url != "" {
            self.bookpdfurl = bookInfo?.book_pdf_url
            self.loadBook()
        }else{
            self.showeErorMsg("ಪುಸ್ತಕ ಲಭ್ಯವಿಲ್ಲ, ದಯವಿಟ್ಟು ಬೇರೆ ಪುಸ್ತಕವನ್ನು ಓದಿ")
        }
          self.loadBannerAd(self.bannerView)
    }
    
    override func viewWillTransition(
          to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator
        ) {
          coordinator.animate(alongsideTransition: { _ in
            self.loadBannerAd(self.bannerView)
          })
    }
    
    func loadBook()  {
        if let bookurl = bookpdfurl {
             let fullbookpdfurl = APIList.BOOKBaseUrl + bookurl
             guard let url =  fullbookpdfurl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) else { return  }
             if let myURL = URL(string:url) {
                 self.showeLoading()
                 DispatchQueue.global(qos: .background).async {
                 if let data = try? Data(contentsOf: myURL) {
                   DispatchQueue.main.async {
                         self.ibwebview.load(data, mimeType: "application/pdf", characterEncodingName: "", baseURL: myURL)
                                             self.hideLoading()
                     }
                    
                 }
             }
           }
         }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
             self.hideLoading()
        }
    }
}
