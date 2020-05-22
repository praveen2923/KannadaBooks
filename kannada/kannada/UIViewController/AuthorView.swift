//
//  AuthorView.swift
//  kannada
//
//  Created by PraveenH on 16/04/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit
import SDWebImage
import GoogleMobileAds

class AuthorView: UIViewController {
    
 //   @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    var bookcatalogue : Bookcatalogue?
   // var list = ["ಜನಪ್ರಿಯ ಪುಸ್ತಕಗಳು","ಕನ್ನಡ ಸಾಹಿತ್ಯ","ಜನಪ್ರಿಯ ಬರಹಗಾರ","ಇತ್ತೀಚಿನ ಪುಸ್ತಕಗಳು", "ವೈಶಿಷ್ಟ್ಯಪೂರ್ಣ ಪುಸ್ತಕಗಳು", "ಶಾಲಾ ಪಠ್ಯ ಪುಸ್ತಕಗಳು"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getBookCatalogue()
        self.configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
  //  getBookCatalogue
    func getBookCatalogue()  {
        APIManager.getBookCatalogue(nil) { (error, result) in
            if let catalogue = result as? NSDictionary {
                self.bookcatalogue = Bookcatalogue(dictionary: catalogue)
                self.tableView.reloadData()
            }else{
                
            }
        }
    }
}

extension AuthorView : GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("recived add")
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Failed recieved:\(error)")
    }
}

extension AuthorView : UITableViewDelegate, UITableViewDataSource {
    
    func configureTableView()  {
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        let nib = UINib(nibName: "AuthorTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "AuthorTableViewCell")
        
        let header = UINib(nibName: "TableViewHeaderCell", bundle: nil)
        self.tableView.register(header, forCellReuseIdentifier: "TableViewHeaderCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.bookcatalogue?.catlist?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AuthorTableViewCell", for: indexPath) as! AuthorTableViewCell
        if indexPath.section == 0 {
            cell.authorlist = self.bookcatalogue?.catlist?[indexPath.section].authors
        }else{
            cell.bookslist = self.bookcatalogue?.catlist?[indexPath.section].otherbooks
        }

        cell.collectionView.reloadData()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 195
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerSectionCell:TableViewHeaderCell = tableView.dequeueReusableCell(withIdentifier: "TableViewHeaderCell") as! TableViewHeaderCell
        headerSectionCell.ibHeaderTitle.text = self.bookcatalogue?.catlist?[section].name 
        return headerSectionCell
    }
}
