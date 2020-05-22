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
    var books : Books?

    override func viewDidLoad() {
        super.viewDidLoad()
       
        if let auth = self.authors {
            self.title = auth.authorname
        }
         
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupCells()
    }
}

extension BookListViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupCells()  {
        self.collection.delegate = self
        self.collection.dataSource = self
        self.collection.register(UINib(nibName: "BookListCell", bundle: nil), forCellWithReuseIdentifier: "BookListCell")
        
        let screenWidth = UIScreen.main.bounds.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3 - 5, height: 180)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        self.collection.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.authors?.books?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : BookListCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookListCell", for: indexPath) as! BookListCell
        let book = self.authors?.books?[indexPath.row]
        
        cell.ibBookName.text = book?.bookname

        cell.ibbookimage.image = UIImage(named: "book")
        if let authorimage = book?.bookimageurl{
            if authorimage != "" {
                let fullurl = APIList.BOOKBaseUrl + authorimage
                 cell.ibbookimage?.sd_setImage(with: URL(string: fullurl), placeholderImage: UIImage(named: "book"))
            }
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      //  let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "BookReader") as? BookReader
               // vc?.bookInfo = self.books[indexPath.row]
               // self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
