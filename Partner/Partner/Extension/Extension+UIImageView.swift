//
//  Extension+UIImageView.swift
//  Partner
//
//  Created by YJ on 2018/3/5.
//

import UIKit

extension UIImageView {

    private struct AssociateKeys {
        static var customProperty = "customProperty"
    }
    
    var isTapped: Bool {
        set(value) {
            objc_setAssociatedObject(self, &AssociateKeys.customProperty, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        get {
            return objc_getAssociatedObject(self, &AssociateKeys.customProperty) as! Bool
        }
    }
    
}
