//
//  UserViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/3.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit

class UserViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = ""
        if indexPath.row == 0 {
            cellIdentify = "functionCell"
        }else if indexPath.row == 1 {
            cellIdentify = "settingCell"
        }else {
            cellIdentify = "normalCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        if indexPath.row > 0 {
            (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "user-icon-" + String(indexPath.row))
            if indexPath.row == 1 {
                (cell.viewWithTag(2) as! UILabel).text = "设置"
            }else if indexPath.row == 2 {
                (cell.viewWithTag(2) as! UILabel).text = "账户管理"
            }else {
                (cell.viewWithTag(2) as! UILabel).text = "关于我们"
            }
        }
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func avatarBtnDidClick(_ sender: Any) {
        self.navigationController?.pushViewController(LoginViewController.getInstance(), animated: true)
    }
    
}
