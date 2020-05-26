//
//  AuthorTableViewCell.swift
//  kannada
//
//  Created by PraveenH on 21/05/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit

protocol TapOnBookCellDelegate: class {
    func didSelectItemAt(_ author : Authors?, _ books : Books?)
}

class AuthorTableViewCell: UITableViewCell {
    
    var authorlist : Array<Authors>?
    var bookslist : Array<Books>?
    weak var delegate: TapOnBookCellDelegate?

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
            if let authors = self.authorlist {
              return authors.count
            }
            return self.bookslist?.count ?? 0
       }
       
       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell : AuthorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AuthorCell", for: indexPath) as! AuthorCell
            if self.bookslist != nil {
                cell.authorName.text = self.bookslist?[indexPath.row].bookname
                cell.authorimage.image = UIImage(named: "authorimage")
                if let authorimage = self.bookslist?[indexPath.row].bookimageurl {
                    if authorimage != "" {
                        let fullurl = APIList.BOOKBaseUrl + authorimage
                        cell.authorimage?.sd_setImage(with: URL(string: fullurl), placeholderImage: UIImage(named: "noimage"))
                    }
                }
            }else{
                cell.authorName.text = self.authorlist?[indexPath.row].authorname
                cell.authorimage.image = UIImage(named: "authorimage")
                if let authorimage = self.authorlist?[indexPath.row].authorimage {
                    if authorimage != "" {
                        let fullurl = APIList.BOOKBaseUrl + authorimage
                        cell.authorimage?.sd_setImage(with: URL(string: fullurl), placeholderImage: UIImage(named: "noimage"))
                    }
                }
            }
            return cell
       }
       
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
          if self.bookslist != nil {
                let books = self.bookslist?[indexPath.row]
                self.delegate?.didSelectItemAt(nil, books)
          }else{
            let author = self.authorlist?[indexPath.row]
            self.delegate?.didSelectItemAt(author, nil)
          }
       }
}


