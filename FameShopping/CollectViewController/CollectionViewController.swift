//
//  CollectionViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/8.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "收藏"
        let bar = self.navigationController?.navigationBar
        let navBarHeight = 100.0
        let rect = CGRect(x: 0.0, y: 20.0, width: Double(Helpers.screanSize().width), height: navBarHeight)
        bar?.frame = rect
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
