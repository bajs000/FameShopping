//
//  PayViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/9.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit

class PayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalMoney: UILabel!
    
    var currentIndexPath: IndexPath = IndexPath(row: 1, section: 1)
    var payTitleArr = ["支付宝支付","快捷支付","微信支付"]
    var cartDic:NSDictionary?
    var dealNo:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "支付订单"
        self.totalMoney.text = "￥" + (self.cartDic?["total_price"] as! NSNumber).stringValue
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableView delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: .zero)
        v.backgroundColor = UIColor.clear
        return v
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = ""
        if indexPath.section == 0 {
            cellIdentify = "moneyCell"
        }else{
            if indexPath.row == 0 {
                cellIdentify = "payWayCell"
            }else {
                cellIdentify = "payCell"
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        if indexPath.section == 0 {
            (cell.viewWithTag(1) as! UILabel).text = "￥" + (self.cartDic?["total_price"] as! NSNumber).stringValue
        }else{
            if indexPath.row == 0 {
                
            }else {
                (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "pay-icon-" + String(indexPath.row - 1))
                (cell.viewWithTag(2) as! UILabel).text = payTitleArr[indexPath.row - 1]
                if currentIndexPath == indexPath {
                    (cell.viewWithTag(3) as! UIImageView).image = #imageLiteral(resourceName: "cart-select")
                }else {
                    (cell.viewWithTag(3) as! UIImageView).image = #imageLiteral(resourceName: "cart-unselect")
                }
                if indexPath.row == 3 {
                    cell.viewWithTag(4)?.isHidden = true
                }else {
                    cell.viewWithTag(4)?.isHidden = false
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row > 0 {
            currentIndexPath = indexPath
            self.tableView.reloadData()
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

}
