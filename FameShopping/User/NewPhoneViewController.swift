//
//  NewPhoneViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/7.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

class NewPhoneViewController: UIViewController {

    @IBOutlet weak var phoneNum: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "更换手机号"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! UpdatePhoneViewController
        vc.phoneNum = self.phoneNum.text!
    }
    
    @IBAction func nextBtnDidClick(_ sender: Any) {
        if self.phoneNum.text?.characters.count != 11 {
            SVProgressHUD.showError(withStatus: "请正确输入手机号")
            return
        }
        self.performSegue(withIdentifier: "updatePush", sender: nil)
    }

}
