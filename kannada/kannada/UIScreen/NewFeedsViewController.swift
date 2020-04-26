//
//  NewFeedsViewController.swift
//  kannada
//
//  Created by PraveenH on 26/04/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit

class NewFeedsViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
    }
}


extension NewFeedsViewController : UITableViewDelegate, UITableViewDataSource {

    func configureTableView()  {
        self.tableview?.delegate = self
        self.tableview?.dataSource = self
        let nib = UINib(nibName: "FeedNewsCell", bundle: nil)
        self.tableview.register(nib, forCellReuseIdentifier: "FeedNewsCell")

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      return getMenuCell(indexPath: indexPath)
    }

    func getMenuCell(indexPath: IndexPath) -> FeedNewsCell {
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "FeedNewsCell", for: indexPath) as! FeedNewsCell
        cell.selectionStyle = .none
        return cell
    }
 

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 170
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
    }
}
