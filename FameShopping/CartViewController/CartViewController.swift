//
//  CartViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/8.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

enum CartActionType:String {
    case click      = "dstate"
    case all        = "qstate"
    case brand      = "bstate"
    case delete     = "del"
    case num        = "num"
}

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var nullView: UIView!
    @IBOutlet weak var selectGoodsBtn: UIButton!
    @IBOutlet weak var allSelectBtn: UIButton!
    @IBOutlet weak var totalMoney: UILabel!
    
    var cartDataSource:NSDictionary?
    var currentAction:Any?
    var allowCommit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "购物车"
        self.selectGoodsBtn.layer.borderColor = UIColor.colorWithHexString(hex: "E14575").cgColor
        self.selectGoodsBtn.layer.borderWidth = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestCartList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.cartDataSource != nil && self.cartDataSource?["list"] != nil && (self.cartDataSource?["list"] as! NSObject).isKind(of: NSArray.self){
            return (self.cartDataSource?["list"] as! NSArray).count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.cartDataSource != nil && self.cartDataSource?["list"] != nil && (self.cartDataSource?["list"] as! NSObject).isKind(of: NSArray.self){
            let dic = (self.cartDataSource?["list"] as! NSArray)[section] as! NSDictionary
            if dic["cart"] != nil && (dic["cart"] as! NSObject).isKind(of: NSArray.self) {
                return (dic["cart"] as! NSArray).count
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
        let headerBtn = UIButton(type: .custom)
        headerBtn.frame = headerView.frame
        headerView.addSubview(headerBtn)
        headerBtn.tag = section
        headerBtn.addTarget(self, action: #selector(brandSelectBtnDidClick(_:)), for: .touchUpInside)
        let selectImg = UIImageView(image: UIImage(named: "cart-select"))
        selectImg.frame = CGRect(x: 12, y: 10.5, width: 14, height: 14)
        headerView.addSubview(selectImg)
        let headerLabel = UILabel(frame: CGRect(x: 38, y: 0, width: Helpers.screanSize().width - 38, height: 35))
        headerView.addSubview(headerLabel)
        headerLabel.font = UIFont.systemFont(ofSize: 16)
        headerLabel.textColor = UIColor.colorWithHexString(hex: "666666")
        let dic = (self.cartDataSource?["list"] as! NSArray)[section] as! NSDictionary
        headerLabel.text = dic["brand_name"] as? String
        if (dic["brand_type"] as! NSNumber).intValue == 0 {
            selectImg.image = UIImage(named: "cart-unselect")
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView(frame: .zero)
        v.backgroundColor = UIColor.clear
        return v
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let dic = (((self.cartDataSource?["list"] as! NSArray)[indexPath.section] as! NSDictionary)["cart"] as! NSArray)[indexPath.row] as! NSDictionary
        (cell.viewWithTag(2) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["graphic"] as! String))!)
        (cell.viewWithTag(3) as! UILabel).text = dic["goods_name"] as? String
        (cell.viewWithTag(4) as! UILabel).text = "￥" + (dic["price_y"] as! String)
        (cell.viewWithTag(5) as! UILabel).text = "颜色样式：" + (dic["goods_size"] as! String)
        (cell.viewWithTag(9) as! UILabel).text = "￥" + (dic["price"] as! String)
        cell.viewWithTag(6)?.layer.borderColor = UIColor.colorWithHexString(hex: "AAAAAA").cgColor
        cell.viewWithTag(6)?.layer.borderWidth = 1
        (cell.viewWithTag(7) as! UIButton).addTarget(self, action: #selector(deleteBtnDidClick(_:)), for: .touchUpInside)
        (cell.viewWithTag(11) as! UIButton).addTarget(self, action: #selector(numBtnDidClick(_:)), for: .touchUpInside)
        (cell.viewWithTag(12) as! UIButton).addTarget(self, action: #selector(numBtnDidClick(_:)), for: .touchUpInside)
        (cell.viewWithTag(13) as! UILabel).text = dic["num"] as? String
        if (((self.cartDataSource?["list"] as! NSArray)[indexPath.section] as! NSDictionary)["cart"] as! NSArray).count - 1 == indexPath.row {
            cell.viewWithTag(8)?.isHidden = true
        }else {
            cell.viewWithTag(8)?.isHidden = false
        }
        if Int(dic["state"] as! String) == 1 {
            (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "cart-select")
            allowCommit = true
        }else {
            (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "cart-unselect")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentAction = indexPath
        self.requestCartAction(.click)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func commitBtnDidClick(_ sender: Any) {
        if allowCommit {
            self.performSegue(withIdentifier: "commitPush", sender: nil)
        }else {
            SVProgressHUD.showError(withStatus: "请选择购买的商品")
        }
    }
    
    @IBAction func selectGoodsBtnDidClick(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func allSelectBtnDidClick(_ sender: Any) {
        self.requestCartAction(.all)
    }
    
    func deleteBtnDidClick(_ sender: UIButton) -> Void {
        let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender)
        let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
        currentAction = indexPath
        self.requestCartAction(.delete)
    }
    
    func brandSelectBtnDidClick(_ sender: UIButton) -> Void {
        currentAction = sender
        self.requestCartAction(.brand)
    }
    
    func numBtnDidClick(_ sender: UIButton) -> Void {
        let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender)
        var num = Int((cell?.viewWithTag(13) as! UILabel).text!)
        if sender.tag == 11 {
            num = num! + 1
        }else {
            num = num! - 1
            if num! <= 1 {
                num = 1
                return
            }
        }
        (cell?.viewWithTag(13) as! UILabel).text = String(num!)
        
        
        let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
        currentAction = indexPath
        self.requestCartAction(.num)
    }
    
    func requestCartList() {
        allowCommit = false
        SVProgressHUD.show()
        NetworkModel.request(["user_id":UserModel.share.userId], url: "/Cart/index") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                self.cartDataSource = (dic as! NSDictionary)
                self.tableView.reloadData()
                self.nullView.isHidden = true
                if ((dic as! NSDictionary)["quanxuan"] as! NSNumber).intValue == 1 {
                    self.allSelectBtn.setImage(UIImage(named: "cart-select"), for: .normal)
                }else{
                    self.allSelectBtn.setImage(UIImage(named: "cart-unselect"), for: .normal)
                }
                if ((dic as! NSDictionary)["total_price"] as! NSObject).isKind(of: NSNumber.self){
                    self.totalMoney.text = "￥" + ((dic as! NSDictionary)["total_price"] as! NSNumber).stringValue
                }else {
                    self.totalMoney.text = "￥" + ((dic as! NSDictionary)["total_price"] as! String)
                }
            }else{
                self.cartDataSource = nil
                self.tableView.reloadData()
                self.nullView.isHidden = false
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
                self.allSelectBtn.setImage(UIImage(named: "cart-unselect"), for: .normal)
                self.totalMoney.text = "￥0.00"
            }
        }
    }
    
    func requestCartAction(_ type: CartActionType){
        SVProgressHUD.show()
        var param = ["user_id":UserModel.share.userId,"ac":type.rawValue]
        if type == .click {
            let indexPath = currentAction as! IndexPath
            let dic = (((self.cartDataSource?["list"] as! NSArray)[indexPath.section] as! NSDictionary)["cart"] as! NSArray)[indexPath.row] as! NSDictionary
            param["cart_id"] = dic["cart_id"] as? String
            param["brand_id"] = dic["brand_id"] as? String
        }else if type == .brand {
            let section = (currentAction as! UIButton).tag
            let dic = (self.cartDataSource?["list"] as! NSArray)[section] as! NSDictionary
            param["brand_id"] = dic["brand_id"] as? String
        }else if type == .all {
            
        }else if type == .delete {
            let indexPath = currentAction as! IndexPath
            let dic = (((self.cartDataSource?["list"] as! NSArray)[indexPath.section] as! NSDictionary)["cart"] as! NSArray)[indexPath.row] as! NSDictionary
            param["cart_id"] = dic["cart_id"] as? String
        }else {
            let indexPath = currentAction as! IndexPath
            let cell = self.tableView.cellForRow(at: indexPath)
            let dic = (((self.cartDataSource?["list"] as! NSArray)[indexPath.section] as! NSDictionary)["cart"] as! NSArray)[indexPath.row] as! NSDictionary
            param["cart_id"] = dic["cart_id"] as? String
            param["num"] = (cell?.viewWithTag(13) as! UILabel).text
        }
        NetworkModel.request(param as NSDictionary, url: "/Cart/cart_handle") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                self.requestCartList()
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }

}
