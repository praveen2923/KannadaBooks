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
    
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var collectionView: UICollectionView!
    var authors : [Author] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAllAuthors()
        self.setupCells()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.loadBannerAd(self.bannerView)
        self.bannerView.delegate = self
    }
    
    override func viewWillTransition(
       to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator
     ) {
       coordinator.animate(alongsideTransition: { _ in
        self.loadBannerAd(self.bannerView)
       
       })
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
                self.collectionView.reloadData()
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


extension AuthorView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupCells()  {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "AuthorCell", bundle: nil), forCellWithReuseIdentifier: "AuthorCell")
        
        let screenWidth = UIScreen.main.bounds.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/2 - 5, height: 230)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        self.collectionView.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.authors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : AuthorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AuthorCell", for: indexPath) as! AuthorCell
        cell.authorName.text = self.authors[indexPath.row].name
        cell.authorimage.image = UIImage(named: "authorimage")
        if let authorimage = self.authors[indexPath.row].image {
            if authorimage != "" {
                let fullurl = APIList.BOOKBaseUrl + authorimage
                 cell.authorimage?.sd_setImage(with: URL(string: fullurl), placeholderImage: UIImage(named: "authorimage"))
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyBoard.instantiateViewController(withIdentifier: "Books") as! Books
        controller.author = self.authors[indexPath.row]
        controller.categoryid =  "1"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
