//
//  AuthApplyUploadViewController.swift
//  Partner
//
//  Created by YJ on 2018/3/5.
//

import UIKit

class AuthApplyUploadViewController: UIViewController {

    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var investAuth: ShadowButton!
    @IBOutlet weak var enterpriseAuth: ShadowButton!

    @IBAction func investAuthClicked(_ sender: ShadowButton) {
        investAuth.setSelected()
        enterpriseAuth.reverseSelected()
    }
    
    @IBAction func enterpriseAuthClicked(_ sender: ShadowButton) {
        investAuth.reverseSelected()
        enterpriseAuth.setSelected()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard UserDefaults.standard.string(forKey: "token") != nil else {
            presentLoginController()
            return
        }
        
    }

}
