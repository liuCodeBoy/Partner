//
//  MyProjectNoneProjectPlaceholderViewController.swift
//  Partner
//
//  Created by Weslie on 25/01/2018.
//

import UIKit

class MyProjectNoneProjectPlaceholderViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func createClicked(_ sender: ShadowButton) {
        let vc = UIStoryboard.init(name: "MyHomePage", bundle: nil).instantiateViewController(withIdentifier: "CreateProject") as! MyProjectEditAndCreateViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
