//
//  Helpers.swift
//  LocalUser
//
//  Created by YunTu on 2016/12/20.
//  Copyright © 2016年 果儿. All rights reserved.
//

import Foundation
import UIKit

class Helpers : NSObject {
    
    public class func screanSize() -> CGSize{
        return UIScreen.main.bounds.size
    }
    
    public class func baseImgUrl() -> String {
        return "http://mingpinhui.cq1b1.com/"
    }
    
    public class func findSuperViewClass(_ className:AnyClass,with view:UIView) -> UIView? {
        var superView:UIView? = view
        for _ in 0...10 {
            superView = superView?.superview
            if superView!.isKind(of: className) {
                return superView
            }
        }
        return superView
    }
    
    public class func image(_ image:UIImage, with color:UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        let context = UIGraphicsGetCurrentContext()
        context!.translateBy(x: 0,y: image.size.height)
        context!.scaleBy(x: 1.0, y: -1.0)
        context!.setBlendMode(.normal)
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        context!.clip(to: rect, mask: image.cgImage!)
        color.setFill()
        context!.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        return newImage!
    }
    
}
