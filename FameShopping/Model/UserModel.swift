//
//  UserModel.swift
//  LocalUser
//
//  Created by YunTu on 2017/1/4.
//  Copyright © 2017年 果儿. All rights reserved.
//

import UIKit

class UserModel: NSObject {

    static let shareInstance = UserModel()
    
    private var _address:String?
    var address:String {
        get{
            if self._address == nil {
                if UserDefaults.standard.object(forKey: "ADDRESS") != nil {
                    self._address = UserDefaults.standard.object(forKey: "ADDRESS") as? String
                    return self._address!
                }
                return ""
            }else{
                return self._address!
            }
        }
    }
    
    private var _birthday:String?
    var birthday:String {
        get{
            if self._birthday == nil {
                if UserDefaults.standard.object(forKey: "BIRTHDAY") != nil {
                    self._birthday = UserDefaults.standard.object(forKey: "BIRTHDAY") as? String
                    return self._birthday!
                }
                return ""
            }else{
                return self._birthday!
            }
        }
    }
    
    private var _avatar:String?
    var avatar:String {
        get{
            if self._avatar == nil {
                if UserDefaults.standard.object(forKey: "AVATAR") != nil {
                    self._avatar = UserDefaults.standard.object(forKey: "AVATAR") as? String
                    if (self._avatar?.hasPrefix("http"))! {
                        
                    }else{
                        self._avatar = Helpers.baseImgUrl() + self._avatar!
                    }
                    return self._avatar!
                }
                return ""
            }else{
                return self._avatar!
            }
        }
    }
    
    private var _money:String?
    var money:String {
        get{
            if self._money == nil {
                if UserDefaults.standard.object(forKey: "MONEY") != nil {
                    self._money = UserDefaults.standard.object(forKey: "MONEY") as? String
                    return self._money!
                }
                return ""
            }else{
                return self._money!
            }
        }
    }
    
    private var _password:String?
    var password:String {
        get{
            if self._password == nil {
                if UserDefaults.standard.object(forKey: "PASSWORD") != nil {
                    self._password = UserDefaults.standard.object(forKey: "PASSWORD") as? String
                    return self._password!
                }
                return ""
            }else{
                return self._password!
            }
        }
    }
    
    private var _regTime:String?
    var regTime:String {
        get{
            if self._regTime == nil {
                if UserDefaults.standard.object(forKey: "REGTIME") != nil {
                    self._regTime = UserDefaults.standard.object(forKey: "REGTIME") as? String
                    return self._regTime!
                }
                return ""
            }else{
                return self._regTime!
            }
        }
    }
    
    private var _userId:String?
    var userId:String {
        get{
            if self._userId == nil {
                if UserDefaults.standard.object(forKey: "USERID") != nil {
                    self._userId = UserDefaults.standard.object(forKey: "USERID") as? String
                    return self._userId!
                }
                return ""
            }else{
                return self._userId!
            }
        }
    }
    
    private var _userName:String?
    var userName:String {
        get{
            if self._userName == nil {
                if UserDefaults.standard.object(forKey: "USERNAME") != nil {
                    self._userName = UserDefaults.standard.object(forKey: "USERNAME") as? String
                    return self._userName!
                }
                return ""
            }else{
                return self._userName!
            }
        }
    }
    
    private var _userPhone:String?
    var userPhone:String {
        get{
            if self._userPhone == nil {
                if UserDefaults.standard.object(forKey: "USERPHONE") != nil {
                    self._userPhone = UserDefaults.standard.object(forKey: "USERPHONE") as? String
                    return self._userPhone!
                }
                return ""
            }else{
                return self._userPhone!
            }
        }
    }
    
    private var _workStatus:String?
    var workStatus:String {
        get{
            if UserDefaults.standard.object(forKey: "WORKSTATUS") != nil {
                self._workStatus = UserDefaults.standard.object(forKey: "WORKSTATUS") as? String
                return self._workStatus!
            }else{
                return "1"
            }
        }
    }
    
    func logout() -> Void {
        _userPhone = nil
        _userName = nil
        _userId = nil
        _money = nil
        _regTime = nil
        _avatar = nil
        _birthday = nil
        _password = nil
        _address = nil
        _workStatus = nil
    }
    
}
