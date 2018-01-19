//
//  HomeViewController.swift
//  Partner
//
//  Created by Weslie on 19/01/2018.
//

import UIKit

class HomeViewController: UIViewController {

    @IBAction func loginBtnClicked(_ sender: UIButton) {
        let login = UIStoryboard.init(name: "Login", bundle: nil).instantiateInitialViewController()!
        self.present(login, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
