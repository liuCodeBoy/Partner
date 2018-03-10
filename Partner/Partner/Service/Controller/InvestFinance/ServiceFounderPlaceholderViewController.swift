//
//  ServiceFounderPlaceholderViewController.swift
//  Partner
//
//  Created by Weslie on 23/02/2018.
//

import UIKit

class ServiceFounderPlaceholderViewController: UIViewController {
    
    @IBAction func popBtnClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
