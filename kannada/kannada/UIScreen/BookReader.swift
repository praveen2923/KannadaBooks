//
//  BookReader.swift
//  kannada
//
//  Created by PraveenH on 14/04/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Alamofire
import PDFKit

class BookReader: UIViewController {

    @IBOutlet weak var ibPdfView: PDFView!
    
    var bookInfo : Book?
    var bookpdfurl : String?
    var filePath : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = bookInfo?.book_name
        self.addShareButton()
        self.bookDowanload()
    }
    
    func addShareButton() {
        let leftBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "share"), style: .done, target: self, action: #selector(self.didTapOnShareBtn(_:)))
        self.navigationItem.rightBarButtonItem = leftBarButtonItem
    }
    
    @objc func didTapOnShareBtn(_ sender: Any) {

        let fileManager = FileManager.default

        if let path = self.filePath, fileManager.fileExists(atPath: path) {
            let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [path], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        } else {
            print("document was not found")
        }
    }
    
    func bookDowanload() {
        if bookInfo?.book_pdf_url != "" {
            if let bookurl = bookInfo?.book_pdf_url {
                let fullbookpdfurl = APIList.BOOKBaseUrl + bookurl
                 guard let url =  fullbookpdfurl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) else { return  }
                if self.showSavedPdf(fileName: bookInfo?.bookId ?? "") {
                    print("Book is in Locally stored")
                }else{
                    self.downloadPdf(downloadUrl: url, uniqueName: bookInfo?.bookId ?? "") { (filePath, status) in
                        print("URl: \(filePath)")
                     }
                }
            }
        }else{
            self.showeErorMsg("ಪುಸ್ತಕ ಲಭ್ಯವಿಲ್ಲ, ದಯವಿಟ್ಟು ಬೇರೆ ಪುಸ್ತಕವನ್ನು ಓದಿ")
        }
    }
    
    func showSavedPdf(fileName:String) -> Bool {
            if #available(iOS 10.0, *) {
                do {
                    let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                    var isFileInLocal : Bool = false
                    for url in contents {
                        let theFileName = (url.absoluteString as NSString).lastPathComponent
                        if theFileName ==  "\(fileName).pdf"{
                            self.showFileFromLocal(url.absoluteURL)
                            self.filePath = url.path
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
        return false
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

        }
    }
    
        
    func downloadPdf(downloadUrl: String, uniqueName: String, completionHandler:@escaping(String, Bool)->()){
        self.showeLoadingwithText(0)
        let destinationPath: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0];
            let fileURL = documentsURL.appendingPathComponent("\(uniqueName).pdf")
            print(fileURL)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        print(downloadUrl)
        AF.download(downloadUrl, to: destinationPath)
            .downloadProgress { progress in
                self.showeLoadingwithText(Float(progress.fractionCompleted))
            }
            .responseData { response in
                print("response: \(response)")
                switch response.result{
                case .success:
                    if response.fileURL != nil, let filePath = response.fileURL?.absoluteString {
                        if let url = response.fileURL?.absoluteURL {
                             self.showFileFromLocal(url)
                            self.filePath = response.fileURL?.path
                        }
                        self.hideLoading()
                        completionHandler(filePath, true)
                    }
                    break
                case .failure:
                    self.hideLoading()
                    completionHandler("", false)
                    break
                }
        }
    }
    
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.isMovingFromParent {
             AF.cancelAllRequests()
             self.hideLoading()
        }
    }

}

