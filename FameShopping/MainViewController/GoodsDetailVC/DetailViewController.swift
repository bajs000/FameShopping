//
//  DetailViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/7.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit

class DetailViewController: GoodBaseVC {

    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var webView: UIWebView!
    var webViewHeight:CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.webView.scrollView.isScrollEnabled = false
        if self.pageViewController?.goodInfo != nil {
            let html = (self.pageViewController?.goodInfo?["list"] as! NSDictionary)["details"] as? String
            self.webView.loadHTMLString(html!, baseURL: nil)
        }
        if ((self.pageViewController?.webViewHeight) != nil)        {
            self.footerView.frame = CGRect(x: 0, y: 0, width: Helpers.screanSize().width, height: webViewHeight! + 53)
            self.tableView.beginUpdates()
            self.tableView.tableFooterView = self.footerView
            self.tableView.endUpdates()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.pageViewController?.navTitleBtnChanged(3)
    }
    
    public class func getInstance() -> DetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "detail")
        return vc as! DetailViewController
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
        if self.pageViewController?.goodInfo != nil {
            return 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
        let dic = self.pageViewController?.goodInfo?["list"] as? NSDictionary
        (cell.viewWithTag(11) as! UILabel).text = dic?["goods_name"] as? String
        (cell.viewWithTag(12) as! UILabel).text = dic?["breand_name"] as? String
        (cell.viewWithTag(13) as! UILabel).text = dic?["texture"] as? String
        (cell.viewWithTag(14) as! UILabel).text = dic?["washing_mode"] as? String
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

}
