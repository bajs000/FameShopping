//
//  EditAddressViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/6.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

class EditAddressViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var areaView:UIView!
    @IBOutlet weak var pickerViewBottom:NSLayoutConstraint!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    @IBOutlet var tap: UITapGestureRecognizer!
    @IBOutlet weak var acceptView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var deleteBtn: UIButton!
    
    var titleDic = ["0":[["title":"收货人","detail":""],["title":"手机号","detail":""],["title":"收货时间","detail":""]],
                    "1":[["title":"地址类型","detail":" "],["title":"省份","detail":""],["title":"城市","detail":""],["title":"区/县","detail":""],["title":"详细地址","detail":""]]]
    var acceptTimeArr = ["收货时间不限","周一至周五收货","周六/周日/节假日收货"]
    
    var province:NSDictionary?
    var city:NSDictionary?
    var district:NSDictionary?
    
    var areaDataSource:NSArray?
    var currentIndexPath:IndexPath?
    var currentRow:Int = 0
    
    var editAddress:NSDictionary?{
        didSet{
            titleDic = ["0":[["title":"收货人","detail":editAddress?["uname"] as! String],["title":"手机号","detail":editAddress?["uphone"] as! String],["title":"收货时间","detail":editAddress?["time"] as! String]],
                        "1":[["title":"地址类型","detail":" "],["title":"省份","detail":editAddress?["province_name"] as! String],["title":"城市","detail":editAddress?["city_name"] as! String],["title":"区/县","detail":editAddress?["district_name"] as! String],["title":"详细地址","detail":editAddress?["address"] as! String]]]
            province = ["id":editAddress?["province"] as! String,"name":editAddress?["province_name"] as! String]
            city = ["id":editAddress?["city"] as! String,"name":editAddress?["city_name"] as! String]
            district = ["id":editAddress?["district"] as! String,"name":editAddress?["district_name"] as! String]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(rightBarItemDidClick(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.colorWithHexString(hex: "777777")
        if self.editAddress == nil {
            self.footerView.frame = CGRect(x: 0, y: 0, width: Helpers.screanSize().width, height: 1)
            self.deleteBtn.isHidden = true
        }
        self.tableView.tableFooterView = self.footerView
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
        // Dispose of any resources that can be recreated.
    }

    func keyboardShow(_ notification: Notification) -> Void {
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let keyboardRect:CGRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        UIView.animate(withDuration: duration) {
            self.tableViewBottom.constant = keyboardRect.size.height
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardHide(_ notification: Notification) -> Void {
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration) {
            self.tableViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.titleDic.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleDic[String(section)]!.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        (cell.viewWithTag(1) as! UILabel).text = titleDic[String(indexPath.section)]![indexPath.row]["title"]
        (cell.viewWithTag(2) as! UITextField).text = titleDic[String(indexPath.section)]![indexPath.row]["detail"]
        (cell.viewWithTag(2) as! UITextField).isEnabled = true
        (cell.viewWithTag(2) as! UITextField).keyboardType = .default
        (cell.viewWithTag(2) as! UITextField).addTarget(self, action: #selector(textFieldDidEidt(_:)), for: .editingChanged)
        if indexPath.section == 1 {
            if indexPath.row == 4 {
                (cell.viewWithTag(2) as! UITextField).isEnabled = true
            }else{
                (cell.viewWithTag(2) as! UITextField).isEnabled = false
            }
        }else {
            if indexPath.row == 1 {
                (cell.viewWithTag(2) as! UITextField).keyboardType = .numberPad
            }else if indexPath.row == 2 {
                (cell.viewWithTag(2) as! UITextField).isEnabled = false
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            UIApplication.shared.keyWindow?.endEditing(true)
            if indexPath.row == 2 && province == nil {
                SVProgressHUD.showError(withStatus: "请先选择省份")
                return
            }else if indexPath.row == 3  && city == nil {
                SVProgressHUD.showError(withStatus: "请先选择城市")
                return
            }
            
            if indexPath.row > 0 && indexPath.row < 4 {
                currentIndexPath = indexPath
                self.requestArea({ 
                    self.areaView.isHidden = false
                    UIView.animate(withDuration: 0.75) {
                        self.blackView.alpha = 0.5
                        self.pickerViewBottom.constant = 0
                        self.view.layoutIfNeeded()
                    }
                })
            }
            
        }else {
            if indexPath.row == 2 {
                UIApplication.shared.keyWindow?.endEditing(true)
                self.areaView.isHidden = false
                self.blackView.alpha = 0.5
                self.acceptView.isHidden = false
//                UIView.animate(withDuration: 0.75, animations: { 
//                    self.blackView.alpha = 0.5
//                })
                UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: ({
                    self.acceptView.transform = CGAffineTransform(scaleX: 0, y: 0)
                }), completion: {(_ finish:Bool) -> Void in
                    UIView.animate(withDuration: 0.23, delay: 0, options: .curveEaseInOut, animations: ({
                        self.acceptView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    }), completion: {(_ finish:Bool) -> Void in
                        UIView.animate(withDuration: 0.09, delay: 0.02, options: .curveEaseInOut, animations: ({
                            self.acceptView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                        }), completion: {(_ finish:Bool) -> Void in
                            UIView.animate(withDuration: 0.05, delay: 0.02, options: .curveEaseInOut, animations: ({
                                self.acceptView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                            }), completion: {(_ finish:Bool) -> Void in
                                
                            })
                        })
                    })
                })
            }
        }
        
    }
    
    // MARK: - UIPickerView delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.areaDataSource == nil {
            return 0
        }
        return (self.areaDataSource?.count)!
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (self.areaDataSource?[row] as! NSDictionary)["name"] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentRow = row
        if currentIndexPath?.row == 1 {
            province = (self.areaDataSource?[row] as! NSDictionary)
        }else if currentIndexPath?.row == 2 {
            city = (self.areaDataSource?[row] as! NSDictionary)
        }else if currentIndexPath?.row == 3 {
            district = (self.areaDataSource?[row] as! NSDictionary)
        }
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
    
    func rightBarItemDidClick(_ sender: UIBarButtonItem) -> Void {
        self.requestAddAddress()
    }
    
    func textFieldDidEidt(_ sender:UITextField) -> Void {
        let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender)
        let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
        var arr = titleDic[String((indexPath?.section)!)]
        var dic = arr?[(indexPath?.row)!]
        if  dic != nil {
            dic?["detail"] = sender.text
            arr?.remove(at: (indexPath?.row)!)
            arr?.insert(dic!, at: (indexPath?.row)!)
            titleDic[String((indexPath?.section)!)] = arr
        }
    }
    
    @IBAction func deleteBtnDidClick(_ sender: Any) {
        self.requestDeleteAddress()
    }
    
    @IBAction func pickerActionDidClick(_ sender: UIButton) {
        if sender.tag == 1 {
            
        }else{
            if province == nil && currentRow == 0 && currentIndexPath?.row == 1 {
                province = (self.areaDataSource?[currentRow] as! NSDictionary)
            }
            if city == nil && currentRow == 0 && currentIndexPath?.row == 2 {
                city = (self.areaDataSource?[currentRow] as! NSDictionary)
            }
            if district == nil && currentRow == 0 && currentIndexPath?.row == 3 {
                district = (self.areaDataSource?[currentRow] as! NSDictionary)
            }
            var arr = titleDic["1"]
            var dic = arr?[(currentIndexPath?.row)!]
            if  dic != nil {
                dic?["detail"] = (areaDataSource?[currentRow] as! NSDictionary)["name"] as? String
                arr?.remove(at: (currentIndexPath?.row)!)
                arr?.insert(dic!, at: (currentIndexPath?.row)!)
                titleDic["1"] = arr
                self.tableView.reloadData()
            }
            
            if currentIndexPath?.row == 1 {
                var arr = titleDic["1"]
                var dic = arr?[2]
                if  dic != nil {
                    dic?["detail"] = ""
                    arr?.remove(at: 2)
                    arr?.insert(dic!, at: 2)
                }
                var dic1 = arr?[3]
                if  dic1 != nil {
                    dic1?["detail"] = ""
                    arr?.remove(at: 3)
                    arr?.insert(dic1!, at: 3)
                }
                titleDic["1"] = arr
                self.tableView.reloadData()
            }else if currentIndexPath?.row == 2 {
                var arr = titleDic["1"]
                var dic = arr?[(currentIndexPath?.row)!]
                if  dic != nil {
                    dic?["detail"] = (areaDataSource?[currentRow] as! NSDictionary)["name"] as? String
                    arr?.remove(at: (currentIndexPath?.row)!)
                    arr?.insert(dic!, at: (currentIndexPath?.row)!)
                    titleDic["1"] = arr
                    self.tableView.reloadData()
                }
            }
            
            
        }
        self.areaViewDidTap(tap)
    }
    
    @IBAction func areaViewDidTap(_ sender: Any) {
        if self.pickerViewBottom.constant == 0 {
            UIView.animate(withDuration: 0.75, animations: {
                self.blackView.alpha = 0
                self.pickerViewBottom.constant = -256
                self.view.layoutIfNeeded()
            }) { (finish) in
                self.areaView.isHidden = true
            }
        }else {
            self.areaView.isHidden = true
        }
    }
    
    @IBAction func acceptBtnDidClick(_ sender: UIButton) {
        if sender.tag != 0 {
            var arr = titleDic["0"]
            var dic = arr?[2]
            if  dic != nil {
                dic?["detail"] = acceptTimeArr[sender.tag - 1]
                arr?.remove(at: (2))
                arr?.insert(dic!, at: 2)
                titleDic["0"] = arr
            }
        }
        self.areaView.isHidden = true
        self.acceptView.isHidden = true
        self.blackView.alpha = 0
        self.tableView.reloadData()
        self.areaViewDidTap(tap)
    }
    
    func requestArea(_ complete:(() -> Void)?) -> Void {
        SVProgressHUD.show()
        var param = [String:String]()
        if city != nil && province != nil && currentIndexPath?.row == 3 {
            param = ["city":city?["id"] as! String]
        }else if province != nil && currentIndexPath?.row == 2 {
            param = ["province":province?["id"] as! String]
        }else{
            
        }
        NetworkModel.request(param as NSDictionary, url: "/Public/addre") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                self.areaDataSource = (dic as! NSDictionary)["list"] as? NSArray
                if self.areaDataSource != nil {
                    if (self.areaDataSource?.count)! <= self.currentRow {
                        self.currentRow = (self.areaDataSource?.count)! - 1
                    }
                }
                self.pickerView.reloadAllComponents()
                complete!()
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
    func requestAddAddress() -> Void {
        for dict in titleDic["0"]! {
            if (dict["detail"]?.characters.count)! == 0 {
                SVProgressHUD.showError(withStatus: "请输入" + dict["title"]!)
                return
            }
        }
        for dict in titleDic["1"]! {
            if (dict["detail"]?.characters.count)! == 0 {
                SVProgressHUD.showError(withStatus: "请输入" + dict["title"]!)
                return
            }
        }
        var param = [String:String]()
        param = ["user_id":UserModel.share.userId,
                 "ac":"add",
                 "uname":(titleDic["0"]?[0]["detail"])!,
                 "uphone":(titleDic["0"]?[1]["detail"])!,
                 "time":(titleDic["0"]?[2]["detail"])!,
                 "province":(province?["id"] as! String),
                 "city":(city?["id"] as! String),
                 "district":(district?["id"] as! String),
                 "address":(titleDic["1"]?[4]["detail"])!]
        if self.editAddress != nil {
            param["ac"] = "save"
            param["add_id"] = self.editAddress?["add_id"] as? String
        }
        SVProgressHUD.show()
        NetworkModel.request(param as NSDictionary, url: "/User/address_edadd") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
    func requestDeleteAddress() -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["add_id":self.editAddress?["add_id"] as! String], url: "/User/address_del") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }

}
