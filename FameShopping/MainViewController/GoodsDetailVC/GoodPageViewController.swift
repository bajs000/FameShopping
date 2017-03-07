//
//  GoodPageViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/7.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import Masonry

class GoodPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    
    @IBOutlet var bottomView: UIView!
    @IBOutlet weak var addBtn: UIButton!
    
    var VCArr = [GoodBaseVC]()
    var detailDataSource:NSDictionary?
    var goodInfo:NSDictionary?{
        didSet{
            let dic = self.goodInfo?["list"] as? NSDictionary
            self.addBtn.setTitle("￥" + (dic?["price"] as! String) + "加入购物车", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        self.addBtn.layer.cornerRadius = 4
        
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

}
