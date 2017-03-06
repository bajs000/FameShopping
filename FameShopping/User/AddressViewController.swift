//
//  AddressViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/6.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

class AddressViewController: UITableViewController {

    var addressList:NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.title = "地址管理"
        self.requestAddressList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.addressList == nil {
            return 1
        }
        return (self.addressList?.count)! + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.clear
        return view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = "Cell"
        if self.addressList == nil || (self.addressList?.count)! == indexPath.section {
            cellIdentify = "addCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        if self.addressList != nil && (self.addressList?.count)! > indexPath.section {
            cell.viewWithTag(4)?.layer.borderWidth = 1.5
            cell.viewWithTag(4)?.layer.borderColor = UIColor.colorWithHexString(hex: "AAAAAA").cgColor
            cell.viewWithTag(5)?.layer.borderWidth = 1.5
            cell.viewWithTag(5)?.layer.borderColor = UIColor.colorWithHexString(hex: "AAAAAA").cgColor
            (cell.viewWithTag(4) as! UIButton).addTarget(self, action: #selector(deleteAddressBtnDidClick(_:)), for: .touchUpInside)
            
            let dic = self.addressList?[indexPath.section] as! NSDictionary
            
            let phone = ((dic["uphone"] as! NSString).replacingCharacters(in: NSMakeRange(3, 4), with: "****") as String)
            let name = (dic["uname"] as! String)
            (cell.viewWithTag(1) as! UILabel).text = name + "        " + phone
            (cell.viewWithTag(2) as! UILabel).text = (dic["province_name"] as! String) + (dic["city_name"] as! String) + (dic["district_name"] as! String) + (dic["address"] as! String)
            (cell.viewWithTag(3) as! UILabel).text = dic["time"] as? String
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.addressList == nil || (self.addressList?.count)! >= indexPath.section {
            self.performSegue(withIdentifier: "eidtPush", sender: nil)
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

    func deleteAddressBtnDidClick(_ sender:UIButton) -> Void {
        let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender)
        let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
        let dic = self.addressList?[(indexPath?.section)!] as! NSDictionary
        self.requestDeleteAddress(dic["add_id"] as! String)
    }
    
    func requestAddressList() -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["user_id":UserModel.share.userId], url: "/User/address_list") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                self.addressList = (dic as! NSDictionary)["list"] as? NSArray
                self.tableView.reloadData()
            }else{
                self.addressList = nil
                self.tableView.reloadData()
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
    func requestDeleteAddress(_ addressId:String) -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["add_id":addressId], url: "/User/address_del") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                self.requestAddressList()
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
}
