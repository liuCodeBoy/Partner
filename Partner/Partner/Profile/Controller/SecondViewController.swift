//
//  SecondViewController.swift
//  Partner
//
//  Created by Weslie on 19/01/2018.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func back(_ sender: UIButton) {
        
        performSegue(withIdentifier: "backSegue", sender: self)
    }
    

}
