//
//  BookListViewController.swift
//  kannada
//
//  Created by PraveenH on 02/05/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit

class BookListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var books : [Book] = []
    var categoryid : String?
    var author : Author?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCells()
        self.title = author?.name
        self.getAllBooksForAuthor()
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
                       self.collectionView.reloadData()
                   }
               }else{
                   self.showeErorMsg("ಮಾಹಿತಿ ಲಭ್ಯವಿಲ್ಲ ದಯವಿಟ್ಟು ನಂತರ ಪ್ರಯತ್ನಿಸಿ")
               }
           }
       }
    

}

extension BookListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupCells()  {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "BookListCell", bundle: nil), forCellWithReuseIdentifier: "BookListCell")
        
        let screenWidth = UIScreen.main.bounds.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3 - 5, height: 180)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        self.collectionView.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : BookListCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookListCell", for: indexPath) as! BookListCell
        cell.ibBookName.text = self.books[indexPath.row].book_name
        
        cell.ibbookimage.image = UIImage(named: "book")
        if let authorimage = self.books[indexPath.row].book_image_url {
            if authorimage != "" {
                let fullurl = APIList.BOOKBaseUrl + authorimage
                 cell.ibbookimage?.sd_setImage(with: URL(string: fullurl), placeholderImage: UIImage(named: "book"))
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BookReader") as? BookReader
                vc?.bookInfo = self.books[indexPath.row]
                self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
