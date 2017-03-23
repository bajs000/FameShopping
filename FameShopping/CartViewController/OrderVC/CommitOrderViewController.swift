//
//  CommitOrderViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/9.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class CommitOrderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var acceptPerson: UILabel!
    @IBOutlet weak var phoneNum: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalMoney: UILabel!
    @IBOutlet weak var areaView:UIView!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var acceptView: UIView!
    @IBOutlet var tap: UITapGestureRecognizer!
    @IBOutlet weak var footerView: UIView!
    
    var cartDataSource:NSArray?
    var addressDataSource:NSDictionary?
    var cartDic:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "结算详情"
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestCart()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.cartDataSource != nil {
            return (self.cartDataSource?.count)!
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.cartDataSource != nil {
            let dic = self.cartDataSource?[section] as! NSDictionary
            if dic["cart"] != nil && (dic["cart"] as! NSObject).isKind(of: NSArray.self) {
                return (dic["cart"] as! NSArray).count + 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame:CGRect(x: 0, y: 0, width: Helpers.screanSize().width, height: 35))
        headerView.backgroundColor = UIColor.white
        let headerLabel = UILabel(frame: CGRect(x: 15, y: 0, width: Helpers.screanSize().width - 38, height: 35))
        headerView.addSubview(headerLabel)
        headerLabel.font = UIFont.systemFont(ofSize: 16)
        headerLabel.textColor = UIColor.colorWithHexString(hex: "666666")
        let dic = self.cartDataSource?[section] as! NSDictionary
        headerLabel.text = dic["brand_name"] as? String
        let line = UIView(frame: CGRect(x: 0, y: 34, width: Helpers.screanSize().width, height: 1))
        line.backgroundColor = #colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1)
        headerView.addSubview(line)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView(frame: .zero)
        v.backgroundColor = UIColor.clear
        return v
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = ""
        let dic = self.cartDataSource?[indexPath.section] as! NSDictionary
        if indexPath.row ==  (dic["cart"] as! NSArray).count{
            cellIdentify = "moneyCell"
        }else {
            cellIdentify = "goodsCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        if indexPath.row ==  (dic["cart"] as! NSArray).count{
            (cell.viewWithTag(1) as! UILabel).text = "全国包邮"
            (cell.viewWithTag(2) as! UILabel).text = "￥0.00"
            (cell.viewWithTag(3) as! UILabel).text = "￥" + (dic["brand_price_num"] as! String)
        }else {
            let dict = (dic["cart"] as! NSArray)[indexPath.row] as! NSDictionary
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dict["graphic"] as! String))!)
            (cell.viewWithTag(2) as! UILabel).text = dict["goods_name"] as? String
            (cell.viewWithTag(3) as! UILabel).text = "￥" + (dict["price_num"] as! String)
            (cell.viewWithTag(4) as! UILabel).text = "颜色尺码：" + (dict["goods_size"] as! String)
            (cell.viewWithTag(5) as! UILabel).text = "x" + (dict["num"] as! String)
        }
        return cell
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "payPush" {
            let vc = segue.destination as! PayViewController
            vc.cartDic = self.cartDic
            vc.dealNo = (sender as! NSDictionary)["deal_no"] as? String
        }
    }
    
    
    @IBAction func addressBtnDidClick(_ sender: Any) {
        let vc = AddressViewController.getInstance()
        vc.completeSelectAddress = {(dic) in
            self.requestCart()
        }
        self.navigationController?.pushViewController(AddressViewController.getInstance(), animated: true)
    }
    
    @IBAction func timeBtnDidClick(_ sender: Any) {
        self.areaView.isHidden = false
        self.blackView.alpha = 0.5
        self.acceptView.isHidden = false
        UIApplication.shared.keyWindow?.endEditing(true)
        
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
    
    @IBAction func acceptBtnDidClick(_ sender: UIButton) {
        if sender.tag == 0 {
            
        }else {
            let timeArr = ["收货时间不限","周一至周五收货","周六/周日/节假日收货"]
            self.timeLabel.text = timeArr[sender.tag - 1]
        }
        
        self.blackViewDidTap(tap)
    }
    
    @IBAction func blackViewDidTap(_ sender: UITapGestureRecognizer) {
        self.areaView.isHidden = true
    }
    
    @IBAction func commitBtnDidClick(_ sender: Any) {
        self.requestAddOrder()
    }
    
    func requestCart() -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["user_id":UserModel.share.userId], url: "/Cart/cart_order") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                self.cartDataSource = (dic as! NSDictionary)["list"] as? NSArray
                if (dic as! NSDictionary)["address"] != nil && ((dic as! NSDictionary)["address"] as! NSObject).isKind(of: NSDictionary.self) {
                    self.cartDic = (dic as! NSDictionary)
                    self.addressDataSource = (dic as! NSDictionary)["address"] as? NSDictionary
                    self.acceptPerson.text = "收件人：" + (((dic as! NSDictionary)["address"] as! NSDictionary)["uname"] as! String)
                    self.phoneNum.text = (((dic as! NSDictionary)["address"] as! NSDictionary)["uphone"] as? NSString)?.replacingCharacters(in: NSMakeRange(3, 4), with: "****")
                    self.addressLabel.text = (((dic as! NSDictionary)["address"] as! NSDictionary)["province_name"] as! String) + (((dic as! NSDictionary)["address"] as! NSDictionary)["city_name"] as! String) + (((dic as! NSDictionary)["address"] as! NSDictionary)["district_name"] as! String) + (((dic as! NSDictionary)["address"] as! NSDictionary)["address"] as! String)
                    self.timeLabel.text = ((dic as! NSDictionary)["address"] as! NSDictionary)["time"] as? String
                    self.totalMoney.text = "￥" + ((dic as! NSDictionary)["total_price"] as! NSNumber).stringValue
                    
                    if (dic as! NSDictionary)["zengsonglst"] != nil && ((dic as! NSDictionary)["zengsonglst"] as! NSObject).isKind(of: NSDictionary.self) {
                        self.footerView.frame = CGRect(x: 0, y: 0, width: Helpers.screanSize().width, height: 55)
                        (self.footerView.viewWithTag(1) as! UILabel).text = ((dic as! NSDictionary)["zengsonglst"] as! NSDictionary)["title"] as? String
                        self.tableView.tableFooterView = self.footerView
                    }
                    
                    
                }
                self.tableView.reloadData()
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
    func requestAddOrder() -> Void {
        if self.addressDataSource == nil {
            SVProgressHUD.showError(withStatus: "请添加收货地址")
            return
        }
        SVProgressHUD.show()
        var param = ["user_id":UserModel.share.userId,"add_id":self.addressDataSource?["add_id"] as! String,"shsj":self.timeLabel.text!]
        if self.cartDic?["zengsonglst"] != nil && (self.cartDic?["zengsonglst"] as! NSObject).isKind(of: NSDictionary.self) {
            param["zs_id"] = (self.cartDic?["zengsonglst"] as! NSDictionary)["zs_id"] as? String
        }
        NetworkModel.request(param as NSDictionary, url: "/Order/order_add") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                print(dic)
                self.performSegue(withIdentifier: "payPush", sender: dic)
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
//    func requestAddAddress() -> Void {
//        for dict in titleDic["0"]! {
//            if (dict["detail"]?.characters.count)! == 0 {
//                SVProgressHUD.showError(withStatus: "请输入" + dict["title"]!)
//                return
//            }
//        }
//        for dict in titleDic["1"]! {
//            if (dict["detail"]?.characters.count)! == 0 {
//                SVProgressHUD.showError(withStatus: "请输入" + dict["title"]!)
//                return
//            }
//        }
//        var param = [String:String]()
//        param = ["user_id":UserModel.share.userId,
//                 "ac":"add",
//                 "uname":(titleDic["0"]?[0]["detail"])!,
//                 "uphone":(titleDic["0"]?[1]["detail"])!,
//                 "time":(titleDic["0"]?[2]["detail"])!,
//                 "province":(province?["id"] as! String),
//                 "city":(city?["id"] as! String),
//                 "district":(district?["id"] as! String),
//                 "address":(titleDic["1"]?[4]["detail"])!]
//        if self.editAddress != nil {
//            param["ac"] = "save"
//            param["add_id"] = self.editAddress?["add_id"] as? String
//        }
//        SVProgressHUD.show()
//        NetworkModel.request(param as NSDictionary, url: "/User/address_edadd") { (dic) in
//            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
//                SVProgressHUD.dismiss()
//                _ = self.navigationController?.popViewController(animated: true)
//            }else{
//                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
//            }
//        }
//    }
}
