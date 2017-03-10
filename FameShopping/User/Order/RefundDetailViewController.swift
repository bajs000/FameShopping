//
//  RefundDetailViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/10.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

enum RefundType:Int {
    case apply          = 1
    case check          = 2
    case pass           = 3
    case finish         = 4
}

class RefundDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var section1Header: UIView!
    @IBOutlet var section2Header: UIView!
    @IBOutlet var section3Header: UIView!
    @IBOutlet var section4Header: UIView!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var applyFooterView: UIView!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    
    var refundDic:NSDictionary?
    var placeHolder:UILabel?
    var titleTextView:UITextView?
    var detailTextView:UITextView?
    var userName:UITextField?
    var userPhone:UITextField?
    var collectionView:UICollectionView?
    var successRefund: (() -> Void)?
    var refundDetail: NSArray?
    var type:RefundType = .check
    var imgArr = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.title = "退款"
        if type == .check {
            self.requestRefundDetail()
            self.tableView.tableFooterView = nil
            self.bottomViewHeight.constant = 40
        }else {
            self.tableView.tableFooterView = self.applyFooterView
            self.bottomViewHeight.constant = 0
        }
        
        print(self.refundDic!)
        var point = self.headerView.viewWithTag(1)
        for i in 1...type.rawValue {
            point = self.headerView.viewWithTag(i)
            point?.layer.borderWidth = 0
            point?.layer.cornerRadius = 5
            point?.clipsToBounds = true
            point?.backgroundColor = #colorLiteral(red: 0.9144125581, green: 0.3713477254, blue: 0.5323973894, alpha: 1)
            let line = self.headerView.viewWithTag(i + 9)
            if line != nil {
                line?.backgroundColor = #colorLiteral(red: 0.9144125581, green: 0.3713477254, blue: 0.5323973894, alpha: 1)
            }
        }
        
        for i in (type.rawValue + 1)...4 {
            point = self.headerView.viewWithTag(i)
            point?.layer.borderWidth = 1
            point?.layer.borderColor = UIColor.colorWithHexString(hex: "AAAAAA").cgColor
            point?.backgroundColor = UIColor.clear
            point?.layer.cornerRadius = 5
            point?.clipsToBounds = true
        }
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
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if self.refundDic != nil {
                if type == .apply {
                    if self.refundDic?["order_goods"] != nil && (self.refundDic?["order_goods"] as! NSObject).isKind(of: NSArray.self) {
                        return (self.refundDic?["order_goods"] as! NSArray).count
                    }
                }else if type == .check {
                    if self.refundDic?["og"] != nil && (self.refundDic?["og"] as! NSObject).isKind(of: NSArray.self) {
                        return (self.refundDic?["og"] as! NSArray).count
                    }
                }
            }
            return 0
        }else if section == 1 {
            return 0
        }else {
            if type == .apply {
                return 4
            }else {
                if self.refundDetail != nil {
                    return (self.refundDetail?.count)!
                }
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 35
        }else if section == 1 {
            return 35
        }else {
            if type == .apply {
                return 10
            }else {
                return 61
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            (self.section1Header.viewWithTag(1) as! UILabel).text = "交易编号：" + (refundDic?["deal_no"] as! String)
            return self.section1Header
        }else if section == 1 {
            if type == .apply {
                (self.section2Header.viewWithTag(1) as! UILabel).text = "￥：" + (refundDic?["total_price"] as! String)
            }else if type == .check {
                (self.section2Header.viewWithTag(1) as! UILabel).text = "￥：" + ((refundDic?["order"] as! NSDictionary)["total_price"] as! String)
            }
            return self.section2Header
        }else {
            if type == .apply{
                return self.section3Header
            }else {
                return self.section4Header
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = ""
        if indexPath.section == 0 {
            cellIdentify = "orderCell"
        }else if indexPath.section == 2{
            if type == .apply {
                if indexPath.row == 0 {
                    cellIdentify = "titleCell"
                }else if indexPath.row == 1 {
                    cellIdentify = "detailCell"
                }else if indexPath.row == 2 {
                    cellIdentify = "imgCell"
                }else if indexPath.row == 3 {
                    cellIdentify = "userCell"
                }
            }else {
                cellIdentify = "refundInfoCell"
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        if indexPath.section == 0 {
            var dic:NSDictionary = [:]
            if type == .apply {
                dic = (self.refundDic!["order_goods"] as! NSArray)[indexPath.row] as! NSDictionary
            }else if type == .check {
                dic = (self.refundDic!["og"] as! NSArray)[indexPath.row] as! NSDictionary
            }
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["graphic"] as! String))!)
            (cell.viewWithTag(2) as! UILabel).text = dic["goods_name"] as? String
            (cell.viewWithTag(3) as! UILabel).text = "￥" + (dic["price_num"] as! String)
            (cell.viewWithTag(4) as! UILabel).text = "尺码：" + (dic["goods_size"] as! String)
            (cell.viewWithTag(5) as! UILabel).text = "x" + (dic["num"] as! String)
        }else if indexPath.section == 2{
            if type == .apply {
                if indexPath.row == 0 {
                    (cell.viewWithTag(1) as! UITextView).delegate  = self
                    titleTextView = (cell.viewWithTag(1) as! UITextView)
                }else if indexPath.row == 1 {
                    detailTextView = (cell.viewWithTag(1) as! UITextView)
                    detailTextView?.delegate = self
                    placeHolder = cell.viewWithTag(2) as? UILabel
                }else if indexPath.row == 2 {
                    collectionView = (cell.viewWithTag(1) as! UICollectionView)
                    collectionView?.delegate = self
                    collectionView?.dataSource = self
                }else if indexPath.row == 3 {
                    (cell.viewWithTag(1) as! UITextField).text = refundDic?["receipt_uname"] as? String
                    (cell.viewWithTag(2) as! UITextField).text = refundDic?["receipt_uphone"] as? String
                    userName = (cell.viewWithTag(1) as! UITextField)
                    userPhone = (cell.viewWithTag(2) as! UITextField)
                }
            }else {
                let dic = self.refundDetail?[indexPath.row] as! NSDictionary
                if indexPath.row == 0 {
                    cell.viewWithTag(1)?.isHidden = true
                    cell.viewWithTag(2)?.layer.cornerRadius = 5
                    cell.viewWithTag(2)?.backgroundColor = #colorLiteral(red: 0.9144125581, green: 0.3713477254, blue: 0.5323973894, alpha: 1)
                    cell.viewWithTag(3)?.backgroundColor = #colorLiteral(red: 0.9144125581, green: 0.3713477254, blue: 0.5323973894, alpha: 1)
                    (cell.viewWithTag(4) as! UILabel).textColor = #colorLiteral(red: 0.9144125581, green: 0.3713477254, blue: 0.5323973894, alpha: 1)
                    (cell.viewWithTag(5) as! UILabel).textColor = #colorLiteral(red: 0.9144125581, green: 0.3713477254, blue: 0.5323973894, alpha: 1)
                    (cell.viewWithTag(4) as! UILabel).text = dic["time"] as? String
                    (cell.viewWithTag(5) as! UILabel).text = dic["message"] as? String
                }else {
                    cell.viewWithTag(1)?.isHidden = false
                    cell.viewWithTag(2)?.layer.cornerRadius = 5
                    cell.viewWithTag(2)?.backgroundColor = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
                    cell.viewWithTag(3)?.backgroundColor = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
                    (cell.viewWithTag(4) as! UILabel).textColor = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
                    (cell.viewWithTag(5) as! UILabel).textColor = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
                    (cell.viewWithTag(4) as! UILabel).text = dic["time"] as? String
                    (cell.viewWithTag(5) as! UILabel).text = dic["message"] as? String
                }
            }
        }
        return cell
    }
    // MARK: - UICollectionView delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        if indexPath.row == imgArr.count {
            (cell.viewWithTag(1) as! UIImageView).image = #imageLiteral(resourceName: "order-camera")
        }else {
            (cell.viewWithTag(1) as! UIImageView).image = imgArr[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        sheet.addAction(UIAlertAction(title: "相机", style: .default, handler: { (action) in
            imgPicker.sourceType = .camera
            imgPicker.allowsEditing = true
            self.present(imgPicker, animated: true, completion: nil)
        }))
        sheet.addAction(UIAlertAction(title: "相册", style: .default, handler: { (action) in
            imgPicker.sourceType = .savedPhotosAlbum
            imgPicker.allowsEditing = true
            self.present(imgPicker, animated: true, completion: nil)
        }))
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            
        }))
        self.present(sheet, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerView delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imgArr.append(info[UIImagePickerControllerEditedImage] as! UIImage)
        self.dismiss(animated: true, completion: nil)
        self.collectionView?.reloadData()
        let width = Helpers.screanSize().width - 24
        let column:Int = Int(width) / 50
        let last = imgArr.count % column
        var count = imgArr.count / column
        if last > 0 {
            count = count + 1
        }
        count = max(count, 1)
        if count > 1 {
            self.tableView.beginUpdates()
            for constrain in (self.collectionView?.constraints)! {
                if constrain.identifier == "collectionHeight" {
                    constrain.constant = CGFloat(count * 40) + CGFloat(10 * (count - 1))
                    break
                }
            }
            self.tableView.endUpdates()
        }
    }
    
    // MARK: - UITextView delegate
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count > 0  && textView == detailTextView {
            placeHolder?.isHidden = true
        }else{
            placeHolder?.isHidden = false
        }
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
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
    
    @IBAction func deleteBtnDidClick(_ sender: Any) {
        self.requestDeleteOrder()
    }
    
    @IBAction func reBuyBtnDidClick(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func commitBtnDidClick(_ sender: Any) {
        if self.titleTextView?.text.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入原因")
            return
        }
        if self.detailTextView?.text.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入详细说明")
            return
        }
        if self.userName?.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入联系人")
            return
        }
        if (self.userPhone?.text?.characters.count)! == 0 {
            SVProgressHUD.showError(withStatus: "请输入联系电话")
            return
        }
        
        SVProgressHUD.show()
        let param = ["deal_no":refundDic?["deal_no"] as? String,
                     "refund_cause":titleTextView?.text,
                     "refund_message":detailTextView?.text,
                     "refund_uname":userName?.text,
                     "refund_uphone":userPhone?.text]
        if imgArr.count > 0 {
            UploadNetwork.request(param as! [String : String], datas: imgArr, paramName: "img[]", url: "/Order/application_refund_add", complete: { (dic) in
                if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                    SVProgressHUD.showSuccess(withStatus: "申请成功")
                    if self.successRefund != nil {
                        self.successRefund!()
                    }
                    _ = self.navigationController?.popViewController(animated: true)
                }else{
                    SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
                }
            })
        }else {
            NetworkModel.request(param as NSDictionary, url: "/Order/application_refund_add", complete: { (dic) in
                if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                    SVProgressHUD.showSuccess(withStatus: "申请成功")
                    if self.successRefund != nil {
                        self.successRefund!()
                    }
                    _ = self.navigationController?.popViewController(animated: true)
                }else{
                    SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
                }
            })
        }
    }
    
    func requestDeleteOrder() -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["refund_id":self.refundDic?["refund_id"] as! String], url: "/Order/refundlist_del", complete: { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.showSuccess(withStatus: "删除成功")
                if self.successRefund != nil {
                    self.successRefund!()
                }
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        })
    }
    
    func requestRefundDetail() -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["refund_id":self.refundDic?["refund_id"] as! String], url: "/Order/refund_deteils", complete: { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                self.refundDetail = (dic as! NSDictionary)["refund_msg"] as? NSArray
                self.tableView.reloadData()
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        })
    }

}
