//
//  SettingViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/6.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class SettingViewController: UITableViewController {

    @IBOutlet weak var pushSwitch: UISwitch!
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pushSwitch.isOn = (UserModel.share.pushStatus == "1")
        self.title = "设置"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    public class func getInstance() -> SettingViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "setting")
        return vc as! SettingViewController
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  indexPath.row == 0 && indexPath.section == 0 {
            count = 0
            SVProgressHUD.show(withStatus: "清理中...")
            self.clearCache(at: NSTemporaryDirectory())
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func logoutBtnDidClick(_ sender: Any) {
        UserModel.share.logout()
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func clearCache(at path:String) -> Void {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path) {
            let childerFiles = fileManager.subpaths(atPath: path)
            if childerFiles != nil {
                for fileName in childerFiles! {
                    if fileName.contains("com.apple.nsurlsessiond") {
                        continue
                    }
                    let absolutePath = (path as NSString).appendingPathComponent(fileName)
                    do {
                        try fileManager.removeItem(atPath: absolutePath)
                    }catch {
                        
                    }
                    
                }
            }
        }
        SDImageCache.shared().clearDisk {
            self.count = self.count + 1
            if self.count == 1 {
                self.clearCache(at: NSHomeDirectory() + "/Library/Caches")
            }else{
                SVProgressHUD.showSuccess(withStatus: "图片缓存已清除")
            }
        }
    }
    
    @IBAction func pushSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.setValue("1", forKey: "PUSHSTATUS")
        }else{
            UserDefaults.standard.setValue("0", forKey: "PUSHSTATUS")
        }
        UserModel.share.resetPushStatus()
    }

}
