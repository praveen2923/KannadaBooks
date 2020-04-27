//
//  NewFeedsViewController.swift
//  kannada
//
//  Created by PraveenH on 26/04/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit

class NewFeedsViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    var menuId : String?
    var newsFeed : [NewsFeed] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.getFeedById()
    }
    
    func getFeedById() {
        APIManager.getFeedformationByMenuId(self.menuId) { (error, result) in
           if let values = result as? Array<Any> {
               for item in values {
                 if let abook = NewsFeed(dictionary: item as! NSDictionary) {
                      self.newsFeed.append(abook)
                  }
               }
               if self.newsFeed.count == 0 {
                   self.showeErorMsg("ಮಾಹಿತಿ ಲಭ್ಯವಿಲ್ಲ ದಯವಿಟ್ಟು ನಂತರ ಪ್ರಯತ್ನಿಸಿ")
               }else{
                   self.hideLoading()
                   self.tableview.reloadData()
               }
           }else{
               self.showeErorMsg("ಮಾಹಿತಿ ಲಭ್ಯವಿಲ್ಲ ದಯವಿಟ್ಟು ನಂತರ ಪ್ರಯತ್ನಿಸಿ")
           }
        }
    }
}


extension NewFeedsViewController : UITableViewDelegate, UITableViewDataSource {

    func configureTableView()  {
        self.tableview?.delegate = self
        self.tableview?.dataSource = self
        let nib = UINib(nibName: "FeedNewsCell", bundle: nil)
        self.tableview.register(nib, forCellReuseIdentifier: "FeedNewsCell")

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsFeed.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      return getMenuCell(indexPath: indexPath)
    }

    func getMenuCell(indexPath: IndexPath) -> FeedNewsCell {
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "FeedNewsCell", for: indexPath) as! FeedNewsCell
        cell.selectionStyle = .none
        cell.ibFeedLbl.text = self.newsFeed[indexPath.row].note
        cell.ibFeedImage.image = UIImage(named: "kannada")
        if let authorimage = self.newsFeed[indexPath.row].image {
            if authorimage != "" {
                let fullurl = APIList.BOOKBaseUrl + authorimage
                 cell.authorimage?.sd_setImage(with: URL(string: fullurl), placeholderImage: UIImage(named: "authorimage"))
            }
        }
        
        return cell
    }
 

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 170
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
    }
}
