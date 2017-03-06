//
//  UserViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/3.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class UserViewController: UITableViewController {

    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var alertLabel: UILabel!
    var userInfo:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.avatarBtn.layer.cornerRadius = 43
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if UserModel.share.userId.characters.count > 0 {
            self.requestUserInfo()
        }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            self.navigationController?.pushViewController(SettingViewController.getInstance(), animated: true)
        }else if indexPath.row == 2 {
            self.navigationController?.pushViewController(AccountViewController.getInstance(), animated: true)
        }
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
        if UserModel.share.userId.characters.count > 0 {
            self.navigationController?.pushViewController(UserInfoViewController.getInstance(), animated: true)
        }else {
            self.navigationController?.pushViewController(LoginViewController.getInstance(), animated: true)
        }
    }
    
    func requestUserInfo() -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["user_id":UserModel.share.userId], url: "/User/index") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                let dict = dic as! NSDictionary
                let userDefault = UserDefaults.standard
                if !(((dict["user"] as! NSDictionary)["address"] as! NSObject).isKind(of: NSNull.self)) &&  ((dict["user"] as! NSDictionary)["address"] as! String).characters.count > 0{
                    userDefault.set(((dict["user"] as! NSDictionary)["address"] as! String), forKey: "ADDRESS")
                }
                if !(((dict["user"] as! NSDictionary)["birthday"] as! NSObject).isKind(of: NSNull.self)) &&  ((dict["user"] as! NSDictionary)["birthday"] as! String).characters.count > 0{
                    userDefault.set(((dict["user"] as! NSDictionary)["birthday"] as! String), forKey: "BIRTHDAY")
                }
                if !(((dict["user"] as! NSDictionary)["head_graphic"] as! NSObject).isKind(of: NSNull.self)) &&  ((dict["user"] as! NSDictionary)["head_graphic"] as! String).characters.count > 0{
                    userDefault.set(((dict["user"] as! NSDictionary)["head_graphic"] as! String), forKey: "AVATAR")
                }
                if !(((dict["user"] as! NSDictionary)["money"] as! NSObject).isKind(of: NSNull.self)) &&  ((dict["user"] as! NSDictionary)["money"] as! String).characters.count > 0{
                    userDefault.set(((dict["user"] as! NSDictionary)["money"] as! String), forKey: "MONEY")
                }
                if !(((dict["user"] as! NSDictionary)["password"] as! NSObject).isKind(of: NSNull.self)) &&  ((dict["user"] as! NSDictionary)["password"] as! String).characters.count > 0{
                    userDefault.set(((dict["user"] as! NSDictionary)["password"] as! String), forKey: "PASSWORD")
                }
                if !(((dict["user"] as! NSDictionary)["reg_time"] as! NSObject).isKind(of: NSNull.self)) &&  ((dict["user"] as! NSDictionary)["reg_time"] as! String).characters.count > 0{
                    userDefault.set(((dict["user"] as! NSDictionary)["reg_time"] as! String), forKey: "REGTIME")
                }
                if !(((dict["user"] as! NSDictionary)["status"] as! NSObject).isKind(of: NSNull.self)) &&  ((dict["user"] as! NSDictionary)["status"] as! String).characters.count > 0{
                    userDefault.set(((dict["user"] as! NSDictionary)["status"] as! String), forKey: "STATUS")
                }
                if !(((dict["user"] as! NSDictionary)["u_area"] as! NSObject).isKind(of: NSNull.self)) &&  ((dict["user"] as! NSDictionary)["u_area"] as! String).characters.count > 0{
                    userDefault.set(((dict["user"] as! NSDictionary)["u_area"] as! String), forKey: "UAREA")
                }
                if !(((dict["user"] as! NSDictionary)["u_city"] as! NSObject).isKind(of: NSNull.self)) &&  ((dict["user"] as! NSDictionary)["u_city"] as! String).characters.count > 0{
                    userDefault.set(((dict["user"] as! NSDictionary)["u_city"] as! String), forKey: "UCITY")
                }
                if !(((dict["user"] as! NSDictionary)["u_province"] as! NSObject).isKind(of: NSNull.self)) &&  ((dict["user"] as! NSDictionary)["u_province"] as! String).characters.count > 0{
                    userDefault.set(((dict["user"] as! NSDictionary)["u_province"] as! String), forKey: "UPROVINCE")
                }
                if !(((dict["user"] as! NSDictionary)["user_id"] as! NSObject).isKind(of: NSNull.self)) &&  ((dict["user"] as! NSDictionary)["user_id"] as! String).characters.count > 0{
                    userDefault.set(((dict["user"] as! NSDictionary)["user_id"] as! String), forKey: "USERID")
                }
                if !(((dict["user"] as! NSDictionary)["user_key"] as! NSObject).isKind(of: NSNull.self)) &&  ((dict["user"] as! NSDictionary)["user_key"] as! String).characters.count > 0{
                    userDefault.set(((dict["user"] as! NSDictionary)["user_key"] as! String), forKey: "USERKEY")
                }
                if !(((dict["user"] as! NSDictionary)["user_name"] as! NSObject).isKind(of: NSNull.self)) &&  ((dict["user"] as! NSDictionary)["user_name"] as! String).characters.count > 0{
                    userDefault.set(((dict["user"] as! NSDictionary)["user_name"] as! String), forKey: "USERNAME")
                }
                if !(((dict["user"] as! NSDictionary)["user_phone"] as! NSObject).isKind(of: NSNull.self)) &&  ((dict["user"] as! NSDictionary)["user_phone"] as! String).characters.count > 0{
                    userDefault.set(((dict["user"] as! NSDictionary)["user_phone"] as! String), forKey: "USERPHONE")
                }
                self.userInfo = dic as? NSDictionary
                self.avatarBtn.sd_setImage(with: URL(string: UserModel.share.avatar), for: .normal)
                self.alertLabel.text = UserModel.share.userName
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
}
