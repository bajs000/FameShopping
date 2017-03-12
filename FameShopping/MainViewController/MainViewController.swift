//
//  MainViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/3.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class MainViewController: UITableViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var todayHeader:UIView!
    @IBOutlet var siftHeader: UIView!
    
    var adImageDataSource:NSArray?
    var typeDataSource:NSArray?
    var todayDataSource:NSArray?
    var imgDataSource:NSArray = []
    var adCollectionView:UICollectionView?
    var typeCollectionView:UICollectionView?
    var todayCollectionView:UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首页"
        let titleArr = ["首页","收藏","购物车","我的"]
        for i in 0...titleArr.count - 1 {
            let tabItem = self.tabBarController?.tabBar.items?[i]
            self.item(tabItem!, title: titleArr[i], normalImg: "tabbar-unselect-" + String(i), selectImg: "tabbar-select-" + String(i))
        }
        self.requestMain()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (UIApplication.shared.delegate as! AppDelegate).drawer?.panGestureEnabled = (UserModel.share.userId.characters.count > 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (UIApplication.shared.delegate as! AppDelegate).drawer?.panGestureEnabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            return 1
        }
        if section == 2 {
            return 1
        }
        if  section == 3 {
            return self.imgDataSource.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section == 1 {
            return 0
        }else {
            return 55
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 || section == 1 {
            return nil
        }else if section == 2 {
            return self.todayHeader
        }else {
            return self.siftHeader
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if self.adImageDataSource == nil {
                return 0
            }else {
                return 152
            }
        }
        if indexPath.section == 1 {
            if self.typeDataSource == nil {
                return 0
            }else {
                let count = (self.typeDataSource?.count)! / 4
                let lastCount = (self.typeDataSource?.count)! % 4
                if lastCount != 0 {
                    return CGFloat(count + 1) * 90
                }else{
                    return CGFloat(count) * 90
                }
            }
        }
        if indexPath.section == 2 {
            if self.todayDataSource == nil {
                return 0
            }else {
                let count = (self.todayDataSource?.count)! / 2
                let lastCount = count % 2
                let width = 171 * Helpers.screanSize().width / 375
                let height = 265 * width / 171 + 10
                if lastCount != 0 {
                    return CGFloat(count + 1) * height + 10
                }else{
                    return CGFloat(count) * height + 10
                }
            }
        }
        if indexPath.section == 3 {
            return 160
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = "adCell"
        if indexPath.section == 0 {
            cellIdentify = "adCell"
        }else if indexPath.section == 1 {
            cellIdentify = "typeCell"
        }else if indexPath.section == 2 {
            cellIdentify = "todayCell"
        }else {
            cellIdentify = "imgCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        if indexPath.section == 0 {
            self.adCollectionView = (cell.viewWithTag(1) as! UICollectionView)
            self.adCollectionView?.delegate = self
            self.adCollectionView?.dataSource = self
        }else if indexPath.section == 1 {
            self.typeCollectionView = (cell.viewWithTag(1) as! UICollectionView)
            self.typeCollectionView?.delegate = self
            self.typeCollectionView?.dataSource = self
        }else if indexPath.section == 2 {
            self.todayCollectionView = (cell.viewWithTag(1) as! UICollectionView)
            self.todayCollectionView?.delegate = self
            self.todayCollectionView?.dataSource = self
        }else {
            let dic = self.imgDataSource[indexPath.row] as! NSDictionary
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["img_kuan"] as! String)))
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            let vc = BrandViewController.getInstance()
            let dic = self.imgDataSource[indexPath.row] as! NSDictionary
            vc.brandInfo = dic
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Collection view data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.adCollectionView {
            if self.adImageDataSource == nil {
                return 0
            }
            return (self.adImageDataSource?.count)!
        }else if collectionView == self.typeCollectionView{
            if self.typeDataSource == nil {
                return 0
            }
            return (self.typeDataSource?.count)!
        }else if collectionView == self.todayCollectionView {
            if self.todayDataSource == nil {
                return 0
            }
            return (self.todayDataSource?.count)!
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        var dic:NSDictionary = [:]
        var url = ""
        if collectionView == self.adCollectionView {
            dic = self.adImageDataSource?[indexPath.row] as! NSDictionary
            url =  Helpers.baseImgUrl() + (dic["bigpic"] as! String)
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: url))
        }else if collectionView == self.typeCollectionView {
            dic = self.typeDataSource?[indexPath.row] as! NSDictionary
            url =  Helpers.baseImgUrl() + (dic["type_img"] as! String)
            (cell.viewWithTag(2) as! UILabel).text = dic["type_title"] as? String
            (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "main-type-" + String(indexPath.row))
            (cell.viewWithTag(1) as! UIImageView).layer.cornerRadius = 25
        }else if collectionView == self.todayCollectionView {
            dic = self.todayDataSource?[indexPath.row] as! NSDictionary
            url =  Helpers.baseImgUrl() + (dic["graphic"] as! String)
            (cell.viewWithTag(2) as! UILabel).text = dic["goods_name"] as? String
            (cell.viewWithTag(3) as! UILabel).text = "￥" + (dic["price"] as! String)
            (cell.viewWithTag(4) as! UILabel).text = "￥" + (dic["price_y"] as! String)
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: url))
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.adCollectionView {
            return collectionView.frame.size
        }else if collectionView == self.typeCollectionView{
            return CGSize(width: collectionView.frame.width / 4, height: 90)
        }else if collectionView == self.todayCollectionView {
            let width = 171 * Helpers.screanSize().width / 375
            let height = 265 * width / 171
            return CGSize(width: width, height: height)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.todayCollectionView {
            let dic = self.todayDataSource?[indexPath.row] as! NSDictionary
            let vc = GoodPageViewController.getInstance()
            vc.detailDataSource = dic
            self.navigationController?.pushViewController(vc, animated: true)
        }else if collectionView == self.typeCollectionView {
            let dic = self.typeDataSource?[indexPath.row] as! NSDictionary
            if indexPath.row == 1 {
                let vc = MenViewController.getInstance()
                vc.menInfo = dic
                if indexPath.row == 1 {
                    vc.type = .men
                }else if indexPath.row == 4 {
                    vc.type = .baby
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                let vc = GoodClassViewController.getInstance()
                vc.typeInfo = dic
                if indexPath.row == 0 {
                    vc.type = .girl
                }else if indexPath.row == 2 {
                    vc.type = .cosmetics
                }else if indexPath.row == 3 {
                    vc.type = .bag
                }else if indexPath.row == 4 {
                    vc.type = .baby
                }else if indexPath.row == 6 {
                    vc.type = .brand
                }else if indexPath.row == 5 {
                    vc.type = .digit
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == todayCollectionView {
            return UIEdgeInsetsMake(10, 0, 10, 10)
        }else {
            return UIEdgeInsetsMake(0, 0, 0, 0)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func menuTableDidSelect(_ indexPath: IndexPath) {
        let dic = self.typeDataSource?[indexPath.row] as! NSDictionary
        if indexPath.row == 1 {
            let vc = MenViewController.getInstance()
            vc.menInfo = dic
            if indexPath.row == 1 {
                vc.type = .men
            }else if indexPath.row == 4 {
                vc.type = .baby
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            let vc = GoodClassViewController.getInstance()
            vc.typeInfo = dic
            if indexPath.row == 0 {
                vc.type = .girl
            }else if indexPath.row == 2 {
                vc.type = .cosmetics
            }else if indexPath.row == 3 {
                vc.type = .bag
            }else if indexPath.row == 4 {
                vc.type = .baby
            }else if indexPath.row == 6 {
                vc.type = .brand
            }else if indexPath.row == 5 {
                vc.type = .digit
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func item(_ tabItem: UITabBarItem, title: String, normalImg: String, selectImg: String) -> Void {
        let normalImage = UIImage(named: normalImg)?.withRenderingMode(.alwaysOriginal)
        let selectImage = UIImage(named: selectImg)?.withRenderingMode(.alwaysOriginal)
        tabItem.image = normalImage
        tabItem.selectedImage = selectImage
        tabItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.colorWithHexString(hex: "E14575")], for: .selected)
        tabItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.colorWithHexString(hex: "404146"),NSFontAttributeName:UIFont.systemFont(ofSize: 13)], for: .normal)
        
        tabItem.title = title
        
    }
    
    @IBAction func menuBtnDidClick(_ sender: Any) {
        if UserModel.share.userId.characters.count > 0 {
            (UIApplication.shared.delegate as! AppDelegate).showLeftMenu()
        }else {
            self.navigationController?.pushViewController(LoginViewController.getInstance(), animated: true)
        }
    }

    func requestMain() {
        SVProgressHUD.show()
        NetworkModel.request([:], url: "/Public/index") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                self.adImageDataSource = (dic as! NSDictionary)["top_img"] as? NSArray
                self.typeDataSource = (dic as! NSDictionary)["goods_type"] as? NSArray
                self.todayDataSource = (dic as! NSDictionary)["goods_tj"] as? NSArray
                self.imgDataSource = ((dic as! NSDictionary)["brand"] as? NSArray)!
                self.tableView.reloadData()
                self.typeCollectionView?.reloadData()
                self.adCollectionView?.reloadData()
                self.todayCollectionView?.reloadData()
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
}
