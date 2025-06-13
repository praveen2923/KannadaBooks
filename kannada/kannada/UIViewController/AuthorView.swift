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

    @IBOutlet weak var tableView: UITableView!
    var bookcatalogue : Bookcatalogue?
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getBookCatalogue()
        self.configureTableView()
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
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
            cell.bookslist = nil
        }else{
            cell.bookslist = self.bookcatalogue?.catlist?[indexPath.section].otherbooks
            cell.authorlist = nil
        }
        cell.delegate = self
        cell.collectionView.reloadData()
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 195
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerSectionCell:TableViewHeaderCell = tableView.dequeueReusableCell(withIdentifier: "TableViewHeaderCell") as! TableViewHeaderCell
        var count = ""
        if section == 0 {
            if let listcount = self.bookcatalogue?.catlist?[section].authors?.count {
                count = " (\(listcount))"
            }
        }else{
            if let listcount = self.bookcatalogue?.catlist?[section].otherbooks?.count {
                count = " (\(listcount))"
            }
        }
        if let type = self.bookcatalogue?.catlist?[section].name {
             headerSectionCell.ibHeaderTitle.text = "\(type)\(count)"
        }
       
        headerSectionCell.section = section
        headerSectionCell.delegate = self
        return headerSectionCell
    }
}

extension AuthorView : SeeMoreDelegate {
    func didTapOnSeeMoreBtn(_ section : Int) {
        print("didTapOnSeeMoreBtn")
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyBoard.instantiateViewController(withIdentifier: "BookListViewController") as! BookListViewController
        controller.navtitle = self.bookcatalogue?.catlist?[section].name
        if let authors = self.bookcatalogue?.catlist?[section].authors {
            if authors.count != 0 {
                controller.authorlist = authors
            }else if let books = self.bookcatalogue?.catlist?[section].otherbooks {
                controller.bookslist = books
            }
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

extension AuthorView : TapOnBookCellDelegate {
    func didSelectItemAt(_ author : Authors?, _ books : Books?){
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if author != nil {
            let controller = storyBoard.instantiateViewController(withIdentifier: "BookListViewController") as! BookListViewController
            controller.authors = author
            controller.navtitle = author?.authorname
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
            let controller = storyBoard.instantiateViewController(withIdentifier: "BookReader") as! BookReader
            controller.book = books
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension AuthorView : GADBannerViewDelegate{
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
