//
//  RegistViewController.swift
//  FameShopping
//
//  Created by 果儿 on 17/3/5.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

class RegistViewController: UIViewController {

    @IBOutlet weak var logoTop: NSLayoutConstraint!
    @IBOutlet weak var phoneNum: PhoneTextField!
    @IBOutlet weak var verifyText: CodeTextField!
    @IBOutlet weak var password: PhoneTextField!
    
    var verifyCode:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.verifyText.sendCodeBtn?.addTarget(self, action: #selector(verifyBtnDidClick(_:)), for: .touchUpInside)
        self.password.rightBtn?.addTarget(self, action: #selector(showOrHidePwd(_:)), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    public class func getInstance() -> RegistViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "regist")
        return vc as! RegistViewController
    }
    
    func keyboardShow(_ notification: Notification) -> Void {
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.logoTop.constant = 50
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardHide(_ notification: Notification) -> Void {
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.logoTop.constant = 100
            self.view.layoutIfNeeded()
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
    
    @IBAction func tapToHideKeyboard(_ sender: Any) {
        UIApplication.shared.keyWindow?.endEditing(true)
        //        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func showOrHidePwd(_ sender: UIButton) -> Void {
        sender.isSelected = !sender.isSelected
        self.password.isSecureTextEntry = !self.password.isSecureTextEntry
    }

    func verifyBtnDidClick(_ sender: UIButton) -> Void {
        if self.phoneNum.text?.characters.count != 11 {
            SVProgressHUD.showError(withStatus: "请正确输入手机号")
            return
        }
        self.requestVerify()
    }
    
    @IBAction func registBtnDidClick(_ sender: Any) {
        if self.phoneNum.text?.characters.count != 11 {
            SVProgressHUD.showError(withStatus: "请正确输入手机号")
            return
        }
        if (self.password.text?.characters.count)! < 6 {
            SVProgressHUD.showError(withStatus: "请正确输入密码")
            return
        }
        if self.verifyCode.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请先发送验证码")
            return
        }
        if self.verifyText.text != self.verifyCode {
            SVProgressHUD.showError(withStatus: "请正确输入验证码")
            return
        }
        self.requestRegist()
    }
    
    func requestVerify() -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["user_phone":self.phoneNum.text!,"type":"zhuce"], url: "/Public/ajaxmobile") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                print(dic)
                self.verifyCode = (dic as! NSDictionary)["verify"] as! String
                self.verifyText.startCount()
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
    func requestRegist() -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["user_phone":self.phoneNum.text!,"password":self.password.text!], url: "/Register/index") { (dic) in
            if ((dic as! NSDictionary)["code"] as! NSNumber).intValue == 200 {
                SVProgressHUD.dismiss()
                print(dic)
                // TODO: - add regist success
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
}
