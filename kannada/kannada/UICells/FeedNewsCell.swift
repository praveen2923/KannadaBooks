//
//  FeedNewsCell.swift
//  kannada
//
//  Created by PraveenH on 26/04/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit

protocol FeedDelegate: class {
    func didTapOnReadMoreBtn(_ cell : FeedNewsCell)
}

class FeedNewsCell: UITableViewCell {

    @IBOutlet weak var ibFeedTitleLbl: UILabel!
    @IBOutlet weak var ibFeedImage: UIImageView!
    @IBOutlet weak var ibFeedLbl: UILabel!
    
    weak var delegate: FeedDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func didTapOnReadMoreBtn(_ sender: Any) {
        self.delegate?.didTapOnReadMoreBtn(self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
