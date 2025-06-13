//
//  Books.swift
//  kannada
//
//  Created by PraveenH on 14/04/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit
import GoogleMobileAds

class OtherListViewController: UIViewController {
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tableView: UITableView!

    var others : [Other] = []
    var categoryid : String?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.getAllOtherInformation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        bannerView.delegate = self
            bannerView.rootViewController = self
            bannerView.load(GADRequest())
    }
    
    
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
                    self.hideLoading()
                    self.tableView.reloadData()
                }
            }else{
                self.showeErorMsg("ಮಾಹಿತಿ ಲಭ್ಯವಿಲ್ಲ ದಯವಿಟ್ಟು ನಂತರ ಪ್ರಯತ್ನಿಸಿ")
            }
        }
    }
}

extension OtherListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView()  {
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.registerCellforTableview()

    }
    
    func registerCellforTableview()  {
        let nib = UINib(nibName: "HistoryCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "HistoryCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.others.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return getHistoryCell(indexPath: indexPath)
    }
    
    func getHistoryCell(indexPath: IndexPath) -> HistoryCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.ibTitleLbl.text = self.others[indexPath.row].short
        cell.ibDetailsLbl.text = self.others[indexPath.row].note
        return cell
                  
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.categoryid == "1" {
            return 100
          }else{
            return 150
        }
    }
}

extension OtherListViewController : CellDelegate {
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

extension OtherListViewController : GADBannerViewDelegate{
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
         print("adViewDidReceiveAd")
       }

       func adView(_ bannerView: GADBannerView,
           didFailToReceiveAdWithError error: GADRequestError) {
         print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
       }

       func adViewWillPresentScreen(_ bannerView: GADBannerView) {
         print("adViewWillPresentScreen")
       }
}


 

