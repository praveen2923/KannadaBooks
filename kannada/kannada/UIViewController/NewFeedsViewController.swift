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
    var menuIteam:Menulist?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.title = menuIteam?.name
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
        return self.menuIteam?.manuIteams?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      return getMenuCell(indexPath: indexPath)
    }

    func getMenuCell(indexPath: IndexPath) -> FeedNewsCell {
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "FeedNewsCell", for: indexPath) as! FeedNewsCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.ibFeedLbl.text = self.menuIteam?.manuIteams?[indexPath.row].note
        cell.ibFeedTitleLbl.text = self.menuIteam?.manuIteams?[indexPath.row].shortnote
        cell.ibFeedImage.image = UIImage(named: "kannada")
        if let authorimage =  self.menuIteam?.manuIteams?[indexPath.row].image {
            if authorimage != "" {
                let fullurl = APIList.BOOKBaseUrl + authorimage
                 cell.ibFeedImage?.sd_setImage(with: URL(string: fullurl), placeholderImage: UIImage(named: "noimage"))
            }
        }
        return cell
    }
 

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 180
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
    }
}

extension NewFeedsViewController : FeedDelegate {
    func didTapOnReadMoreBtn(_ cell: FeedNewsCell) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyBoard.instantiateViewController(withIdentifier: "FeedModelViewController") as! FeedModelViewController
        let indexPath = self.tableview.indexPath(for: cell)
        controller.feedNote = self.menuIteam?.manuIteams?[indexPath?.row ?? 0]
        self.present(controller, animated: true, completion: nil)
    }
}
