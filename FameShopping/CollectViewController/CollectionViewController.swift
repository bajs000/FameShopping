//
//  CollectionViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/8.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var redLineCenterX: NSLayoutConstraint!
    @IBOutlet weak var collection: UICollectionView!
    
    var currentBtnTag = 1
    var dataSource:NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "收藏"
        self.redLineCenterX.constant = -Helpers.screanSize().width / 4
        self.view.layoutIfNeeded()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.shadowImage = #imageLiteral(resourceName: "TransparentPixel")
        self.navigationController!.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "TransparentPixel"), for: .default)
        self.requestCollectionList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UICollectionView delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.dataSource != nil {
            return (self.dataSource?.count)!
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if currentBtnTag == 2 {
            return UIEdgeInsetsMake(10, 8, 10, 8)
        }else {
            return UIEdgeInsetsMake(10, 0, 10, 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if currentBtnTag == 1 {
            return CGSize(width: Helpers.screanSize().width, height: 2 * Helpers.screanSize().width / 5 + 60)
        }else {
            let width = (Helpers.screanSize().width - 24) / 2
            return CGSize(width: width, height: 9 * width / 7 + 75)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellIdentify = ""
        if currentBtnTag == 1 {
            cellIdentify = "brandCell"
        }else {
            cellIdentify = "goodsCell"
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentify, for: indexPath)
        let dic = dataSource?[indexPath.row] as! NSDictionary
        if currentBtnTag == 1 {
            (cell.viewWithTag(1) as! UILabel).text = dic["name"] as? String
            cell.viewWithTag(2)?.layer.borderColor = #colorLiteral(red: 0.5406702161, green: 0.5406834483, blue: 0.5406762958, alpha: 1).cgColor
            cell.viewWithTag(2)?.layer.borderWidth = 1
            cell.viewWithTag(2)?.layer.cornerRadius = 2
            (cell.viewWithTag(3) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["img"] as! String))!)
        }else {
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["img"] as! String))!)
            (cell.viewWithTag(2) as! UILabel).text = "￥" + (dic["price"] as! String)
            (cell.viewWithTag(3) as! UILabel).text = dic["name"] as? String
            (cell.viewWithTag(4) as! UILabel).text = "尺码：L"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentBtnTag == 2 {
            let dic = dataSource?[indexPath.row] as! NSDictionary
            print(dic)
            let vc = GoodPageViewController.getInstance()
            vc.detailDataSource = dic
            self.navigationController?.pushViewController(vc, animated: true)
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
    
    @IBAction func collectionTypeBtnDidClick(_ sender: UIButton) {
        if sender.tag == 1 {
            self.redLineCenterX.constant = -Helpers.screanSize().width/4
        }else {
            self.redLineCenterX.constant = Helpers.screanSize().width/4
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        for i in 1...2 {
            let btn = sender.superview?.viewWithTag(i) as! UIButton
            btn.setTitleColor(#colorLiteral(red: 0.2509803922, green: 0.2549019608, blue: 0.2745098039, alpha: 1), for: .normal)
        }
        sender.setTitleColor(#colorLiteral(red: 0.9144125581, green: 0.3713477254, blue: 0.5323973894, alpha: 1), for: .normal)
        currentBtnTag = sender.tag
        self.requestCollectionList()
    }
    
    func requestCollectionList() -> Void {
        SVProgressHUD.show()
        var param = ["user_id":UserModel.share.userId]
        if currentBtnTag == 1 {
            param["type"] = "1"
        }else {
            param["type"] = "0"
        }
        NetworkModel.request(param as NSDictionary, url: "/Public/collect_list") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.dismiss()
                self.dataSource = (dic as! NSDictionary)["list"] as? NSArray
                self.collection.reloadData()
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }

}
