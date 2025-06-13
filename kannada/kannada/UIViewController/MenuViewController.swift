//
//  MenuViewController.swift
//  kannada
//
//  Created by PraveenH on 25/04/20.
//  Copyright © 2020 books. All rights reserved.
//

import UIKit

protocol MenuToDashboard {
    func tapOnIndex(index : Int)
    func tapOnValue(value : String)
    func navigateToVC(vc : UIViewController)
}


class MenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var delegate : MenuToDashboard?
    var menuIteams :MenuBase?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.getMenuList()
    }
    
    func getMenuList()  {
        self.showeLoading()
        APIManager.getMenuList(nil, completion: { (error, result) in
               self.hideLoading()
               if let menu = result as? NSDictionary {
                self.menuIteams = MenuBase(dictionary: menu)
                
                self.tableView.reloadData()
               }else{
                   self.showeErorMsg("ದಯವಿಟ್ಟು ಪುನಃ ಪ್ರಯತ್ನಿಸಿ")
               }
           })
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
        if let count = self.menuIteams?.menulist?.count {
            return count + 1
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      return getMenuCell(indexPath: indexPath)
    }

    func getMenuCell(indexPath: IndexPath) -> CommonCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CommonCell", for: indexPath) as! CommonCell
        if let count = self.menuIteams?.menulist?.count {
            if count <= indexPath.row {
                cell.ibMenuLbl.text = "ನಮ್ಮ ಬಗ್ಗೆ"
            }else{
                if let value = self.self.menuIteams?.menulist?[indexPath.row] {
                    cell.ibMenuLbl.text = value.name
                }
            }
        }
        
        cell.selectionStyle = .none
        return cell
                  
    }
 

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 45
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        self.sideMenuController?.hideMenu()
        if let count = self.menuIteams?.menulist?.count {
            if count <= indexPath.row {
                let controller = storyBoard.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                self.delegate?.navigateToVC(vc: controller)
            }else{
                let controller = storyBoard.instantiateViewController(withIdentifier: "NewFeedsViewController") as! NewFeedsViewController
                controller.menuIteam = self.menuIteams?.menulist?[indexPath.row]
                self.delegate?.navigateToVC(vc: controller)
            }
        }
    }
}
