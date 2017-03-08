//
//  EvaluateViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/7.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class EvaluateViewController: GoodBaseVC, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var headerView: UIView!
    var evaluateDataSource:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestEvaluate("")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pageViewController?.navTitleBtnChanged(2)
    }
    
    public class func getInstance() -> EvaluateViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "evaluate")
        return vc as! EvaluateViewController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.evaluateDataSource != nil {
            if self.evaluateDataSource?["list"] != nil && (self.evaluateDataSource?["list"] as! NSObject).isKind(of: NSArray.self) {
                return (self.evaluateDataSource?["list"] as! NSArray).count
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = 105 - 8 - 14.5 - 8 - 40
        let dic = (self.evaluateDataSource?["list"] as! NSArray)[indexPath.row] as? NSDictionary
        let message = dic?["message"] as? NSString
        if message != nil && (message?.length)! > 0{
            let rect = message?.boundingRect(with: CGSize(width: Helpers.screanSize().width - 14, height: 999), options: [.truncatesLastVisibleLine,.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 12)], context: nil)
            height = height + Double(max((rect?.size.height)!, 14.5)) + 8
        }
        if dic?["img"] != nil && !(dic?["img"] as! NSObject).isKind(of: NSNull.self) {
            height = height + 8 + 40
        }
        return CGFloat(height)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.evaluateDataSource != nil {
            (self.headerView.viewWithTag(1) as! UILabel).text = "全部评价\n" + (self.evaluateDataSource?["num"] as! String)
            (self.headerView.viewWithTag(2) as! UILabel).text = "好评\n" + (self.evaluateDataSource?["num_hp"] as! String)
            (self.headerView.viewWithTag(3) as! UILabel).text = "中评\n" + (self.evaluateDataSource?["num_zp"] as! String)
            (self.headerView.viewWithTag(4) as! UILabel).text = "差评\n" + (self.evaluateDataSource?["num_cp"] as! String)
            (self.headerView.viewWithTag(5) as! UILabel).text = "晒图\n" + (self.evaluateDataSource?["num_st"] as! String)
        }
        return self.headerView
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let dic = (self.evaluateDataSource?["list"] as! NSArray)[indexPath.row] as? NSDictionary
        if dic?["user"] != nil {
            (cell.viewWithTag(2) as! UILabel).text = (dic?["user"] as? NSDictionary)?["user_name"] as? String
            (cell.viewWithTag(3) as! UILabel).text = dic?["message"] as? String
            (cell.viewWithTag(4) as! UICollectionView).delegate = self
            (cell.viewWithTag(4) as! UICollectionView).dataSource = self
        }
        self.evaluateScore(Int(dic?["score"] as! String)!, at: (cell.viewWithTag(1))!)
        if dic?["img"] != nil && !(dic?["img"] as! NSObject).isKind(of: NSNull.self) {
            (cell.viewWithTag(4) as! UICollectionView).reloadData()
        }
        return cell
    }

    // MARK: - UICollectionView delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: collectionView)
        let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
        let dic = (self.evaluateDataSource?["list"] as! NSArray)[(indexPath?.row)!] as? NSDictionary
        if dic?["img"] != nil && (dic?["img"] as! NSObject).isKind(of: NSArray.self){
            return (dic?["img"] as! NSArray).count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let tableCell = Helpers.findSuperViewClass(UITableViewCell.self, with: collectionView)
        let tableIndexPath = self.tableView.indexPath(for: tableCell as! UITableViewCell)
        let dic = (self.evaluateDataSource?["list"] as! NSArray)[(tableIndexPath?.row)!] as? NSDictionary
        let dict = (dic?["img"] as! NSArray)[indexPath.row] as! NSDictionary
        (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dict["img"] as! String))!)
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
    
    func evaluateScore(_ score:Int, at view:UIView) -> Void {
        for i in 11...15 {
            (view.viewWithTag(i) as! UIImageView).image = UIImage(named: "goods-no-star")
        }
        if score > 0 {
            for i in 11...10 + score {
                (view.viewWithTag(i) as! UIImageView).image = UIImage(named: "goods-star")
            }
        }
    }
    
    @IBAction func evaluateKindAction(_ sender: UIButton) {
        if sender.tag == 11 {
            self.requestEvaluate("")
        }else if sender.tag == 12 {
            self.requestEvaluate("hp")
        }else if sender.tag == 13 {
            self.requestEvaluate("zp")
        }else if sender.tag == 14 {
            self.requestEvaluate("cp")
        }else if sender.tag == 15 {
            self.requestEvaluate("tu")
        }
        for i in 1...5 {
            (self.headerView.viewWithTag(i) as! UILabel).textColor = UIColor.colorWithHexString(hex: "404146")
        }
        (self.headerView.viewWithTag(sender.tag - 10) as! UILabel).textColor = UIColor.colorWithHexString(hex: "E14575")
    }
    
    func requestEvaluate(_ score:String) -> Void {
        SVProgressHUD.show()
        NetworkModel.request(["goods_id":self.pageViewController?.detailDataSource?["goods_id"] as! String,"score":score], url: "/Public/goods_ping") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                self.evaluateDataSource = (dic as! NSDictionary)
                self.tableView.reloadData()
            }else{
                self.evaluateDataSource = nil
                self.tableView.reloadData()
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }

}
