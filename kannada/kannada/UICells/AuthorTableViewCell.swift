//
//  AuthorTableViewCell.swift
//  kannada
//
//  Created by PraveenH on 21/05/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit

class AuthorTableViewCell: UITableViewCell {
    
    var authors : [Author] = []

    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupCells()
    }
    
  

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension AuthorTableViewCell :  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    func setupCells()  {
          self.collectionView.delegate = self
          self.collectionView.dataSource = self
          self.collectionView.register(UINib(nibName: "AuthorCell", bundle: nil), forCellWithReuseIdentifier: "AuthorCell")
          
          let screenWidth = UIScreen.main.bounds.width
          let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
          layout.sectionInset = UIEdgeInsets(top: 2, left: 1, bottom: 5, right: 0)
          layout.itemSize = CGSize(width: screenWidth/3 - 1, height: 180)
          layout.minimumInteritemSpacing = 1
          layout.minimumLineSpacing = 1
          layout.scrollDirection = .horizontal
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
//           let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
//           let controller = storyBoard.instantiateViewController(withIdentifier: "BookListViewController") as! BookListViewController
//           controller.author = self.authors[indexPath.row]
//           controller.categoryid =  "1"
          // self.navigationController?.pushViewController(controller, animated: true)
       }
}


