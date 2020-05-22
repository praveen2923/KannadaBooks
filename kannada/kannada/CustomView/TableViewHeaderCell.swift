//
//  TableViewHeaderCell.swift
//  kannada
//
//  Created by PraveenH on 21/05/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit

class TableViewHeaderCell: UITableViewCell {
    @IBOutlet weak var ibHeaderTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
