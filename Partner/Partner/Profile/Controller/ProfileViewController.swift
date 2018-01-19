//
//  ProfileViewController.swift
//  Partner
//
//  Created by Weslie on 16/01/2018.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickNameLbl: UILabel!
    @IBOutlet weak var genderImg: UIImageView!
    @IBOutlet weak var verifyLbl: UILabel!
    @IBOutlet weak var loginOrRegisterBtn: UIButton!
    @IBOutlet weak var dataIntegrityLbl: UILabel!
    @IBOutlet weak var dataIntegrityProgressWidthCons: NSLayoutConstraint!
    
    @IBOutlet weak var backImageHeightCons: NSLayoutConstraint!
    
    @IBAction func loginOrRegisterBtnClicked(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        if isIPHONEX {
            backImageHeightCons.constant += 24
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide tab bar
        self.tabBarController?.tabBar.isHidden = false
    }



}
