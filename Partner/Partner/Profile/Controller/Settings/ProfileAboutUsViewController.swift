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

    }
    
    @IBAction func rateClicked(_ sender: UIButton) {
        // FIXME:- jump to app store
        
    }
    

}
