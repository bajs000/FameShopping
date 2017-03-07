//
//  UpdatePhoneViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/7.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

class UpdatePhoneViewController: UIViewController {

    @IBOutlet weak var verifyCode: UITextField!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var reGetVerifyBtn: UIButton!
    @IBOutlet weak var commitBtn: UIButton!
    
    var phoneNum:String = ""
    var verifyCodeStr:String?
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.phoneLabel.text = "请输入" + (phoneNum as NSString).replacingCharacters(in: NSMakeRange(3, 4), with: "****") + "收到的短信验证码"
        self.requestVerifyCode()
        self.title = "填写验证码"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func reGetVerifyBtnDidClick(_ sender: Any) {
        self.requestVerifyCode()
    }

    @IBAction func commitUpdatePhoneBtnDidClick(_ sender: UIButton) {
        if self.verifyCodeStr == verifyCode.text {
            self.requestUpdatePhone()
        }else {
            SVProgressHUD.showError(withStatus: "验证码错误")
        }
    }
    
    @IBAction func textFieldEditDidChange(_ sender: UITextField) {
        if (sender.text?.characters.count)! > 6 {
            sender.text = sender.text?.substring(to: (sender.text?.index((sender.text?.endIndex)!, offsetBy: -1))!)
        }
        
        if (sender.text?.characters.count)! < 6 {
            self.commitBtn.backgroundColor = UIColor.colorWithHexString(hex: "c9c9c9")
        }else {
            self.commitBtn.backgroundColor = UIColor.colorWithHexString(hex: "e14575")
        }
        
    }
    
    func startCount() -> Void {
        count = 60
        reGetVerifyBtn?.isUserInteractionEnabled = false
        reGetVerifyBtn?.setTitle(String(count) + "秒后再试", for: .normal)
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown(_:)), userInfo: nil, repeats: true)
    }
    
    func countDown(_ time:Timer) -> Void {
        count = count - 1
        if count <= 0 {
            time.invalidate()
            reGetVerifyBtn?.setTitle("重新获取", for: .normal)
            reGetVerifyBtn?.isUserInteractionEnabled = true
            return
        }
        reGetVerifyBtn?.setTitle(String(count) + "秒后再试", for: .normal)
    }
    
    func requestVerifyCode() -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["user_phone":self.phoneNum,"type":"zhuce"], url: "/Public/ajaxmobile") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                print(dic)
                self.verifyCodeStr = (dic as! NSDictionary)["verify"] as? String
                self.startCount()
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
    func requestUpdatePhone() -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["user_phone":self.phoneNum,"user_id":UserModel.share.userId], url: "/User/phone_edit") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                UserModel.share.resetUserPhone()
                _ = self.navigationController?.popToRootViewController(animated: true)
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
}
