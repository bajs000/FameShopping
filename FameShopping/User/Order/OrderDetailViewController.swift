//
//  OrderDetailViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/10.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit

enum OrderStatus {
    case process
    case finish
}

class OrderDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var status:OrderStatus = .finish
    var orderInfo:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "订单详情"
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "删除订单", style: .plain, target: self, action: #selector(rightBarItemDidClick(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.2509803922, green: 0.2549019608, blue: 0.2745098039, alpha: 1)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.shadowImage = nil
    }
    
    public class func getInstance() -> OrderDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "orderInfo")
        return vc as! OrderDetailViewController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 2 {
            return 1
        }
        return (orderInfo!["order_goods"] as! NSArray).count
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
            cellIdentify = "orderInfoCell"
        }else if indexPath.section == 1 {
            cellIdentify = "orderCell"
        }else {
            cellIdentify = "moneyCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        if indexPath.section == 0 {
            (cell.viewWithTag(1) as! UILabel).text = orderInfo?["deal_no"] as? String
            if status == .finish {
                (cell.viewWithTag(2) as! UILabel).text = "交易完成"
            }else{
                (cell.viewWithTag(2) as! UILabel).text = "待付款"
            }
            (cell.viewWithTag(3) as! UILabel).text = orderInfo?["time"] as? String
            (cell.viewWithTag(4) as! UILabel).text = "收件人：" + (orderInfo?["receipt_uname"] as! String)
            (cell.viewWithTag(5) as! UILabel).text = (orderInfo?["receipt_uphone"] as? NSString)?.replacingCharacters(in: NSMakeRange(3, 4), with: "****")
            (cell.viewWithTag(6) as! UILabel).text = (orderInfo?["receipt_province"] as! String) + (orderInfo?["receipt_city"] as! String) + (orderInfo?["receipt_district"] as! String) + (orderInfo?["receipt_address"] as! String)
            (cell.viewWithTag(7) as! UILabel).text = orderInfo?["receipt_time"] as? String
        }else if indexPath.section == 1 {
            cell.viewWithTag(5)?.layer.borderColor = #colorLiteral(red: 0.9144125581, green: 0.3713477254, blue: 0.5323973894, alpha: 1).cgColor
            cell.viewWithTag(5)?.layer.borderWidth = 1
            cell.viewWithTag(5)?.layer.cornerRadius = 4
            (cell.viewWithTag(5) as! UIButton).addTarget(self, action: #selector(evaluateBtnDidClick(_:)), for: .touchUpInside)
            let dic = (orderInfo!["order_goods"] as! NSArray)[indexPath.row] as! NSDictionary
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["graphic"] as! String))!)
            (cell.viewWithTag(2) as! UILabel).text = dic["goods_name"] as? String
            (cell.viewWithTag(3) as! UILabel).text = "￥" + (dic["price_num"] as! String)
            (cell.viewWithTag(4) as! UILabel).text = "尺码：" + (dic["goods_size"] as! String)
            if indexPath.row == (orderInfo!["order_goods"] as! NSArray).count - 1 {
                cell.viewWithTag(6)?.isHidden = true
            }else{
                cell.viewWithTag(6)?.isHidden = false
            }
        }else {
            (cell.viewWithTag(1) as! UILabel).text = "￥" + (orderInfo?["total_price"] as! String)
            (cell.viewWithTag(2) as! UILabel).text = "￥" + (orderInfo?["total_price"] as! String)
        }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func evaluateBtnDidClick(_ sender: UIButton) -> Void {
        let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender)
        let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
        let dic = (orderInfo!["order_goods"] as! NSArray)[(indexPath?.row)!] as! NSDictionary
        let vc = GoodsEvaluateViewController.getInstance()
        vc.goodsInfo = dic
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func rightBarItemDidClick(_ sender: UIBarButtonItem) -> Void {
        
    }

}
