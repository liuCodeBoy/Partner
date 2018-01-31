//
//  AppDelegate.swift
//  Partner
//
//  Created by Weslie on 25/12/2017.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
//    override init() {
//        super.init()
//        UIViewController.classInit
//    }

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UITabBar.appearance().tintColor = tab_bar_selected_tint

        return true
    }


}

