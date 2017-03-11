//
//  GoodDetailViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/7.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

class GoodBaseVC: UITableViewController {
    var pageIndex = 0
    var pageViewController:GoodPageViewController?
}

class GoodViewController: GoodBaseVC, UICollectionViewDelegate, UICollectionViewDataSource, UIWebViewDelegate {

    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var imgCollection: UICollectionView!
    @IBOutlet weak var webView: UIWebView!
    
    var goodInfo:NSDictionary?{
        didSet{
            self.pageViewController?.goodInfo = goodInfo
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.webView.scrollView.isScrollEnabled = false
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        self.requestGood()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pageViewController?.navTitleBtnChanged(1)
    }
    
    public class func getInstance() -> GoodViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "good")
        return vc as! GoodViewController
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
        if self.goodInfo != nil {
            return 4
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = ""
        if indexPath.row == 0 {
            cellIdentify = "sellCell"
        }else if indexPath.row == 1 {
            cellIdentify = "activeCell"
        }else if indexPath.row == 2 {
            cellIdentify = "infoCell"
        }else if indexPath.row == 3 {
            cellIdentify = "evaluateCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        let dic = self.goodInfo?["list"] as? NSDictionary
        if indexPath.row == 0 {
            (cell.viewWithTag(1) as! UILabel).text = dic?["goods_name"] as? String
            (cell.viewWithTag(2) as! UILabel).text = "库存    " + (dic?["stock"] as! String)
            (cell.viewWithTag(3) as! UILabel).text = "￥" + (dic?["price"] as! String)
            (cell.viewWithTag(4) as! UILabel).text = "￥" + (dic?["price_y"] as! String)
        }else if indexPath.row == 2 {
            (cell.viewWithTag(11) as! UILabel).text = dic?["goods_name"] as? String
            (cell.viewWithTag(12) as! UILabel).text = dic?["breand_name"] as? String
            (cell.viewWithTag(13) as! UILabel).text = dic?["texture"] as? String
            (cell.viewWithTag(14) as! UILabel).text = dic?["washing_mode"] as? String
        }else if indexPath.row == 3 {
            (cell.viewWithTag(1) as! UILabel).text = "(" + (self.goodInfo?["ping_num"] as! String) + ")"
        }
        return cell
    }
    
    
    // MARK: - UICollectionView delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.goodInfo != nil {
            if self.goodInfo?["pic"] != nil && (self.goodInfo?["pic"] as! NSObject).isKind(of: NSArray.self) {
                return (self.goodInfo?["pic"] as! NSArray).count
            }
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let dic = (self.goodInfo?["pic"] as! NSArray)[indexPath.row] as? NSDictionary
        (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic?["graphic"] as! String))!)
        return cell
    }
    
    // MARK: - UIWebView delegate
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let webViewHeight = webView.scrollView.contentSize.height
        self.pageViewController?.webViewHeight = webViewHeight
        self.footerView.frame = CGRect(x: 0, y: 0, width: Helpers.screanSize().width, height: webViewHeight + 53)
        self.tableView.beginUpdates()
        self.tableView.tableFooterView = self.footerView
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

    func requestGood() -> Void {
        SVProgressHUD.show()
        var param = [String: String]()
        if self.pageViewController?.detailDataSource?["goods_id"] != nil {
            param = ["goods_id":self.pageViewController?.detailDataSource?["goods_id"] as! String,"user_id":UserModel.share.userId]
        }else {
            param = ["goods_id":self.pageViewController?.detailDataSource?["gbid"] as! String,"user_id":UserModel.share.userId]
        }
        NetworkModel.request(param as NSDictionary, url: "/Public/goods_details") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                self.goodInfo = (dic as! NSDictionary)
                let html = (self.goodInfo?["list"] as! NSDictionary)["details"] as? String
                self.webView.loadHTMLString(html!, baseURL: nil)
                self.imgCollection.reloadData()
                self.tableView.reloadData()
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
}
