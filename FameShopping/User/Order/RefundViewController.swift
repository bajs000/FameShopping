//
//  RefundViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/9.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import Masonry

class RefundViewController: OrderBaseVC {

    var dataSource:NSArray?
    @IBOutlet var nullView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "退款订单"
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 0, 0)
        self.nullView.frame = CGRect(x: 0, y: 0, width: Helpers.screanSize().width, height: Helpers.screanSize().height - 64 - 40)
        self.tableView.tableFooterView = nullView

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pageViewController?.navTitleBtnChanged(5)
        self.requestRefund()
        if alonePush {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
            self.nullView.frame = CGRect(x: 0, y: 0, width: Helpers.screanSize().width, height: Helpers.screanSize().height - 64)
            self.tableView.tableFooterView = nullView
        }
    }
    
    public class func getInstance() -> RefundViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "refund")
        return vc as! RefundViewController
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
            if dic["og"] != nil && (dic["og"] as! NSObject).isKind(of: NSArray.self) {
                return (dic["og"] as! NSArray).count
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let dic = self.dataSource![section] as! NSDictionary
        if  dic["zengsong_status"] != nil && (dic["zengsong_status"] as! NSObject).isKind(of: NSString.self) && (dic["zengsong_status"] as! String) == "1" {
            return 65
        }
//        return 65
        return 35
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dic = self.dataSource![section] as! NSDictionary
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Helpers.screanSize().width, height: 45))
        headerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: Helpers.screanSize().width, height: 10))
        spaceView.backgroundColor = UIColor.colorWithHexString(hex: "F0F0F0")
        headerView.addSubview(spaceView)
        
        let dealNo = UILabel(frame: CGRect(x: 12, y: 10, width: Helpers.screanSize().width - 80, height: 35))
        dealNo.font = UIFont.systemFont(ofSize: 14)
        dealNo.textColor = #colorLiteral(red: 0.3190122843, green: 0.324126184, blue: 0.3451784253, alpha: 1)
        dealNo.text = "订单编号    " + (dic["deal_no"] as! String)
        headerView.addSubview(dealNo)
        
        let refundBtn = UIButton(type: .custom)
        refundBtn.frame = CGRect(x: Helpers.screanSize().width - 80 - 12, y: 15, width: 80, height: 25)
        refundBtn.layer.cornerRadius = 4
        refundBtn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        refundBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        refundBtn.setTitle("退款详情", for: .normal)
        refundBtn.tag = section
        refundBtn.backgroundColor = #colorLiteral(red: 0.9144125581, green: 0.3713477254, blue: 0.5323973894, alpha: 1)
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
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let dic = (self.dataSource![section] as! NSDictionary)["order"] as! NSDictionary
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: Helpers.screanSize().width, height: 65))
        footerView.backgroundColor = UIColor.white
        
        let presentLabel = UILabel(frame: CGRect(x: 12, y: 37, width: Helpers.screanSize().width - 24, height: 25))
        presentLabel.text = /*"满200送一个月爱奇艺会员"*/dic["zengsong"] as? String
        presentLabel.textColor = #colorLiteral(red: 0.3190122843, green: 0.324126184, blue: 0.3451784253, alpha: 1)
        presentLabel.font = UIFont.systemFont(ofSize: 12)
        footerView.addSubview(presentLabel)
        
        let moneyLabel = UILabel(frame :CGRect(x: 12, y: 0, width: 100, height: 32))
        footerView.addSubview(moneyLabel)
        moneyLabel.font = UIFont.systemFont(ofSize: 14)
        moneyLabel.textColor = #colorLiteral(red: 0.3190122843, green: 0.324126184, blue: 0.3451784253, alpha: 1)
        moneyLabel.text = "价格合计："
        
        let money = UILabel(frame :CGRect(x: Helpers.screanSize().width - 212, y: 0, width: 200, height: 32))
        footerView.addSubview(money)
        money.font = UIFont.systemFont(ofSize: 14)
        money.textColor = #colorLiteral(red: 0.9144125581, green: 0.3713477254, blue: 0.5323973894, alpha: 1)
        money.textAlignment = .right
        money.text = "￥" + (dic["total_price"] as! String)
        
        return footerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dic = ((self.dataSource![indexPath.section] as! NSDictionary)["og"] as! NSArray)[indexPath.row] as! NSDictionary
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["graphic"] as! String))!)
        (cell.viewWithTag(2) as! UILabel).text = dic["goods_name"] as? String
        (cell.viewWithTag(3) as! UILabel).text = "￥" + (dic["price"] as! String)
        (cell.viewWithTag(4) as! UILabel).text = "尺码：" + (dic["goods_size"] as! String)
        (cell.viewWithTag(5) as! UILabel).text = "x" + (dic["num"] as! String)
        return cell
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

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "refundPush" {
            let vc = segue.destination as! RefundDetailViewController
            vc.refundDic = sender as? NSDictionary
            vc.type = .check
            vc.successRefund = {
                self.requestRefund()
            }
        }
    }
    
    func refundBtnDidClick(_ sender: UIButton) -> Void {
        let dic = self.dataSource![sender.tag] as! NSDictionary
        self.performSegue(withIdentifier: "refundPush", sender: dic)
    }
 
    
    func requestRefund() -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["user_id":UserModel.share.userId], url: "/Order/order_refundlist") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                self.dataSource = (dic as! NSDictionary)["list"] as? NSArray
                self.tableView.reloadData()
                self.tableView.tableFooterView = nil
            }else{
                self.tableView.tableFooterView = self.nullView
                self.dataSource = nil
                self.tableView.reloadData()
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }

}
