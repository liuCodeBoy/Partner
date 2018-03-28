//
//  AppDelegate.swift
//  Partner
//
//  Created by Weslie on 25/12/2017.
//

import UIKit
import NVActivityIndicatorView
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    static let activityData =  ActivityData.init(size: NVActivityIndicatorView.DEFAULT_BLOCKER_SIZE, message: NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE , messageFont: NVActivityIndicatorView.DEFAULT_BLOCKER_MESSAGE_FONT, type: NVActivityIndicatorType.lineScalePulseOutRapid , color: #colorLiteral(red: 0.6219195724, green: 0.7407949567, blue: 0.8080993295, alpha: 1), padding: NVActivityIndicatorView.DEFAULT_PADDING , displayTimeThreshold: NVActivityIndicatorView.DEFAULT_BLOCKER_DISPLAY_TIME_THRESHOLD, minimumDisplayTime: NVActivityIndicatorView.DEFAULT_BLOCKER_MINIMUM_DISPLAY_TIME , backgroundColor: UIColor.clear, textColor: NVActivityIndicatorView.DEFAULT_TEXT_COLOR )

    
    static let RegisterAndLoginVC = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "RegisterAndLoginVCID")
    static let homeVC  = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "PlazaVCID") as! PlazaVC
    static let informationVC  = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "InformationVCID") as! InformationVC
    static let momentVC  = UIStoryboard(name: "Union", bundle: nil).instantiateViewController(withIdentifier: "MomentMainVCID")  as! MomentMainVC
    static let dynamicDetailVC  = UIStoryboard(name: "Union", bundle: nil).instantiateViewController(withIdentifier: "DynamicDetailVCID") as! DynamicDetailVC
   
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UITabBar.appearance().tintColor = tab_bar_selected_tint
        
        return true
    }


}

