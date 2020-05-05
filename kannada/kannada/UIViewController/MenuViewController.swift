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
    var meanulist = [[String:String]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.getMenuList()
        // Do any additional setup after loading the view.
    }
    
    func getMenuList()  {
        self.showeLoading()
        APIManager.getMenuList(nil, completion: { (error, result) in
               self.hideLoading()
               if let list = result as? NSArray {
                if list.count > 0 {
                    self.meanulist = list as! [[String : String]]
                    self.tableView.reloadData()
                }
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
        return self.meanulist.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      return getMenuCell(indexPath: indexPath)
    }

    func getMenuCell(indexPath: IndexPath) -> CommonCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "CommonCell", for: indexPath) as! CommonCell
        let value = self.meanulist[indexPath.row] as NSDictionary
        cell.ibMenuLbl.text = value.object(forKey: "name") as? String
        cell.selectionStyle = .none
        return cell
                  
    }
 

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 45
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.sideMenuController?.hideMenu()
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyBoard.instantiateViewController(withIdentifier: "NewFeedsViewController") as! NewFeedsViewController
        let value = self.meanulist[indexPath.row] as NSDictionary
        controller.menuId = value.object(forKey: "id") as? String
        controller.navtitle = value.object(forKey: "name") as? String
        self.delegate?.navigateToVC(vc: controller)
    }
}
