//
//  GoodClassViewController.swift
//  FameShopping
//
//  Created by 果儿 on 17/3/11.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

enum GoodClassType {
    case girl
    case cosmetics
    case bag
    case men
    case baby
    case brand
}

class GoodClassViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var headerView: UIView!
    
    var typeInfo:NSDictionary?
    var type:GoodClassType = .girl
    
    var adImageDataSource:NSArray?
    var typeDataSource:NSArray?
    var smallAdDataSource:NSArray?
    var imgDataSource:NSArray = []
    
    var adCollectionView: UICollectionView?
    var typeCollectionView: UICollectionView?
    var smallAdCollectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.typeInfo?["type_title"] as? String
        self.requestGoodClass()
    }
    
    public class func getInstance() -> GoodClassViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "goodClass")
        return vc as! GoodClassViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if type == .girl || type == .bag{
            return 3
        }else if type == .cosmetics{
            return 4
        }else if type == .brand {
            return 4
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == .girl || type == .bag{
            if section == 0 {
                return 1
            }
            if section == 1 {
                return 1
            }
            if  section == 2 {
                return self.imgDataSource.count
            }
        }else if type == .cosmetics {
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
        }else if type == .brand {
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
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if type == .girl || type == .bag{
            if section == 0 || section == 1 {
                return 0
            }else {
                return 55
            }
        }else if type == .cosmetics {
            if section == 3 {
                return 55
            }
            return 0
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if type == .girl || type == .bag{
            if section == 2 {
                return 10
            }
        }else if type == .cosmetics {
            return 0
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if type == .girl || type == .bag{
            if section == 0 || section == 1 {
                return nil
            }else if section == 2 {
                return self.headerView
            }
            return nil
        }else if type == .cosmetics {
            if section == 3 {
                return self.headerView
            }
            return nil
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView(frame: .zero)
        v.backgroundColor = UIColor.clear
        return v
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if type == .girl || type == .bag{
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
                    if type == .bag {
                        let width = Helpers.screanSize().width / 5
                        let height = 5 * width / 4
                        return height
                    }
                    let width = Helpers.screanSize().width / 4
                    let height = 5 * width / 4
                    let count = (self.typeDataSource?.count)! / 4
                    let lastCount = (self.typeDataSource?.count)! % 4
                    if lastCount != 0 {
                        return CGFloat(count + 1) * height
                    }else{
                        return CGFloat(count) * height
                    }
                }
            }
            if indexPath.section == 2 {
                let width = Helpers.screanSize().width
                return  150 * width / 375 + 47
            }
        }else if type == .cosmetics {
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
                    let width = Helpers.screanSize().width / 4
                    let height = 5 * width / 4
                    let count = (self.typeDataSource?.count)! / 4
                    let lastCount = (self.typeDataSource?.count)! % 4
                    if lastCount != 0 {
                        return CGFloat(count + 1) * height
                    }else{
                        return CGFloat(count) * height
                    }
                }
            }
            if indexPath.section == 2 {
                return 150
            }
            if indexPath.section == 3 {
                let width = Helpers.screanSize().width
                return  150 * width / 375 + 47
            }
        }else if type == .brand {
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
                    let width = Helpers.screanSize().width / 3
                    let height = 5 * width / 4
                    let count = (self.typeDataSource?.count)! / 3
                    let lastCount = (self.typeDataSource?.count)! % 3
                    if lastCount != 0 {
                        return CGFloat(count + 1) * height
                    }else{
                        return CGFloat(count) * height
                    }
                }
            }
            if indexPath.section == 2 {
                return 150
            }
            if indexPath.section == 3 {
                let width = Helpers.screanSize().width
                return  150 * width / 375 + 47
            }
        }
        
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = "adCell"
        if type == .girl || type == .bag{
            if indexPath.section == 0 {
                cellIdentify = "adCell"
            }else if indexPath.section == 1 {
                cellIdentify = "typeCell"
            }else {
                cellIdentify = "imgCell"
            }
        }else if type == .cosmetics || type == .brand {
            if indexPath.section == 0 {
                cellIdentify = "adCell"
            }else if indexPath.section == 1 {
                cellIdentify = "typeCell"
            }else if indexPath.section == 2 {
                cellIdentify = "adCell"
            }else {
                cellIdentify = "imgCell"
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        if type == .girl || type == .bag{
            if indexPath.section == 0 {
                self.adCollectionView = (cell.viewWithTag(1) as! UICollectionView)
                self.adCollectionView?.delegate = self
                self.adCollectionView?.dataSource = self
            }else if indexPath.section == 1 {
                self.typeCollectionView = (cell.viewWithTag(1) as! UICollectionView)
                self.typeCollectionView?.delegate = self
                self.typeCollectionView?.dataSource = self
            }else {
                let dic = self.imgDataSource[indexPath.row] as! NSDictionary
                (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["img_kuan"] as! String)))
                (cell.viewWithTag(2) as! UILabel).text = dic["brand_name"] as? String
            }
        }else if type == .cosmetics || type == .brand {
            if indexPath.section == 0 {
                self.adCollectionView = (cell.viewWithTag(1) as! UICollectionView)
                self.adCollectionView?.delegate = self
                self.adCollectionView?.dataSource = self
            }else if indexPath.section == 1 {
                self.typeCollectionView = (cell.viewWithTag(1) as! UICollectionView)
                self.typeCollectionView?.delegate = self
                self.typeCollectionView?.dataSource = self
            }else if indexPath.section == 2 {
                self.smallAdCollectionView = (cell.viewWithTag(1) as! UICollectionView)
                self.smallAdCollectionView?.delegate = self
                self.smallAdCollectionView?.dataSource = self
            }else {
                let dic = self.imgDataSource[indexPath.row] as! NSDictionary
                (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["img_kuan"] as! String)))
                (cell.viewWithTag(2) as! UILabel).text = dic["brand_name"] as? String
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == .girl || type == .bag{
            if indexPath.section == 2 {
                let vc = BrandViewController.getInstance()
                let dic = self.imgDataSource[indexPath.row] as! NSDictionary
                vc.brandInfo = dic
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if type == .cosmetics || type == .brand {
            if indexPath.section == 3 {
                let vc = BrandViewController.getInstance()
                let dic = self.imgDataSource[indexPath.row] as! NSDictionary
                vc.brandInfo = dic
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    // MARK: - Collection view data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if type == .girl || type == .bag{
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
            }
        }else if type == .cosmetics || type == .brand {
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
            }else if collectionView == self.smallAdCollectionView{
                if self.smallAdDataSource == nil {
                    return 0
                }
                return (self.smallAdDataSource?.count)!
            }
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
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string :url))
            if type == .bag {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bagCell", for: indexPath)
                let width = collectionView.frame.width / 5
                (cell.viewWithTag(1) as! UIImageView).layer.cornerRadius = 6 * width / 9 / 2
                (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string :url))
                (cell.viewWithTag(2) as! UILabel).text = dic["type_title"] as? String
                return cell
            }else if type == .brand {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bagCell", for: indexPath)
                let width = collectionView.frame.width / 3
                (cell.viewWithTag(1) as! UIImageView).layer.cornerRadius = 6 * width / 9 / 2
                (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string :url))
                (cell.viewWithTag(2) as! UILabel).text = dic["type_title"] as? String
                return cell
            }
        }else if collectionView == self.smallAdCollectionView {
            dic = self.smallAdDataSource?[indexPath.row] as! NSDictionary
            if type == .brand {
                url =  Helpers.baseImgUrl() + (dic["graphic"] as! String)
            }else {
                url =  Helpers.baseImgUrl() + (dic["img_kuan"] as! String)
            }
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string :url))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.adCollectionView {
            return collectionView.frame.size
        }else if collectionView == self.typeCollectionView {
            if type == .bag {
                let width = collectionView.frame.width / 5
                return CGSize(width: width, height: 5 * width / 4)
            }else if type == .brand {
                let width = collectionView.frame.width / 3
                return CGSize(width: width, height: 5 * width / 4)
            }
            let width = collectionView.frame.width / 4
            return CGSize(width: width, height: 5 * width / 4)
        }else if collectionView == self.smallAdCollectionView {
            if type == .brand {
                let width = collectionView.frame.width / 3
                return CGSize(width: width, height: 150)
            }else {
                let width = collectionView.frame.width / 2
                if indexPath.row == 0 {
                    return CGSize(width: width, height: 150)
                }else {
                    return CGSize(width: width, height: 75)
                }
            }
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.typeCollectionView {
            let dic = self.typeDataSource?[indexPath.row] as! NSDictionary
            let vc = TypeDetailViewController.getInstance()
            vc.typeInfo = dic
            self.navigationController?.pushViewController(vc, animated: true)
        }else if collectionView == self.smallAdCollectionView {
            if type == .brand {
                let dic = self.smallAdDataSource?[indexPath.row] as! NSDictionary
                let vc = GoodPageViewController.getInstance()
                vc.detailDataSource = dic
                self.navigationController?.pushViewController(vc, animated: true)
            }else {
                let dic = self.smallAdDataSource?[indexPath.row] as! NSDictionary
                let vc = BrandViewController.getInstance()
                vc.brandInfo = dic
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func requestGoodClass() {
        SVProgressHUD.show()
        NetworkModel.request(["type_id":typeInfo!["type_id"] as! String], url: "/Public/type_list") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                self.adImageDataSource = (dic as! NSDictionary)["img"] as? NSArray
                self.typeDataSource = (dic as! NSDictionary)["type"] as? NSArray
                if self.type == .brand {
                    self.smallAdDataSource = (dic as! NSDictionary)["goods_tj"] as? NSArray
                }else{
                    self.smallAdDataSource = (dic as! NSDictionary)["brand_one"] as? NSArray
                }
                self.imgDataSource = ((dic as! NSDictionary)["brand"] as? NSArray)!
                self.tableView.reloadData()
                self.typeCollectionView?.reloadData()
                self.adCollectionView?.reloadData()
                self.smallAdCollectionView?.reloadData()
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }

}
