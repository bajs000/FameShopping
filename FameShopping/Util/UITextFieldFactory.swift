//
//  UITextFieldFactory.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/3.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit

class UITextFieldFactory: UITextField {

    var left:CGFloat = 20
    var right:CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTarget(self, action: #selector(editDidChange(_:)), for: .editingChanged)
    }
    
    override func borderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: left, bottom: 0, right: right))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: left, bottom: 0, right: right))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: left, bottom: 0, right: right))
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: left, bottom: 0, right: right))
    }
    
    func editDidChange(_ sender:UITextField) -> Void {
        
    }

}

class PhoneTextField: UITextFieldFactory {
    
    @IBInspectable var leftIcon:UIImage?
    @IBInspectable var rightIcon:UIImage?
    var rightBtn:UIButton?
    
    override func awakeFromNib() {
        let imgBg = UIImageView.init(image: leftIcon)
        imgBg.frame = CGRect(x: 0, y: 0, width: (leftIcon?.size.width)! + 16, height: self.bounds.size.height)
        imgBg.contentMode = .center
        self.leftView = imgBg
        self.leftViewMode = .always
        left = imgBg.frame.size.width
        
        if rightIcon != nil {
            rightBtn = UIButton(type: .custom)
            rightBtn?.frame = CGRect(x: 0, y: 0, width: (rightIcon?.size.width)! + 16, height: self.bounds.size.height)
            rightBtn?.setImage(self.rightIcon, for: .normal)
            rightBtn?.contentMode = .center
            self.rightView = rightBtn
            self.rightViewMode = .always
            right = (rightBtn?.frame.size.width)!
        }
        super.awakeFromNib()
        
        self.addTarget(self, action: #selector(textFieldDidBeginEdit(_:)), for: .editingDidBegin)
        self.addTarget(self, action: #selector(textFieldDidBeginEdit(_:)), for: .editingDidEnd)
    }
    
    func textFieldDidBeginEdit(_ sender:UITextField) {
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setLineCap(.round)
        context.setLineWidth(1)
        context.setAllowsAntialiasing(true)
        if self.isEditing {
            context.setStrokeColor(red: 168.0 / 255.0, green: 214.0 / 255.0, blue: 94.0 / 255.0, alpha: 1.0)
        }else{
            context.setStrokeColor(red: 170.0 / 255.0, green: 170.0 / 255.0, blue: 170.0 / 255.0, alpha: 1.0)
        }
        context.beginPath()
        context.move(to: CGPoint(x: 0, y: self.bounds.size.height - 1))
        context.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height - 1))
        context.strokePath()
    }
    
}
