//
//  AppDelegate.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/3.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var drawer: ITRAirSideMenu?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabbar = storyboard.instantiateViewController(withIdentifier: "tabBarVC")
        let menuVC = storyboard.instantiateViewController(withIdentifier: "menu")
        drawer = self.window?.rootViewController as? ITRAirSideMenu
        drawer?.contentViewController = tabbar
        drawer?.leftMenuViewController = menuVC
        WXApi.registerApp("wx7e0e8330c1e9e030")
        return true
    }
    
    func showLeftMenu() {
        drawer?.presentLeftMenuViewController()
    }
    
    func hideLeftMenu(_ indexPath: IndexPath) -> Void {
        drawer?.hideViewController()
        let tabbar = drawer?.contentViewController as! UITabBarController
        ((tabbar.selectedViewController as! UINavigationController).topViewController as! MainViewController).menuTableDidSelect(indexPath)
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if !"\(url)".hasPrefix("wx7e0e8330c1e9e030"){
            AlipaySDK.defaultService().processOrder(withPaymentResult: url) { (dic) in
                SVProgressHUD.dismiss()
                if (dic?["resultStatus"] as! String) == "9000" {
                    SVProgressHUD.showSuccess(withStatus: "支付成功")
                    ((self.drawer?.contentViewController as! UITabBarController).selectedViewController as! UINavigationController).popToRootViewController(animated: true)
                    //                ((self.window?.rootViewController as! UITabBarController).selectedViewController as! UINavigationController).popToRootViewController(animated: true)
                }else{
                    SVProgressHUD.showError(withStatus: dic?["memo"] as! String)
                }
            }
        }
        return WXApi.handleOpen(url, delegate: WXApiManager.shared())
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return WXApi.handleOpen(url, delegate: WXApiManager.shared())
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

