//
//  GoodPageViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/7.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import Masonry
import SVProgressHUD

class GoodPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    @IBOutlet var bottomView: UIView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var goodLikeItem: UIBarButtonItem!
    @IBOutlet var buyDetailView: UIView!
    @IBOutlet weak var modelDetailHeight: NSLayoutConstraint!
    @IBOutlet weak var buyDetailBottom: NSLayoutConstraint!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sizeScrollView: UIScrollView!
    @IBOutlet weak var buyDetailIcon: UIImageView!
    
    var currentSizeBtn:UIButton?
    var VCArr = [GoodBaseVC]()
    var detailDataSource:NSDictionary?
    var collectionId:String = ""
    var goodInfo:NSDictionary?{
        didSet{
            let dic = self.goodInfo?["list"] as? NSDictionary
            self.addBtn.setTitle("￥" + (dic?["price"] as! String) + "加入购物车", for: .normal)
            print(dic!)
            if goodInfo?["collect_id"] != nil && (goodInfo?["collect_id"] as! NSObject).isKind(of: NSString.self) && (goodInfo?["collect_id"] as! String).characters.count > 0 {
                self.goodLikeItem.image = UIImage(named: "good-like")
                self.goodLikeItem.tintColor = UIColor.colorWithHexString(hex: "E14575")
                collectionId = goodInfo?["collect_id"] as! String
            }else{
                self.goodLikeItem.image = UIImage(named: "good-unlike")
                self.goodLikeItem.tintColor = UIColor.colorWithHexString(hex: "414247")
                collectionId = ""
            }
            if goodInfo?["pic"] != nil && (goodInfo?["pic"] as! NSObject).isKind(of: NSArray.self) {
                self.buyDetailIcon.sd_setImage(with: URL(string: Helpers.baseImgUrl() + (((goodInfo?["pic"] as! NSArray)[0] as! NSDictionary)["graphic"] as! String)))
            }
            self.moneyLabel.text = "￥" + (dic?["price"] as! String)
            self.nameLabel.text = dic?["goods_name"] as? String
            
            var x = 0.0
            var y = 0.0
            var i = 0
            if goodInfo?["goods_size"] != nil && (goodInfo?["goods_size"] as! NSObject).isKind(of: NSArray.self) {
                for sizeDic in (goodInfo?["goods_size"] as! NSArray) {
                    let sizeStr = (sizeDic as! NSDictionary)["size"] as! String
                    var size = (sizeStr as NSString).boundingRect(with: CGSize(width: 1000, height: 1000), options: [.truncatesLastVisibleLine,.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14)], context: nil).size
                    size.width = size.width + 16
                    size.height = size.height + 8
                    let btn = UIButton(type: .custom)
                    btn.layer.borderColor = UIColor.colorWithHexString(hex: "AAAAAA").cgColor
                    btn.layer.borderWidth = 1
                    self.sizeScrollView.addSubview(btn)
                    btn.setTitle(sizeStr, for: .normal)
                    btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                    btn.setTitleColor(UIColor.colorWithHexString(hex: "404146"), for: .normal)
                    if CGFloat(x) + size.width > Helpers.screanSize().width - 30 {
                        x = 0
                        y = y + 25 + 8
                        btn.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: size.width, height: 25)
                        x = Double(size.width) + 12.0 + x
                    }else {
                        btn.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: size.width, height: 25)
                       x = Double(size.width) + 12.0 + x
                    }
                    btn.tag = i + 1
                    btn.addTarget(self, action: #selector(sizeBtnDidClick(_:)), for: .touchUpInside)
                    i = i + 1
                }
            }
            
            self.modelDetailHeight.constant = CGFloat(187.0 + y + 25 + 8)
            self.buyDetailBottom.constant = -self.modelDetailHeight.constant - 47
            self.view.layoutIfNeeded()
        }
        
    }
    var webViewHeight:CGFloat?{
        didSet{
            (VCArr[2] as! DetailViewController).webViewHeight = webViewHeight
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        self.addBtn.layer.cornerRadius = 4
        
        self.initNavView()
        
        self.buyDetailIcon.layer.borderColor = UIColor.colorWithHexString(hex: "AAAAAA").cgColor
        self.buyDetailIcon.layer.borderWidth = 1
        
        let goodVC = GoodViewController.getInstance()
        goodVC.pageIndex = 0
        goodVC.pageViewController = self
        let evaluateVC = EvaluateViewController.getInstance()
        evaluateVC.pageIndex = 1
        evaluateVC.pageViewController = self
        let detailVC = DetailViewController.getInstance()
        detailVC.pageIndex = 2
        detailVC.pageViewController = self
        VCArr = [goodVC,evaluateVC,detailVC]
        self.setViewControllers([VCArr[0]], direction: .reverse, animated: true) { (finish) in
            
        }
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.bottomView)
        self.bottomView.mas_makeConstraints { (make) in
            _ = make?.bottom.equalTo()(self.view.mas_bottom)
            _ = make?.left.equalTo()(self.view.mas_left)
            _ = make?.right.equalTo()(self.view.mas_right)
            _ = make?.height.equalTo()(50)
        }
        self.view.addSubview(self.buyDetailView)
        self.buyDetailView.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(self.view.mas_top)
            _ = make?.left.equalTo()(self.view.mas_left)
            _ = make?.bottom.equalTo()(self.view.mas_bottom)
            _ = make?.right.equalTo()(self.view.mas_right)
        }
    }
    
    public class func getInstance() -> GoodPageViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "page")
        return vc as! GoodPageViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UIPageViewController delegate
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if (viewController as! GoodBaseVC).pageIndex == 0 {
            return VCArr[1]
        }else if (viewController as! GoodBaseVC).pageIndex == 1 {
            return VCArr[2]
        }else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if (viewController as! GoodBaseVC).pageIndex == 2 {
            return VCArr[1]
        }else if (viewController as! GoodBaseVC).pageIndex == 1 {
            return VCArr[0]
        }else {
            return nil
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
    
    func initNavView() -> Void {
        let navTitleView = UIView(frame: CGRect(x: 0, y: 0, width: 180, height: 44))
        let goodBtn = UIButton(type: .custom)
        let evaluateBtn = UIButton(type: .custom)
        let detailBtn = UIButton(type: .custom)
        navTitleView.addSubview(goodBtn)
        navTitleView.addSubview(evaluateBtn)
        navTitleView.addSubview(detailBtn)
        goodBtn.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(navTitleView.mas_top)
            _ = make?.left.equalTo()(navTitleView.mas_left)
            _ = make?.bottom.equalTo()(navTitleView.mas_bottom)
            _ = make?.width.equalTo()(navTitleView.mas_width)?.dividedBy()(3)
        }
        evaluateBtn.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(navTitleView.mas_top)
            _ = make?.left.equalTo()(goodBtn.mas_right)
            _ = make?.bottom.equalTo()(navTitleView.mas_bottom)
            _ = make?.width.equalTo()(goodBtn.mas_width)
        }
        detailBtn.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(navTitleView.mas_top)
            _ = make?.left.equalTo()(evaluateBtn.mas_right)
            _ = make?.bottom.equalTo()(navTitleView.mas_bottom)
            _ = make?.width.equalTo()(evaluateBtn.mas_width)
        }
        goodBtn.setTitle("商品", for: .normal)
        evaluateBtn.setTitle("评价", for: .normal)
        detailBtn.setTitle("详情", for: .normal)
        goodBtn.tag = 1
        evaluateBtn.tag = 2
        detailBtn.tag = 3
        goodBtn.addTarget(self, action: #selector(pageBtnDidClick(_:)), for: .touchUpInside)
        evaluateBtn.addTarget(self, action: #selector(pageBtnDidClick(_:)), for: .touchUpInside)
        detailBtn.addTarget(self, action: #selector(pageBtnDidClick(_:)), for: .touchUpInside)
        goodBtn.setTitleColor(UIColor.colorWithHexString(hex: "E14575"), for: .normal)
        evaluateBtn.setTitleColor(UIColor.colorWithHexString(hex: "404146"), for: .normal)
        detailBtn.setTitleColor(UIColor.colorWithHexString(hex: "404146"), for: .normal)
        self.navigationItem.titleView = navTitleView
        
    }
    
    func pageBtnDidClick(_ sender: UIButton) -> Void {
        for btn in (sender.superview?.subviews)! {
            (btn as! UIButton).setTitleColor(UIColor.colorWithHexString(hex: "404146"), for: .normal)
        }
        sender.setTitleColor(UIColor.colorWithHexString(hex: "E14575"), for: .normal)
        
        if (self.viewControllers?[0] as! GoodBaseVC).pageIndex == 0 {
            self.setViewControllers([VCArr[sender.tag - 1]], direction: .forward, animated: true) { (finish) in
                
            }
        }
        if (self.viewControllers?[0] as! GoodBaseVC).pageIndex == 1 {
            if sender.tag == 3 {
                self.setViewControllers([VCArr[sender.tag - 1]], direction: .forward, animated: true) { (finish) in
                    
                }
            }else {
                self.setViewControllers([VCArr[sender.tag - 1]], direction: .reverse, animated: true) { (finish) in
                    
                }
            }
        }
        if (self.viewControllers?[0] as! GoodBaseVC).pageIndex == 2 {
            self.setViewControllers([VCArr[sender.tag - 1]], direction: .reverse, animated: true) { (finish) in
                
            }
        }
    }
    
    func navTitleBtnChanged(_ tag: Int) -> Void {
        let sender = self.navigationItem.titleView?.viewWithTag(tag) as! UIButton
        for btn in (sender.superview?.subviews)! {
            (btn as! UIButton).setTitleColor(UIColor.colorWithHexString(hex: "404146"), for: .normal)
        }
        sender.setTitleColor(UIColor.colorWithHexString(hex: "E14575"), for: .normal)
    }

    func sizeBtnDidClick(_ sender: UIButton) -> Void {
        
        for i in 1...(goodInfo?["goods_size"] as! NSArray).count {
            let btn = sender.superview?.viewWithTag(i)
            (btn as! UIButton).backgroundColor = UIColor.white
            btn?.layer.borderWidth = 1
            (btn as! UIButton).setTitleColor(UIColor.colorWithHexString(hex: "404146"), for: .normal)
        }
        sender.layer.borderWidth = 0
        sender.backgroundColor = UIColor.colorWithHexString(hex: "E14575")
        sender.setTitleColor(UIColor.white, for: .normal)
        currentSizeBtn = sender
    }
    
    @IBAction func finishChoseSizeBtnDidClick(_ sender: Any) {
        if currentSizeBtn != nil {
            self.hideBuyDetailView()
            self.requestAddCart()
        }else {
            SVProgressHUD.showError(withStatus: "请选择型号")
        }
    }
    
    @IBAction func collectionItemDidClick(_ sender: UIBarButtonItem) {
        self.requestCollection()
    }
    
    @IBAction func shareItemDidClick(_ sender: Any) {
        
    }
    
    @IBAction func buyDetailCancelBtnDidClick(_ sender: Any) {
        self.hideBuyDetailView()
    }
    
    @IBAction func addBtnDidClick(_ sender: Any) {
        if self.goodInfo != nil {
            self.buyDetailView.isHidden = false
            UIView.animate(withDuration: 0.75) {
                self.buyDetailBottom.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @IBAction func buyDetailViewDidTap(_ sender: Any) {
        self.hideBuyDetailView()
    }
    
    @IBAction func cartBtnDidClick(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func hideBuyDetailView() -> Void {
        UIView.animate(withDuration: 0.75, animations: {
            self.buyDetailBottom.constant = -self.modelDetailHeight.constant - 47
            self.view.layoutIfNeeded()
        }) { (finish) in
            self.buyDetailView.isHidden = true
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
            url = "/Public/collect_goods"
            alertStr = "收藏成功"
            param = ["user_id":UserModel.share.userId,"goods_id":self.detailDataSource?["goods_id"] as! String]
        }
        NetworkModel.request(param as NSDictionary, url: url) { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.showSuccess(withStatus: alertStr)
                if self.collectionId.characters.count > 0 {
                    self.goodLikeItem.image = UIImage(named: "good-unlike")
                    self.goodLikeItem.tintColor = UIColor.colorWithHexString(hex: "404146")
                    self.collectionId = ""
                }else {
                    self.goodLikeItem.image = UIImage(named: "good-like")
                    self.goodLikeItem.tintColor = UIColor.colorWithHexString(hex: "E14575")
                    self.collectionId = ((dic as! NSDictionary)["collect_id"] as! NSNumber).stringValue
                }
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
    func requestAddCart() -> Void {
        SVProgressHUD.show()
        let dict = (goodInfo?["goods_size"] as! NSArray)[(currentSizeBtn?.tag)! - 1] as! NSDictionary
        NetworkModel.request(["user_id":UserModel.share.userId,"goods_id":self.detailDataSource?["goods_id"] as! String,"size_id":dict["size_id"] as! String], url: "/Cart/cart_add") { (dic) in
            if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                SVProgressHUD.showSuccess(withStatus: "成功添加到购物车")
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
            }
        }
    }
    
}
