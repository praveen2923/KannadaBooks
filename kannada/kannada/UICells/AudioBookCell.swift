//
//  AudioBookCell.swift
//  kannada
//
//  Created by PraveenH on 05/05/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit

protocol AudioBookCellDelegate: class {
    func didTapOnLikeBtn(_ cell : AudioBookCell)
    func didTapOnDownalodBtn(_ cell : AudioBookCell)
}

class AudioBookCell: UITableViewCell {

    @IBOutlet weak var intotslLikes: UILabel!
    @IBOutlet weak var ibLikeBtn: UIButton!
    @IBOutlet weak var ibBackgroundview: UIView!
    @IBOutlet weak var ibSubTitleLabel: UILabel!
    @IBOutlet weak var ibTitleLabel: UILabel!
    
    weak var delegate: AudioBookCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapOnLikeBtn(_ sender: Any) {
        self.delegate?.didTapOnLikeBtn(self)
    }
    
    
    @IBAction func didTapOnDownalodBtn(_ sender: Any) {
        self.delegate?.didTapOnDownalodBtn(self)
    }
    
    
}
