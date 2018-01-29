//
//  ModifyPasswordViewController.swift
//  Partner
//
//  Created by Weslie on 17/01/2018.
//

import UIKit

class ModifyPasswordViewController: UIViewController {
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var phoneNumTF: UITextField!
    @IBOutlet weak var idNumTF: UITextField!
    @IBOutlet weak var sendIDNumBtn: UIButton!
    @IBOutlet weak var newPwdTF: UITextField!
    @IBOutlet weak var confirmPwdTF: UITextField!
    
    @IBAction func sendIDNumClicked(_ sender: UIButton) {
    }
    @IBAction func confirmModifyBtnClicked(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // hide tab bar
        self.tabBarController?.tabBar.isHidden = true
    }

}
