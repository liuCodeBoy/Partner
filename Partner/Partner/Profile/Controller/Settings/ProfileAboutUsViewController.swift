//
//  ProfileAboutUsViewController.swift
//  Partner
//
//  Created by YJ on 2018/3/14.
//

import UIKit

class ProfileAboutUsViewController: UIViewController {
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var versionLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        versionLbl.text = "当前版本：\(localVersion)"

    }
    
    @IBAction func rateClicked(_ sender: UIButton) {
        // FIXME:- jump to app store
        
        let AppID = "1360096509"
        if let URL = URL(string: "https://itunes.apple.com/us/app/id\(AppID)?ls=1&mt=8") {
//            UIApplication.shared.openURL(URL as URL)
            UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        }
        
    }
    

}
