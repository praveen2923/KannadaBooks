//
//  FeedModelViewController.swift
//  kannada
//
//  Created by PraveenH on 27/04/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit

class FeedModelViewController: UIViewController {

    @IBOutlet weak var ibtextView: UITextView!
    var deatils : NewsFeed?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ibtextView.text = self.deatils?.note
        // Do any additional setup after loading the view.
    }

}
