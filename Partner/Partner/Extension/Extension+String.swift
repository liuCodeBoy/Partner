//
//  Extension+String.swift
//  Neighbourhoods
//
//  Created by LiuXinQiang on 2017/11/1.
//  Copyright © 2017年 NJQL. All rights reserved.
//

import UIKit

extension String {
//   static func getLabHeight(labelStr: String, font: UIFont, width: CGFloat) -> CGFloat {
//        let statusLabelText = labelStr
//        let size = CGSize(width: width, height: 900)
//    let dic = NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
//    let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedStringKey : Any] , context: nil).size
//        return strSize.height
//    }
    
    //MARK: - judge wheather the phone number is valid or not
    
    var isEmptyString: Bool {
        get {
            if self.replacingOccurrences(of: " ", with: "") == "" || self == "" {
                return true
            } else {
                return false
            }
        }
        set {
            
        }
    }
    
    var isValidePhoneNumber: Bool {
        get {
            let mobileRE: String = "^((13[0-9])|(147)|(15[0-3,5-9])|(16[0,0-9])|(18[0,0-9])|(17[0-3,5-9]))\\d{8}$"
            let regex = NSPredicate(format: "SELF MATCHES %@", mobileRE)
            
            if regex.evaluate(with: self) == true {
                return true
            } else {
                return false
            }
        }
        set { }
    }
    
    var isValidIDNumber: Bool {
        get {
            let mobileRE: String = "^\\d{15}$)|(^\\d{17}([0-9]|X)$"
            let regex = NSPredicate(format: "SELF MATCHES %@", mobileRE)
            
            if regex.evaluate(with: self) == true {
                return true
            } else {
                return false
            }
        }
        set { }
    }
    
    var isValidEmail: Bool {
        get {
            let mobileRE: String = "^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$"
            let regex = NSPredicate(format: "SELF MATCHES %@", mobileRE)
            
            if regex.evaluate(with: self) == true {
                return true
            } else {
                return false
            }
        }
        set { }
    }
    
    var isValidPassword: Bool {
        get {
            let pwdRE: String = "^((?!\\d+$)(?![a-zA-Z]+$)[a-zA-Z\\d@#$%^&_+].{5,19})+$"
            let regex = NSPredicate(format: "SELF MATCHES %@", pwdRE)
            
            if regex.evaluate(with: self) == true {
                return true
            } else {
                return false
            }
        }
        set { }
    }

}

