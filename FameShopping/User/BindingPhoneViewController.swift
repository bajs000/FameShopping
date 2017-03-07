//
//  BindingPhoneViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/7.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit

class BindingPhoneViewController: UIViewController {

    @IBOutlet weak var phoneLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "绑定手机"
        self.phoneLabel.text = (UserModel.share.userPhone as NSString).replacingCharacters(in: NSMakeRange(3, 4), with: "****")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func updatePhoneBtnDidClick(_ sender: Any) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
