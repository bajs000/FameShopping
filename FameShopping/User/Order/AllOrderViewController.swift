//
//  AllOrderViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/9.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

enum OrderType: Int {
    case needPay        = 0
    case needAccept     = 1
    case needEvaluate   = 3
}

class AllOrderViewController: OrderBaseVC {

    var dataSource: NSArray?
    @IBOutlet var nullView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0)
        self.nullView.frame = CGRect(x: 0, y: 0, width: Helpers.screanSize().width, height: Helpers.screanSize().height - 64 - 40)
        self.tableView.tableFooterView = nullView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pageViewController?.navTitleBtnChanged(1)
        self.requestAllOrder()
    }
    
    public class func getInstance() -> AllOrderViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "all")
        return vc as! AllOrderViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.dataSource != nil {
            return self.dataSource!.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataSource != nil {
            let dic = self.dataSource![section] as! NSDictionary
            if dic["order_goods"] != nil && (dic["order_goods"] as! NSObject).isKind(of: NSArray.self) {
                return (dic["order_goods"] as! NSArray).count
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let dic = dataSource![section] as! NSDictionary
        if Int(dic["status"] as! String) == OrderType.needAccept.rawValue {
            return 35
        }
        return 65
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dic = self.dataSource![section] as! NSDictionary
        if Int(dic["status"] as! String) == OrderType.needPay.rawValue {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Helpers.screanSize().width, height: 45))
            headerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: Helpers.screanSize().width, height: 10))
            spaceView.backgroundColor = UIColor.colorWithHexString(hex: "F0F0F0")
            headerView.addSubview(spaceView)
            
            let dealNo = UILabel(frame: CGRect(x: 12, y: 10, width: Helpers.screanSize().width - 50, height: 35))
            dealNo.font = UIFont.systemFont(ofSize: 14)
            dealNo.textColor = #colorLiteral(red: 0.3190122843, green: 0.324126184, blue: 0.3451784253, alpha: 1)
            dealNo.text = "订单编号        " + (dic["deal_no"] as! String)
            headerView.addSubview(dealNo)
            
            let statusLabel = UILabel(frame: CGRect(x: Helpers.screanSize().width - 50 - 12, y: 10, width: 50, height: 35))
            headerView.addSubview(statusLabel)
            statusLabel.font = UIFont.systemFont(ofSize: 14)
            statusLabel.textColor = #colorLiteral(red: 0.9144125581, green: 0.3713477254, blue: 0.5323973894, alpha: 1)
            statusLabel.text = "待付款"
            statusLabel.textAlignment = .right
            
            let line = UIView(frame: .zero)
            line.backgroundColor = UIColor.colorWithHexString(hex: "C9C9C9")
            headerView.addSubview(line)
            line.mas_makeConstraints { (make) in
                _ = make?.left.equalTo()(headerView.mas_left)?.with().offset()(12)
                _ = make?.bottom.equalTo()(headerView.mas_bottom)
                _ = make?.right.equalTo()(headerView.mas_right)
                _ = make?.height.equalTo()(0.5)
            }
            
            return headerView
        }else if Int(dic["status"] as! String) == OrderType.needAccept.rawValue {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Helpers.screanSize().width, height: 45))
            headerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: Helpers.screanSize().width, height: 10))
            spaceView.backgroundColor = UIColor.colorWithHexString(hex: "F0F0F0")
            headerView.addSubview(spaceView)
            
            let orderTime = UILabel(frame: CGRect(x: 12, y: 10, width: Helpers.screanSize().width - 50, height: 35))
            orderTime.font = UIFont.systemFont(ofSize: 14)
            orderTime.textColor = #colorLiteral(red: 0.3190122843, green: 0.324126184, blue: 0.3451784253, alpha: 1)
            orderTime.text = "下单时间        " + (dic["time"] as! String).substring(to: (dic["time"] as! String).index((dic["time"] as! String).startIndex, offsetBy: 10))
            headerView.addSubview(orderTime)
            
            let refundBtn = UIButton(type: .custom)
            refundBtn.frame = CGRect(x: 12, y: 10, width: Helpers.screanSize().width - 24, height: 35)
            refundBtn.setTitleColor(#colorLiteral(red: 0.9144125581, green: 0.3713477254, blue: 0.5323973894, alpha: 1), for: .normal)
            refundBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            refundBtn.setTitle("退款", for: .normal)
            refundBtn.contentHorizontalAlignment = .right
            refundBtn.tag = section
            headerView.addSubview(refundBtn)
            refundBtn.addTarget(self, action: #selector(refundBtnDidClick(_:)), for: .touchUpInside)
            
            let line = UIView(frame: .zero)
            line.backgroundColor = UIColor.colorWithHexString(hex: "C9C9C9")
            headerView.addSubview(line)
            line.mas_makeConstraints { (make) in
                _ = make?.left.equalTo()(headerView.mas_left)?.with().offset()(12)
                _ = make?.bottom.equalTo()(headerView.mas_bottom)
                _ = make?.right.equalTo()(headerView.mas_right)
                _ = make?.height.equalTo()(0.5)
            }
            
            return headerView
        }else {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Helpers.screanSize().width, height: 45))
            headerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: Helpers.screanSize().width, height: 10))
            spaceView.backgroundColor = UIColor.colorWithHexString(hex: "F0F0F0")
            headerView.addSubview(spaceView)
            
            let dealNo = UILabel(frame: CGRect(x: 12, y: 10, width: Helpers.screanSize().width - 80, height: 35))
            dealNo.font = UIFont.systemFont(ofSize: 14)
            dealNo.textColor = #colorLiteral(red: 0.3190122843, green: 0.324126184, blue: 0.3451784253, alpha: 1)
            dealNo.text = "订单编号        " + (dic["deal_no"] as! String)
            headerView.addSubview(dealNo)
            
            let statusLabel = UILabel(frame: CGRect(x: Helpers.screanSize().width - 80 - 12, y: 10, width: 80, height: 35))
            headerView.addSubview(statusLabel)
            statusLabel.font = UIFont.systemFont(ofSize: 14)
            statusLabel.textColor = #colorLiteral(red: 0.9144125581, green: 0.3713477254, blue: 0.5323973894, alpha: 1)
            statusLabel.text = "交易完成"
            statusLabel.textAlignment = .right
            
            let line = UIView(frame: .zero)
            line.backgroundColor = UIColor.colorWithHexString(hex: "C9C9C9")
            headerView.addSubview(line)
            line.mas_makeConstraints { (make) in
                _ = make?.left.equalTo()(headerView.mas_left)?.with().offset()(12)
                _ = make?.bottom.equalTo()(headerView.mas_bottom)
                _ = make?.right.equalTo()(headerView.mas_right)
                _ = make?.height.equalTo()(0.5)
            }
            
            return headerView
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let dic = self.dataSource![section] as! NSDictionary
        
        if Int(dic["status"] as! String) == OrderType.needPay.rawValue {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: Helpers.screanSize().width, height: 65))
            footerView.backgroundColor = UIColor.white
            
            let moneyLabel = UILabel(frame :CGRect(x: 12, y: 0, width: Helpers.screanSize().width - 24, height: 32))
            footerView.addSubview(moneyLabel)
            moneyLabel.font = UIFont.systemFont(ofSize: 14)
            moneyLabel.textColor = #colorLiteral(red: 0.3190122843, green: 0.324126184, blue: 0.3451784253, alpha: 1)
            moneyLabel.textAlignment = .right
            moneyLabel.text = "合计：￥" + (dic["total_price"] as! String)
            let tempStr = NSMutableAttributedString(string: moneyLabel.text!)
            tempStr.addAttribute(NSForegroundColorAttributeName, value: #colorLiteral(red: 0.9144125581, green: 0.3713477254, blue: 0.5323973894, alpha: 1), range: NSMakeRange(3, (dic["total_price"] as! String).characters.count + 1))
            moneyLabel.attributedText = tempStr
            
            let payBtn = UIButton(type: .custom)
            footerView.addSubview(payBtn)
            payBtn.frame = CGRect(x: Helpers.screanSize().width - 75 - 12 , y: 32, width: 75, height: 25)
            payBtn.layer.borderColor = #colorLiteral(red: 0.9144125581, green: 0.3713477254, blue: 0.5323973894, alpha: 1).cgColor
            payBtn.layer.borderWidth = 1
            payBtn.layer.cornerRadius = 4
            payBtn.setTitleColor(#colorLiteral(red: 0.9144125581, green: 0.3713477254, blue: 0.5323973894, alpha: 1), for: .normal)
            payBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            payBtn.setTitle("去付款", for: .normal)
            payBtn.tag = section
            payBtn.addTarget(self, action: #selector(payBtnDidClick(_:)), for: .touchUpInside)
            
            return footerView
        }else if Int(dic["status"] as! String) == OrderType.needAccept.rawValue {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: Helpers.screanSize().width, height: 65))
            footerView.backgroundColor = UIColor.white
            
            let sureGoods = UIButton(type: .custom)
            footerView.addSubview(sureGoods)
            sureGoods.frame = CGRect(x: Helpers.screanSize().width - 75 - 12 , y: 5, width: 75, height: 25)
            sureGoods.layer.borderColor = #colorLiteral(red: 0.9144125581, green: 0.3713477254, blue: 0.5323973894, alpha: 1).cgColor
            sureGoods.layer.borderWidth = 1
            sureGoods.layer.cornerRadius = 4
            sureGoods.setTitleColor(#colorLiteral(red: 0.9144125581, green: 0.3713477254, blue: 0.5323973894, alpha: 1), for: .normal)
            sureGoods.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            sureGoods.addTarget(self, action: #selector(sureGoodsBtnDidClick(_:)), for: .touchUpInside)
            sureGoods.tag = section
            sureGoods.setTitle("确认收货", for: .normal)
            
            let logisticsBtn = UIButton(type: .custom)
            footerView.addSubview(logisticsBtn)
            logisticsBtn.frame = CGRect(x: Helpers.screanSize().width - 75 - 12 - 75 - 12 , y: 5, width: 75, height: 25)
            logisticsBtn.layer.borderColor = #colorLiteral(red: 0.9144125581, green: 0.3713477254, blue: 0.5323973894, alpha: 1).cgColor
            logisticsBtn.layer.borderWidth = 1
            logisticsBtn.layer.cornerRadius = 4
            logisticsBtn.setTitleColor(#colorLiteral(red: 0.9144125581, green: 0.3713477254, blue: 0.5323973894, alpha: 1), for: .normal)
            logisticsBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            logisticsBtn.addTarget(self, action: #selector(logisticsBtnDidClick(_:)), for: .touchUpInside)
            logisticsBtn.tag = section + 10
            logisticsBtn.setTitle("查看物流", for: .normal)
            
            return footerView
        }else {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: Helpers.screanSize().width, height: 65))
            footerView.backgroundColor = UIColor.white
            
            let moneyLabel = UILabel(frame :CGRect(x: 12, y: 0, width: Helpers.screanSize().width - 24, height: 32))
            footerView.addSubview(moneyLabel)
            moneyLabel.font = UIFont.systemFont(ofSize: 14)
            moneyLabel.textColor = #colorLiteral(red: 0.3190122843, green: 0.324126184, blue: 0.3451784253, alpha: 1)
            moneyLabel.textAlignment = .right
            moneyLabel.text = "合计：￥" + (dic["total_price"] as! String)
            let tempStr = NSMutableAttributedString(string: moneyLabel.text!)
            tempStr.addAttribute(NSForegroundColorAttributeName, value: #colorLiteral(red: 0.9144125581, green: 0.3713477254, blue: 0.5323973894, alpha: 1), range: NSMakeRange(3, (dic["total_price"] as! String).characters.count + 1))
            moneyLabel.attributedText = tempStr
            
            let payBtn = UIButton(type: .custom)
            footerView.addSubview(payBtn)
            payBtn.frame = CGRect(x: Helpers.screanSize().width - 75 - 12 , y: 32, width: 75, height: 25)
            payBtn.layer.borderColor = #colorLiteral(red: 0.9144125581, green: 0.3713477254, blue: 0.5323973894, alpha: 1).cgColor
            payBtn.layer.borderWidth = 1
            payBtn.layer.cornerRadius = 4
            payBtn.setTitleColor(#colorLiteral(red: 0.9144125581, green: 0.3713477254, blue: 0.5323973894, alpha: 1), for: .normal)
            payBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            payBtn.setTitle("去评价", for: .normal)
            payBtn.tag = section
            payBtn.addTarget(self, action: #selector(evaluateBtnDidClick(_:)), for: .touchUpInside)
            
            return footerView
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dic = ((self.dataSource![indexPath.section] as! NSDictionary)["order_goods"] as! NSArray)[indexPath.row] as! NSDictionary
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["graphic"] as! String))!)
        (cell.viewWithTag(2) as! UILabel).text = dic["goods_name"] as? String
        (cell.viewWithTag(3) as! UILabel).text = "￥" + (dic["price_num"] as! String)
        (cell.viewWithTag(4) as! UILabel).text = "尺码：" + (dic["goods_size"] as! String)
        (cell.viewWithTag(5) as! UILabel).text = "x" + (dic["num"] as! String)
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = self.dataSource![indexPath.section] as! NSDictionary
        
        if Int(dic["status"] as! String) == OrderType.needPay.rawValue {
            let dic = self.dataSource![indexPath.section] as! NSDictionary
            let vc = OrderDetailViewController.getInstance()
            vc.orderInfo = dic
            vc.status = .process
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "refundPush" {
            let vc = segue.destination as! RefundDetailViewController
            vc.refundDic = sender as? NSDictionary
            vc.type = .apply
            vc.successRefund = {
                self.requestAllOrder()
            }
        }
    }
    
    func refundBtnDidClick(_ sender: UIButton) -> Void {
        let dic = self.dataSource![sender.tag] as! NSDictionary
        self.performSegue(withIdentifier: "refundPush", sender: dic)
    }
    
    func logisticsBtnDidClick(_ sender: UIButton) -> Void {
        
    }
    
    func payBtnDidClick(_ sender: UIButton) -> Void {
        let dic = self.dataSource![sender.tag] as! NSDictionary
        let pay = PayViewController.getInstance()
        pay.cartDic = dic
        pay.dealNo = dic["deal_no"] as? String
        self.navigationController?.pushViewController(pay, animated: true)
    }
    
    func sureGoodsBtnDidClick(_ sender: UIButton) -> Void {
        let dic = self.dataSource![sender.tag] as! NSDictionary
        self.requestSureGoods(dic["deal_no"] as! String)
    }
    
    func evaluateBtnDidClick(_ sender: UIButton) -> Void {
        let dic = self.dataSource![sender.tag] as! NSDictionary
        let vc = OrderDetailViewController.getInstance()
        vc.orderInfo = dic
        vc.status = .finish
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func requestAllOrder() -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["user_id":UserModel.share.userId], url: "/Order/order_list") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                self.dataSource = (dic as! NSDictionary)["list"] as? NSArray
                self.tableView.reloadData()
                self.tableView.tableFooterView = nil
            }else{
                self.dataSource = nil
                self.tableView.tableFooterView = self.nullView
                self.tableView.reloadData()
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
    func requestSureGoods(_ dealNo: String) -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["user_id":UserModel.share.userId,"deal_no":dealNo], url: "/Order/order_qrsh") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                self.requestAllOrder()
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
}
