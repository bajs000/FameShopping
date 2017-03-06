//
//  UserInfoViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/6.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class UserInfoViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var showPicker = false
    var datePicker:UIDatePicker?
    var dateStr:String?
    var avatarIcon:UIImage?
    var nickname:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(rightBarItemDidClick(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.colorWithHexString(hex: "777777")
        self.title = "个人资料"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    public class func getInstance() -> UserInfoViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "userInfo")
        return vc as! UserInfoViewController
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 75
        }else if indexPath.row == 1 {
            return 55
        }else {
            if showPicker {
                return 252
            }else{
                return 55
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = ""
        if indexPath.row == 0 {
            cellIdentify = "avatarCell"
        }else if indexPath.row == 1 {
            cellIdentify = "nicknameCell"
        }else {
            cellIdentify = "birthdayCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        if indexPath.row == 0 {
            (cell.viewWithTag(1) as! UIImageView).layer.cornerRadius = 30
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: UserModel.share.avatar))
            if avatarIcon != nil {
                (cell.viewWithTag(1) as! UIImageView).image = avatarIcon
            }
        }else if indexPath.row == 1{
            (cell.viewWithTag(1) as! UILabel).text = UserModel.share.userName
            if self.nickname != nil {
                (cell.viewWithTag(1) as! UILabel).text = self.nickname
            }
        }else {
            (cell.viewWithTag(1) as! UILabel).text = UserModel.share.birthday
            self.datePicker = cell.viewWithTag(2) as? UIDatePicker
            self.datePicker?.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
            self.datePicker?.maximumDate = Date()
            if dateStr != nil {
                (cell.viewWithTag(1) as! UILabel).text = dateStr
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            showPicker = !showPicker
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }else if indexPath.row == 0 {
            let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let imgPicker = UIImagePickerController()
            let photoAction = UIAlertAction(title: "相册", style: .default, handler: { (action) in
                imgPicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                imgPicker.delegate = self
                self.present(imgPicker, animated: true, completion: nil)
            })
            let cameraAction = UIAlertAction(title: "相机", style: .default, handler: { (action) in
                imgPicker.sourceType = UIImagePickerControllerSourceType.camera
                imgPicker.delegate = self
                self.present(imgPicker, animated: true, completion: nil)
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                
            })
            sheet.addAction(photoAction)
            sheet.addAction(cameraAction)
            sheet.addAction(cancelAction)
            self.present(sheet, animated: true, completion: nil)
        }else {
            let alert = UIAlertController(title: "设置昵称", message: nil, preferredStyle: .alert)
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "请输入昵称"
            })
            alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (action) in
                if (alert.textFields?[0].text?.characters.count)! > 0 {
                    self.nickname = alert.textFields?[0].text
                    self.tableView.reloadData()
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - UIImagePickerController delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avatarIcon = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func datePickerValueDidChange(_ picker: UIDatePicker) -> Void {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        dateStr = format.string(from: picker.date)
        self.tableView.reloadData()
    }

    
    func rightBarItemDidClick(_ sender: UIBarButtonItem) -> Void {
        if nickname != nil || avatarIcon != nil || dateStr != nil{
            self.requestSaveInfo()
        }else{
            SVProgressHUD.showError(withStatus: "没有进行修改")
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func requestSaveInfo() -> Void {
        SVProgressHUD.show()
        var param = ["user_name":UserModel.share.userName,"birthday":UserModel.share.birthday,"user_id":UserModel.share.userId]
        if nickname != nil {
            param["user_name"] = nickname!
        }
        if dateStr != nil {
            param["birthday"] = dateStr!
        }
        if avatarIcon != nil {
            UploadNetwork.request(param, data: avatarIcon!, paramName: "img", url: "/User/useredit") { (dic) in
                print(dic)
                if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                    SVProgressHUD.dismiss()
                    UserModel.share.resetAvatar()
                    _ = self.navigationController?.popViewController(animated: true)
                }else{
                    SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
                }
            }
        }else {
            NetworkModel.request(param as NSDictionary, url: "/User/useredit", complete: { (dic) in
                if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                    SVProgressHUD.dismiss()
                    UserModel.share.resetAvatar()
                    _ = self.navigationController?.popViewController(animated: true)
                }else{
                    SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
                }
            })
        }
    }
    
}
