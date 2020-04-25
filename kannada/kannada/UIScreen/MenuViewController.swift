//
//  MenuViewController.swift
//  kannada
//
//  Created by PraveenH on 25/04/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let menuList = ["ಸುದ್ದಿ-ಸಮಾಚಾರ", "ಪ್ರಸಿದ್ದ ವ್ಯಕ್ತಿಗಳು", "ಸಾಹಿತಿಗಳು","ರಂಗಭೂಮಿ","ಹಳಗನ್ನಡ ಕವಿಗಳು", "ಕಲಾವಿದರು" , "ರಾಷ್ಟ್ರಪುರುಷರ ಕಥೆಗಳು", "ಸ್ವಾತಂತ್ರ್ಯ ಹೋರಾಟಗಾರರು","ನಮ್ಮ ಬಗ್ಗೆ"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        // Do any additional setup after loading the view.
    }
}

extension MenuViewController : UITableViewDelegate, UITableViewDataSource {

    func configureTableView()  {
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        let nib = UINib(nibName: "CommonCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "CommonCell")

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      return getMenuCell(indexPath: indexPath)
    }

    func getMenuCell(indexPath: IndexPath) -> CommonCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CommonCell", for: indexPath) as! CommonCell
        cell.ibMenuLbl.text = self.menuList[indexPath.row]
        return cell
                  
    }
 

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 45
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
    }
}
