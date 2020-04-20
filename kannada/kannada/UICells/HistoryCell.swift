//
//  HistoryCell.swift
//  kannada
//
//  Created by PraveenH on 18/04/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit

protocol CellDelegate: class {
    func didTapOnmoredetails(_ cell : HistoryCell)
}

class HistoryCell: UITableViewCell {

    @IBOutlet weak var ibDetailsLbl: UILabel!
    @IBOutlet weak var ibTitleLbl: UILabel!
    
    weak var delegate: CellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func didTapOnReadMore(_ sender: Any) {
        self.delegate?.didTapOnmoredetails(self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
