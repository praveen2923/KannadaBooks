//
//  BookListViewController.swift
//  kannada
//
//  Created by PraveenH on 02/05/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit

class BookListViewController: UIViewController {
    
    @IBOutlet weak var collection: UICollectionView!
    var authors : Authors?
    var authorlist : [Authors] = []
    var bookslist : [Books] = []
    var navtitle: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = navtitle
        self.setupCells()
        if let books = self.authors?.books {
            self.bookslist.append(contentsOf: books)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension BookListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupCells()  {
        self.collection.delegate = self
        self.collection.dataSource = self
        self.collection.register(UINib(nibName: "BookListCell", bundle: nil), forCellWithReuseIdentifier: "BookListCell")
        
        let screenWidth = UIScreen.main.bounds.width
          let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
          layout.sectionInset = UIEdgeInsets(top: 2, left: 1, bottom: 5, right: 0)
          layout.itemSize = CGSize(width: screenWidth/3 - 1, height: 180)
          layout.minimumInteritemSpacing = 1
          layout.minimumLineSpacing = 1
          self.collection.collectionViewLayout = layout

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if bookslist.count != 0 {
             return bookslist.count
        }else{
            return authorlist.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : BookListCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookListCell", for: indexPath) as! BookListCell
        if self.bookslist.count != 0 {
            cell.ibBookName.text = self.bookslist[indexPath.row].bookname
               cell.ibbookimage.image = UIImage(named: "book")
            if let authorimage = self.bookslist[indexPath.row].bookimageurl {
                   if authorimage != "" {
                       let fullurl = APIList.BOOKBaseUrl + authorimage
                        cell.ibbookimage?.sd_setImage(with: URL(string: fullurl), placeholderImage: UIImage(named: "noimage"))
                   }
               }
        }else{
            cell.ibBookName.text = authorlist[indexPath.row].authorname
               cell.ibbookimage.image = UIImage(named: "book")
            if let authorimage = authorlist[indexPath.row].authorimage{
                   if authorimage != "" {
                       let fullurl = APIList.BOOKBaseUrl + authorimage
                        cell.ibbookimage?.sd_setImage(with: URL(string: fullurl), placeholderImage: UIImage(named: "noimage"))
                   }
               }
        }
        
   

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if bookslist.count != 0 {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BookReader") as? BookReader
            vc?.book = self.bookslist[indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            let author = self.authorlist[indexPath.row]
            if let books = author.books {
                self.bookslist.append(contentsOf: books)
            }
            self.title = author.authorname
            self.collection.reloadData()
        }
    }
}
