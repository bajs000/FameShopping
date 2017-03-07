//
//  UpdatePwdViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/7.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

class UpdatePwdViewController: UITableViewController {

    @IBOutlet weak var accountNum:UITextField!
    @IBOutlet weak var oldPwd:UITextField!
    @IBOutlet weak var newPwd:UITextField!
    @IBOutlet weak var surePwd:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改登录密码"
        self.accountNum.text = (UserModel.share.userPhone as NSString).replacingCharacters(in: NSMakeRange(3, 4), with: "****")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func commitBtnDidClick(_ sender: UIButton) -> Void {
        if (self.oldPwd.text?.characters.count)! < 6 {
            SVProgressHUD.showError(withStatus: "请输入6位以上当前登录密码")
            return
        }
        if (self.newPwd.text?.characters.count)! < 6 {
            SVProgressHUD.showError(withStatus: "请输入6位以上新密码")
            return
        }
        if self.newPwd.text != self.surePwd.text {
            SVProgressHUD.showError(withStatus: "两次密码不一致")
            return
        }
        self.requestUpdatePwd()
    }
    
    func requestUpdatePwd() -> Void {
        SVProgressHUD.show()
        NetworkModel.request([:], url: "") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.showSuccess(withStatus: "修改成功")
                _ = self.navigationController?.popToRootViewController(animated: true)
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
}
