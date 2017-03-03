//
//  LoginViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/3.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var logoTop: NSLayoutConstraint!
    @IBOutlet weak var phoneNum: PhoneTextField!
    @IBOutlet weak var password: PhoneTextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.password.rightBtn?.addTarget(self, action: #selector(showOrHidePwd(_:)), for: .touchUpInside)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public class func getInstance() -> LoginViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "login")
        return vc as! LoginViewController
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
    
    @IBAction func loginBtnDidClick(_ sender: Any) {
        if (self.phoneNum.text?.characters.count)! != 11 {
            SVProgressHUD.showError(withStatus: "请正确输入手机号")
            return
        }
        if (self.password.text?.characters.count)! < 6 {
            SVProgressHUD.showError(withStatus: "请输入6位以上密码")
            return
        }
        self.requestLogin()
    }
    
    func requestLogin() -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["user_phone":self.phoneNum.text!,"password":self.password.text!], url: "/Login/index") { (dic) in
            if ((dic as! NSDictionary)["code"] as! NSNumber).intValue == 200 {
                SVProgressHUD.dismiss()
                print(dic)
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
}
