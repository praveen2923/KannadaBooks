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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCells()
        // Do any additional setup after loading the view.
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
        layout.itemSize = CGSize(width: screenWidth/3 - 5, height: 200)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        self.collectionView.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : BookListCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookListCell", for: indexPath) as! BookListCell

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
}
