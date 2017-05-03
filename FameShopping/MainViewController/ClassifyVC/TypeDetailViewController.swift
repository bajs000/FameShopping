//
//  TypeDetailViewController.swift
//  FameShopping
//
//  Created by 果儿 on 17/3/11.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class TypeDetailViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var typeInfo:NSDictionary?
    var dataSource: NSArray?
    var addParam = [String:String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestBrandList()
        self.title = self.typeInfo!["type_title"] as? String
    }

    public class func getInstance() -> TypeDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "typeDetail")
        return vc as! TypeDetailViewController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            return CGSize(width: width, height: 30)
        }
        let width = (Helpers.screanSize().width - 12 - 12 - 9) / 2
        return CGSize(width: width, height: 191 * width / 171 + 66)
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
            for i in 11...15 {
                let btn = cell.viewWithTag(i) as! UIButton
                btn.addTarget(self, action: #selector(sortBtnDidClick(_:)), for: .touchUpInside)
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
    
    func sortBtnDidClick(_ sender: UIButton) -> Void {
        sender.isSelected = !sender.isSelected
        switch sender.tag {
        case 11:
            break
        case 12:
            if sender.isSelected {
                addParam["order"] = "pricez"
                (sender.superview?.viewWithTag(13) as! UIButton).isSelected = false
            }else {
                addParam["order"] = "pricej"
            }
            break
        case 13:
            if sender.isSelected {
                addParam["order"] = "salesz"
                (sender.superview?.viewWithTag(12) as! UIButton).isSelected = false
            }else {
                addParam["order"] = "salesj"
            }
            break
        case 14:
            if sender.isSelected {
                (sender.superview?.viewWithTag(15) as! UIButton).isSelected = false
                addParam["nature"] = "remen"
            }else {
                addParam["nature"] = ""
            }
            break
        case 15:
            if sender.isSelected {
                (sender.superview?.viewWithTag(14) as! UIButton).isSelected = false
                addParam["nature"] = "xinpin"
            }else {
                addParam["nature"] = ""
            }
            break
        default:
            break
        }
        self.requestBrandList()
    }
    
    func requestBrandList() -> Void {
        SVProgressHUD.show()
        var param = ["type_id":self.typeInfo!["type_id"] as! String,"page":"1"]
        for key in addParam.keys {
            param[key] = addParam[key]
        }
        NetworkModel.request(param as NSDictionary, url: "/Public/goods_list") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                self.dataSource = (dic as! NSDictionary)["list"] as? NSArray
                self.collectionView?.reloadData()
            }else{
                self.dataSource = nil
                self.collectionView?.reloadData()
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }

}
