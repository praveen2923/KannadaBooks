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
    var feedNote : ManuIteams?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = feedNote?.shortnote
        self.ibtextView.text = feedNote?.note
    }

}
