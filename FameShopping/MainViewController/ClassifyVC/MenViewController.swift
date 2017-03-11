//
//  MenViewController.swift
//  FameShopping
//
//  Created by 果儿 on 17/3/11.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class MenViewController: UITableViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var headerView: UIView!
    
    var menInfo: NSDictionary?
    var adImageDataSource:NSArray?
    var typeDataSource:NSArray?
    var imgDataSource:NSArray = []
    
    var collectionView:UICollectionView?
    
    var type:GoodClassType = .men
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestMen()
        self.title = self.menInfo?["type_title"] as? String
    }

    public class func getInstance() -> MenViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "men")
        return vc as! MenViewController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if type == .men {
            return 3
        }else if type == .baby {
            return 2
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == .men {
            if section == 0 {
                if self.adImageDataSource == nil {
                    return 0
                }
                return (self.adImageDataSource?.count)!
            }
            if section == 1 {
                return 1
            }
            if  section == 2 {
                return self.imgDataSource.count
            }
        }else if type == .baby {
            if section == 0 {
                if self.adImageDataSource == nil {
                    return 0
                }
                return (self.adImageDataSource?.count)!
            }
            if section == 1 {
                return self.imgDataSource.count
            }
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 55
        }else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if type == .men {
            if indexPath.section == 0 {
                if self.adImageDataSource == nil {
                    return 0
                }else {
                    return 162
                }
            }
            if indexPath.section == 1 {
                if self.typeDataSource == nil {
                    return 0
                }else {
                    let width = Helpers.screanSize().width / 2
                    let height = width
                    let count = (self.typeDataSource?.count)! / 2
                    let lastCount = (self.typeDataSource?.count)! % 2
                    if lastCount != 0 {
                        return CGFloat(count + 1) * height
                    }else{
                        return CGFloat(count) * height
                    }
                }
            }
            if indexPath.section == 2 {
                return  162
            }
        }else if type == .baby {
            if indexPath.section == 0 {
                if self.adImageDataSource == nil {
                    return 0
                }else {
                    return 162
                }
            }
            if indexPath.section == 1 {
                return  162
            }
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            if type == .baby {
            
            }else if type == .men {
                
            }
            return self.headerView
        }
        return nil
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = "imgCell"
        if type == .baby {
            cellIdentify = "imgCell"
        }else if type == .men {
            if indexPath.section == 1 {
                cellIdentify = "typeCell"
            }else {
                cellIdentify = "imgCell"
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        if type == .baby {
            if indexPath.section == 0 {
                let dic = self.adImageDataSource?[indexPath.row] as! NSDictionary
                (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["bigpic"] as! String)))
            }else if indexPath.section == 1 {
                let dic = self.imgDataSource[indexPath.row] as! NSDictionary
                (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["img_kuan"] as! String)))
            }
        }else if type == .men {
            if indexPath.section == 0 {
                let dic = self.adImageDataSource?[indexPath.row] as! NSDictionary
                (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["bigpic"] as! String)))
            }else if indexPath.section == 1 {
                self.collectionView = (cell.viewWithTag(1) as! UICollectionView)
                self.collectionView?.delegate = self
                self.collectionView?.dataSource = self
            }else {
                let dic = self.imgDataSource[indexPath.row] as! NSDictionary
                (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["img_kuan"] as! String)))
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == .baby {
            if indexPath.section == 1 {
                let vc = BrandViewController.getInstance()
                let dic = self.imgDataSource[indexPath.row] as! NSDictionary
                vc.brandInfo = dic
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if type == .men {
            if indexPath.section == 2 {
                let vc = BrandViewController.getInstance()
                let dic = self.imgDataSource[indexPath.row] as! NSDictionary
                vc.brandInfo = dic
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    // MARK: - Collection view data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView{
            if self.typeDataSource == nil {
                return 0
            }
            return (self.typeDataSource?.count)!
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        var dic:NSDictionary = [:]
        var url = ""
        if collectionView == self.collectionView {
            dic = self.typeDataSource?[indexPath.row] as! NSDictionary
            url =  Helpers.baseImgUrl() + (dic["type_PC_img"] as! String)
            (cell.viewWithTag(2) as! UILabel).text = dic["type_title"] as? String
            cell.viewWithTag(3)?.layer.cornerRadius = 2
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string :url))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collectionView{
            let width = collectionView.frame.width / 2
            return CGSize(width: width, height: width)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            let dic = self.typeDataSource?[indexPath.row] as! NSDictionary
            let vc = TypeDetailViewController.getInstance()
            vc.typeInfo = dic
            self.navigationController?.pushViewController(vc, animated: true)
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

    func requestMen() {
        SVProgressHUD.show()
        NetworkModel.request(["type_id":menInfo!["type_id"] as! String], url: "/Public/type_list") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                self.adImageDataSource = (dic as! NSDictionary)["img"] as? NSArray
                self.typeDataSource = (dic as! NSDictionary)["type"] as? NSArray
                self.imgDataSource = ((dic as! NSDictionary)["brand"] as? NSArray)!
                self.tableView.reloadData()
                self.collectionView?.reloadData()
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
}
