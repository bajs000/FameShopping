//
//  OrderPageViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/9.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import Masonry

class OrderBaseVC: UITableViewController {
    var pageIndex = 0
    var pageViewController:OrderPageViewController?
}

class OrderPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    @IBOutlet var headerView: NavBarExtend!
    var VCArr = [OrderBaseVC]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "全部订单"
        self.delegate = self
        self.dataSource = self
        
        self.initViewController()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController!.navigationBar.shadowImage = #imageLiteral(resourceName: "TransparentPixel")
        self.navigationController!.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "TransparentPixel"), for: .default)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    public class func getInstance() -> OrderPageViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "orderPage")
        return vc as! OrderPageViewController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - init
    func initViewController() -> Void {
        let all = AllOrderViewController.getInstance()
        self.setPageControl(all, index: 0)
        let needPay = NeedPayViewController.getInstance()
        self.setPageControl(needPay, index: 1)
        let needAccept = NeedAcceptViewController.getInstance()
        self.setPageControl(needAccept, index: 2)
        let needEvaluate = NeedEvaluateViewController.getInstance()
        self.setPageControl(needEvaluate, index: 3)
        let refund = RefundViewController.getInstance()
        self.setPageControl(refund, index: 4)
        VCArr = [all,needPay,needAccept,needEvaluate,refund]
        self.setViewControllers([VCArr[0]], direction: .reverse, animated: true, completion: nil)
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.view.addSubview(self.headerView)
        self.headerView.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(self.view.mas_top)
            _ = make?.left.equalTo()(self.view.mas_left)
            _ = make?.right.equalTo()(self.view.mas_right)
            _ = make?.height.equalTo()(41)
        }
    }
    
    func setPageControl(_ sender: OrderBaseVC, index: Int) -> Void {
        sender.pageIndex = index
        sender.pageViewController = self
    }
    
    // MARK: - UIPageViewController delegate
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if (viewController as! OrderBaseVC).pageIndex == 4 {
            return VCArr[3]
        }else if (viewController as! OrderBaseVC).pageIndex == 3 {
            return VCArr[2]
        }else if (viewController as! OrderBaseVC).pageIndex == 2 {
            return VCArr[1]
        }else if (viewController as! OrderBaseVC).pageIndex == 1 {
            return VCArr[0]
        }else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if (viewController as! OrderBaseVC).pageIndex == 0 {
            return VCArr[1]
        }else if (viewController as! OrderBaseVC).pageIndex == 1 {
            return VCArr[2]
        }else if (viewController as! OrderBaseVC).pageIndex == 2 {
            return VCArr[3]
        }else if (viewController as! OrderBaseVC).pageIndex == 3 {
            return VCArr[4]
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
    
    @IBAction func orderStatusBtnDidClick(_ sender: UIButton) {
        for i in 1...5 {
            let btn = sender.superview?.viewWithTag(i)
            (btn as! UIButton).setTitleColor(#colorLiteral(red: 0.3190122843, green: 0.324126184, blue: 0.3451784253, alpha: 1), for: .normal)
        }
        sender.setTitleColor(#colorLiteral(red: 0.9144125581, green: 0.3713477254, blue: 0.5323973894, alpha: 1), for: .normal)
    }

}
