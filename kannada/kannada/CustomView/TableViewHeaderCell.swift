//
//  TableViewHeaderCell.swift
//  kannada
//
//  Created by PraveenH on 21/05/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit

protocol SeeMoreDelegate: class {
    func didTapOnSeeMoreBtn(_ section : Int)
}

class TableViewHeaderCell: UITableViewCell {
    
    @IBOutlet weak var ibHeaderTitle: UILabel!
    weak var delegate: SeeMoreDelegate?
    var section : Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func didTapOnSeeMoreBtn(_ sender: Any) {
        if let index = section {
            self.delegate?.didTapOnSeeMoreBtn(index)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
