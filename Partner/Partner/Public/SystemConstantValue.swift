//
//  SystemConstantValue.swift
//  Neighbourhoods
//
//  Created by Weslie on 22/10/2017.
//  Copyright © 2017 NJQL. All rights reserved.
//

import UIKit

let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

let keyboardShowNotification = "com.Partner.keyboardWillShow"
let keyboardHideNotification = "com.Partner.keyboardWillHide"

let localVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

let isIPHONEX: Bool = { () -> Bool in
    if screenHeight == 812.0 && screenWidth == 375.0 {
        return true
    } else {
        return false
    }
}()

let isIPHONE_SE: Bool = { () -> Bool in
    if screenHeight == 568.0 && screenWidth == 320.0 {
        return true
    } else {
        return false
    }
}()

