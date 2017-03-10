//
//  NeedEvaluateViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/9.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import Masonry

class NeedEvaluateViewController: OrderBaseVC {
    
    @IBOutlet var nullView: UIView!
    
    var dataSource:NSArray?
    
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
        self.pageViewController?.navTitleBtnChanged(4)
        self.requestNeedEvaluate()
    }

    public class func getInstance() -> NeedEvaluateViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "needEvaluate")
        return vc as! NeedEvaluateViewController
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
        return 65
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
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let dic = self.dataSource![section] as! NSDictionary
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
        let dic = self.dataSource![sender.tag] as! NSDictionary
        let vc = OrderDetailViewController.getInstance()
        vc.orderInfo = dic
        vc.status = .finish
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func requestNeedEvaluate() -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["user_id":UserModel.share.userId], url: "/Order/order_pinglist") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                self.dataSource = (dic as! NSDictionary)["list"] as? NSArray
                self.tableView.reloadData()
                self.tableView.tableFooterView = nil
            }else{
                self.dataSource = nil
                self.tableView.reloadData()
                self.tableView.tableFooterView = self.nullView
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
}
