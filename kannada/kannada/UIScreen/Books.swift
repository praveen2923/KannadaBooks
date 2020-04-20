//
//  Books.swift
//  kannada
//
//  Created by PraveenH on 14/04/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit
import GoogleMobileAds


class Books: UIViewController {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tableView: UITableView!
    
    var author : Author?
    var books : [Book] = []
    var others : [Other] = []
    var categoryid : String?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        
        if categoryid == "1" {
            self.getAllBooksForAuthor()
            self.navigationItem.title = author?.name
        } else {
            self.getAllOtherInformation()
        }
        self.loadBannerAd(self.bannerView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
 //   override func viewWillTransition(
   //    to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator
    // ) {
      // coordinator.animate(alongsideTransition: { _ in
       //  self.loadBannerAd(self.bannerView)
      // })
     //}
    
    func getAllOtherInformation() {
        self.showeLoading()
        APIManager.getAllInformationforCategory(self.categoryid) { (error, result) in
            if let values = result as? Array<Any> {
                for item in values {
                  if let abook = Other(dictionary: item as! NSDictionary) {
                       self.others.append(abook)
                   }
                }
                if self.others.count == 0 {
                    self.showeErorMsg("ಮಾಹಿತಿ ಲಭ್ಯವಿಲ್ಲ ದಯವಿಟ್ಟು ನಂತರ ಪ್ರಯತ್ನಿಸಿ")
                }else{
                    self.others = self.others.shuffled()
                    self.hideLoading()
                    self.tableView.reloadData()
                }
            }else{
                self.showeErorMsg("ಮಾಹಿತಿ ಲಭ್ಯವಿಲ್ಲ ದಯವಿಟ್ಟು ನಂತರ ಪ್ರಯತ್ನಿಸಿ")
            }
        }
    }
    
    func getAllBooksForAuthor() {
        self.showeLoading()
        APIManager.getAllBooksForAuthor(author?.iD) { (error, result) in
            if let values = result as? Array<Any> {
                for item in values {
                  if let abook = Book(dictionary: item as! NSDictionary) {
                       self.books.append(abook)
                   }
                }
                if self.books.count == 0 {
                    self.showeErorMsg("ಮಾಹಿತಿ ಲಭ್ಯವಿಲ್ಲ ದಯವಿಟ್ಟು ನಂತರ ಪ್ರಯತ್ನಿಸಿ")
                }else{
                    self.books = self.books.shuffled()
                    self.hideLoading()
                    self.tableView.reloadData()
                }
            }else{
                self.showeErorMsg("ಮಾಹಿತಿ ಲಭ್ಯವಿಲ್ಲ ದಯವಿಟ್ಟು ನಂತರ ಪ್ರಯತ್ನಿಸಿ")
            }
        }
    }
}

extension Books : UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView()  {
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.registerCellforTableview()

    }
    
    func registerCellforTableview()  {
        if self.categoryid == "1" {
            let nib = UINib(nibName: "BookCell", bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: "BookCell")
        }else{
            let nib = UINib(nibName: "HistoryCell", bundle: nil)
            self.tableView.register(nib, forCellReuseIdentifier: "HistoryCell")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categoryid == "1" {
            return self.books.count
        }else{
            return self.others.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.categoryid == "1" {
            return getBookListCell(indexPath: indexPath)
        } else {
            return getHistoryCell(indexPath: indexPath)
        }
    }
    
    func getHistoryCell(indexPath: IndexPath) -> HistoryCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.ibTitleLbl.text = self.others[indexPath.row].short
        cell.ibDetailsLbl.text = self.others[indexPath.row].note
        return cell
                  
    }
    
    func getBookListCell(indexPath: IndexPath) -> BookCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookCell
        cell.selectionStyle = .none
        cell.ibBookName.text = self.books[indexPath.row].book_name
        cell.ibBookPublish.text = self.books[indexPath.row].book_publish
        cell.imageView?.image = UIImage(named: "defultauthorimage")
                           
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.categoryid == "1" {
            return 100
          }else{
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.categoryid == "1" {
           let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BookReader") as? BookReader
           vc?.bookInfo = self.books[indexPath.row]
           self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}

extension Books : CellDelegate {
    func didTapOnmoredetails(_ cell: HistoryCell) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyBoard.instantiateViewController(withIdentifier: "MoreDetailsView") as! MoreDetailsView
         let indexPath = self.tableView.indexPath(for: cell)
        if let row = indexPath?.row {
            controller.detail = self.others[row]
        }
        self.present(controller, animated: true, completion: nil)
    }
}

 

