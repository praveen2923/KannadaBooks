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
import Alamofire
import PDFKit

class BookReader: UIViewController, WKNavigationDelegate, WKUIDelegate {

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var ibPdfView: PDFView!
    
    var bookInfo : Book?
    var bookpdfurl : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = bookInfo?.book_name
   
        
        if bookInfo?.book_pdf_url != "" {
            if let bookurl = bookInfo?.book_pdf_url {
                let fullbookpdfurl = APIList.BOOKBaseUrl + bookurl
                 guard let url =  fullbookpdfurl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) else { return  }
                if self.showSavedPdf(fileName: bookInfo?.book_name ?? "") {
                    print()
                }else{
                    self.downloadPdf(downloadUrl: url, uniqueName: bookInfo?.book_name ?? "") { (filePath, status) in
                        print("URl: \(filePath)")
                     }
                }
            }
        }else{
            self.showeErorMsg("ಪುಸ್ತಕ ಲಭ್ಯವಿಲ್ಲ, ದಯವಿಟ್ಟು ಬೇರೆ ಪುಸ್ತಕವನ್ನು ಓದಿ")
        }
          self.loadBannerAd(self.bannerView)
    }
    
    func showSavedPdf(fileName:String) -> Bool {
        if let fileNameEncode =  fileName.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) {
            if #available(iOS 10.0, *) {
                do {
                    let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                    var isFileInLocal : Bool = false
                    for url in contents {
                        if url.description.contains("\(fileNameEncode).pdf") {
                            self.showFileFromLocal(url.absoluteURL )
                            print("file found in local storage")
                            isFileInLocal = true
                            break;
                        }
                    }
                    return isFileInLocal
                } catch {
                    print("could not locate pdf file !!!!!!!")
                    return false
                }
            }
        }
        return false
    }
    enum WebError: Swift.Error {
        case fileNotFound(name: String)
        case parsing(contentsOfFile: String)
    }
    
    func showFileFromLocal(_ filePath : URL) {
        if let document = PDFDocument(url: filePath) {
            self.ibPdfView.autoresizesSubviews = true
            self.ibPdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleTopMargin, .flexibleLeftMargin]
            self.ibPdfView.displayDirection = .vertical

            self.ibPdfView.autoScales = true
            self.ibPdfView.displayMode = .singlePageContinuous
            self.ibPdfView.displaysPageBreaks = true
            self.ibPdfView.document = document

              self.ibPdfView.maxScaleFactor = 4.0
              self.ibPdfView.minScaleFactor =   self.ibPdfView.scaleFactorForSizeToFit
            
            
//            self.ibPdfView.document = document
//            self.ibPdfView.translatesAutoresizingMaskIntoConstraints = false
//            self.ibPdfView.minScaleFactor = ibPdfView.scaleFactor
//            self.ibPdfView.maxScaleFactor = ibPdfView.scaleFactorForSizeToFit
        }
    }
    
        
    func downloadPdf(downloadUrl: String, uniqueName: String, completionHandler:@escaping(String, Bool)->()){

        let destinationPath: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0];
            let fileURL = documentsURL.appendingPathComponent("\(uniqueName).pdf")
            print(fileURL)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        print(downloadUrl)
        AF.download(downloadUrl, to: destinationPath)
            .downloadProgress { progress in

            }
            .responseData { response in
                print("response: \(response)")
                switch response.result{
                case .success:
                    if response.fileURL != nil, let filePath = response.fileURL?.absoluteString {
                        if let url = response.fileURL?.absoluteURL {
                             self.showFileFromLocal(url)
                        }
                       
                        completionHandler(filePath, true)
                    }
                    break
                case .failure:
                    completionHandler("", false)
                    break
                }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.ibPdfView.autoScales = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
             self.hideLoading()
        }
    }
    
    override func viewDidLayoutSubviews() {
        
    }
}

