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
    var authors : [Author] = []
    var list = ["ಜನಪ್ರಿಯ ಪುಸ್ತಕಗಳು","ಕನ್ನಡ ಸಾಹಿತ್ಯ","ಜನಪ್ರಿಯ ಬರಹಗಾರ","ಇತ್ತೀಚಿನ ಪುಸ್ತಕಗಳು", "ವೈಶಿಷ್ಟ್ಯಪೂರ್ಣ ಪುಸ್ತಕಗಳು"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAllAuthors()
        self.configureTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    
    func getAllAuthors()  {
        APIManager.authorList(nil) { (error, result) in
            if let listauthors = result as? NSArray {
                for item in listauthors {
                    if let author = Author(dictionary: item as! NSDictionary) {
                        self.authors.append(author)
                    }
                }
                self.authors = self.authors.shuffled()
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
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.list.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AuthorTableViewCell", for: indexPath) as! AuthorTableViewCell
        cell.authors = self.authors
        cell.collectionView.reloadData()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 195
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.list[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.tintColor =  self.tableView.backgroundColor //use any color you want here .red, .black etc
        headerView.textLabel?.textColor = .white
        headerView.textLabel?.font = .systemFont(ofSize: 15)
    }
}
