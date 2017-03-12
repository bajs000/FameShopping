//
//  BrandViewController.swift
//  FameShopping
//
//  Created by 果儿 on 17/3/11.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class BrandViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var brandLikeItem: UIBarButtonItem!
    var dataSource: NSArray?
    var collectionId = ""
    var brandInfo: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.brandInfo!["brand_name"] == nil {
            self.title = self.brandInfo!["name"] as? String
        }else {
            self.title = self.brandInfo!["brand_name"] as? String
        }
        self.requestBrandList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public class func getInstance() -> BrandViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "brand")
        return vc as! BrandViewController
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if self.dataSource == nil {
            return 0
        }
        return self.dataSource!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let width = Helpers.screanSize().width
            return CGSize(width: width, height: 150 * width / 375 + 44)
        }else {
            let width = (Helpers.screanSize().width - 12 - 12 - 9) / 2
            return CGSize(width: width, height: 191 * width / 171 + 66)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }else {
            return UIEdgeInsetsMake(10, 12, 0, 12)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellIdentify = ""
        if indexPath.section == 0 {
            cellIdentify = "headerCell"
        }else {
            cellIdentify = "Cell"
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentify, for: indexPath)
        if indexPath.section == 0 {
            if self.brandInfo!["img_kuan"] == nil {
                (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (self.brandInfo!["img"] as! String)))
            }else{
                (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (self.brandInfo!["img_kuan"] as! String)))
            }
        }else {
            let dic = dataSource![indexPath.row] as! NSDictionary
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["graphic"] as! String)))
            (cell.viewWithTag(2) as! UILabel).text = dic["goods_name"] as? String
            (cell.viewWithTag(3) as! UILabel).text = "￥" + (dic["price"] as! String)
            (cell.viewWithTag(4) as! UILabel).text = "￥" + (dic["price_y"] as! String)
        }
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let dic = self.dataSource?[indexPath.row] as! NSDictionary
            let vc = GoodPageViewController.getInstance()
            vc.detailDataSource = dic
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    @IBAction func brandLikeDidClick(_ sender: Any) {
        if UserModel.checkUserLogin(at: self){
            self.requestCollection()
        }
    }
    
    func requestBrandList() -> Void {
        SVProgressHUD.show()
        var param = [String:String]()
        if self.brandInfo!["brand_id"] == nil {
            param = ["brand_id":self.brandInfo!["gbid"] as! String,"user_id":UserModel.share.userId,"page":"1"]
        }else {
            param = ["brand_id":self.brandInfo!["brand_id"] as! String,"user_id":UserModel.share.userId,"page":"1"]
        }
        NetworkModel.request(param as NSDictionary, url: "/Public/goods_list") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                self.dataSource = (dic as! NSDictionary)["list"] as? NSArray
                if ((dic as! NSDictionary)["collect_id"] as! NSObject).isKind(of: NSNumber.self) {
                    if ((dic as! NSDictionary)["collect_id"] as! NSNumber).intValue > 0 {
                        self.collectionId = ((dic as! NSDictionary)["collect_id"] as! NSNumber).stringValue
                        self.brandLikeItem.image = UIImage(named: "good-like")
                        self.brandLikeItem.tintColor = UIColor.colorWithHexString(hex: "E14575")
                    }else {
                        self.brandLikeItem.image = UIImage(named: "good-unlike")
                        self.brandLikeItem.tintColor = UIColor.colorWithHexString(hex: "414247")
                    }
                }else {
                    if Int((dic as! NSDictionary)["collect_id"] as! String)! > 0 {
                        self.collectionId = (dic as! NSDictionary)["collect_id"] as! String
                        self.brandLikeItem.image = UIImage(named: "good-like")
                        self.brandLikeItem.tintColor = UIColor.colorWithHexString(hex: "E14575")
                    }else{
                        self.brandLikeItem.image = UIImage(named: "good-unlike")
                        self.brandLikeItem.tintColor = UIColor.colorWithHexString(hex: "414247")
                    }
                }
                self.collectionView?.reloadData()
            }else{
                self.dataSource = nil
                self.collectionView?.reloadData()
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
    func requestCollection() -> Void {
        SVProgressHUD.show()
        var url = ""
        var alertStr = ""
        var param = [String:String]()
        if collectionId.characters.count > 0 {
            url = "/Public/collect_del"
            alertStr = "已删除收藏"
            param = ["collect_id":collectionId]
        }else {
            url = "/Public/collect_brand"
            alertStr = "收藏成功"
            param = ["user_id":UserModel.share.userId,"brand_id":self.brandInfo!["brand_id"] as! String]
        }
        NetworkModel.request(param as NSDictionary, url: url) { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.showSuccess(withStatus: alertStr)
                if self.collectionId.characters.count > 0 {
                    self.brandLikeItem.image = UIImage(named: "good-unlike")
                    self.brandLikeItem.tintColor = UIColor.colorWithHexString(hex: "404146")
                    self.collectionId = ""
                }else {
                    self.brandLikeItem.image = UIImage(named: "good-like")
                    self.brandLikeItem.tintColor = UIColor.colorWithHexString(hex: "E14575")
                    self.collectionId = ((dic as! NSDictionary)["collect_id"] as! NSNumber).stringValue
                }
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }

}
